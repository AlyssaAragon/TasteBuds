from django.contrib.auth import get_user_model, authenticate
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.hashers import make_password
from django.db.models import Q
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
import random
import json
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .models import PartnerRequest, CustomUser
from .serializers import PartnerLinkSerializer
from rest_framework import generics, permissions
from .models import PrivateRecipe
from .serializers import PrivateRecipeSerializer
from django.core.mail import send_mail
from django.conf import settings
from allauth.account.views import LoginView, SignupView
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from .serializers import UserDietUpdateSerializer
from .models import Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet, CustomUser, Category, RecipeCategory
from .serializers import (
	UserSerializer, RecipeSerializer, DietSerializer, RecipeDietSerializer,
	SavedRecipeSerializer, UserDietSerializer, PartnerLinkSerializer, RegisterUserSerializer
)
from rest_framework import serializers
from django.contrib.auth import update_session_auth_hash

User = get_user_model()



@api_view(['POST'])
@csrf_exempt
def api_signup(request):
	serializer = RegisterUserSerializer(data=request.data)
	if serializer.is_valid():
    	serializer.save()
    	return Response({"message": "User created successfully."}, status=status.HTTP_201_CREATED)
	return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# --- RECIPE & USER ENDPOINTS ---

@api_view(['GET'])
def random_recipe(request):
	recipes = Recipe.objects.all()
	if not recipes.exists():
    	return Response({"message": "No recipes available."}, status=404)
	recipe = random.choice(recipes)
	serializer = RecipeSerializer(recipe)
	return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_profile(request):
	user = request.user

	user_data = {
    	'userid': user.id,
    	'username': user.username,
    	'email': user.email,
    	'firstlastname': user.firstlastname,
    	'diets': []
	}

	try:
    	user_diets = UserDiet.objects.filter(user=user).select_related('diet')
    	print(f"[DEBUG] Query returned {user_diets.count()} UserDiet entries for user {user.id}")


    	for ud in user_diets:
        	try:
            	diet_name = ud.diet.dietname.strip().lower()
            	user_data['diets'].append({
                	"id": ud.diet.dietid,
                	"dietname": diet_name
            	})
        	except Exception as e:
            	print(f"[WARNING] Skipped UserDiet {ud.userdietid} — {e}")
	except Exception as e:
    	print(f"[ERROR] Failed to load user diets: {e}")

	if user.partner:
    	user_data['partner'] = {
        	'userid': user.partner.id,
        	'username': user.partner.username,
        	'email': user.partner.email,
    	}

	return Response(user_data)




class SavedRecipeViewSet(viewsets.ModelViewSet):
	queryset = SavedRecipe.objects.all()
	serializer_class = SavedRecipeSerializer
	permission_classes = [IsAuthenticated]
	lookup_field = 'savedid'  # Critical for DELETE to work with /api/savedrecipe/<savedid>/

	def get_queryset(self):
    	qs = SavedRecipe.objects.filter(user=self.request.user)
    	print(f"[DEBUG] Allowed savedids for {self.request.user.email}: {[s.savedid for s in qs]}")
    	return qs


	def perform_create(self, serializer):
    	if 'recipe_id' not in self.request.data:
        	raise serializers.ValidationError({'recipe_id': 'This field is required.'})
    	serializer.save(user=self.request.user)

	def create(self, request, *args, **kwargs):
    	return super().create(request, *args, **kwargs)

	@action(detail=False, methods=['GET'])
	def shared_favorites(self, request):
    	if not request.user.partner:
        	return Response({"error": "No partner found"}, status=400)

    	user_favorites = SavedRecipe.objects.filter(user=request.user).values_list('recipe_id', flat=True)
    	shared_favorites = SavedRecipe.objects.filter(user=request.user.partner, recipe_id__in=user_favorites)

    	return Response(SavedRecipeSerializer(shared_favorites, many=True).data)





@api_view(['GET'])
def filter_recipes_by_diet(request):
	# Expect dietary preferences via query parameters, e.g., ?diet=vegetarian&diet=vegan
	dietary_preferences = request.GET.getlist('diet')
	recipes = Recipe.objects.all()

	if dietary_preferences:
    	for pref in dietary_preferences:
        	p = pref.lower()
        	if p == 'vegetarian':
            	recipes = recipes.filter(recipediet__vegetarian=True)
        	elif p == 'vegan':
            	recipes = recipes.filter(recipediet__vegan=True)
        	elif p in ['gluten_free', 'gluten-free']:
            	recipes = recipes.filter(recipediet__gluten_free=True)
        	elif p in ['dairy_free', 'dairy-free']:
            	recipes = recipes.filter(recipediet__dairy_free=True)
        	elif p in ['nut_free', 'nut-free']:
            	recipes = recipes.filter(recipediet__nut_free=True)
        	elif p in ['low_carb', 'low-carb']:
            	recipes = recipes.filter(recipediet__low_carb=True)
        	elif p == 'keto':
            	recipes = recipes.filter(recipediet__keto=True)
        	elif p == 'paleo':
            	recipes = recipes.filter(recipediet__paleo=True)

	if not recipes.exists():
    	return Response({"message": "No recipes found matching your criteria."}, status=404)

	random_recipe_obj = random.choice(list(recipes))
	data = {
    	"id": random_recipe_obj.recipeid,
    	"name": random_recipe_obj.title,
    	"ingredients": random_recipe_obj.ingredients,
    	"instructions": random_recipe_obj.instructions,
    	"image_name": random_recipe_obj.image_name,
    	"cleaned_ingredients": random_recipe_obj.cleaned_ingredients,
	}
	return Response(data)


@api_view(['GET'])
def get_random_recipe_by_category(request):
	category_name = request.GET.get("category")

	if not category_name:
    	return Response({"error": "Category parameter is required."}, status=400)

	try:
    	category = Category.objects.get(category_name=category_name)
	except Category.DoesNotExist:
    	return Response({"error": "Invalid category name."}, status=404)

	recipes = Recipe.objects.filter(categories__category=category).distinct()

	if not recipes.exists():
    	return Response({"error": "No recipes found for this category."}, status=404)

	random_recipe_obj = random.choice(list(recipes))
	return Response({
    	"id": random_recipe_obj.recipeid,
    	"name": random_recipe_obj.title,
    	"ingredients": random_recipe_obj.ingredients,
    	"instructions": random_recipe_obj.instructions,
    	"image_name": random_recipe_obj.image_name,
    	"cleaned_ingredients": random_recipe_obj.cleaned_ingredients
	})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def remove_partner(request):
	user = request.user
	if user.partner:
    	partner = user.partner
    	partner.partner = None
    	partner.save()
    	user.partner = None
    	user.save()
    	return Response({'message': 'Partner disconnected successfully'})
	return Response({'message': 'No partner to disconnect'}, status=400)

@api_view(['GET'])
def filter_recipes_combined(request):
	category_name = request.GET.get("category")   # e.g., "meal"
	dietary_preferences = request.GET.getlist('diet')  # e.g., ["vegetarian"]

	recipes = Recipe.objects.all()

	# Filter by category if provided
	if category_name:
    	try:
        	category = Category.objects.get(category_name=category_name)
        	recipes = recipes.filter(categories__category=category)
    	except Category.DoesNotExist:
        	return Response({"error": "Invalid category name."}, status=404)

	# Filter by dietary preferences
	if dietary_preferences:
    	for pref in dietary_preferences:
        	p = pref.lower()
        	if p == 'vegetarian':
            	recipes = recipes.filter(recipediet__vegetarian=True)
        	elif p == 'vegan':
            	recipes = recipes.filter(recipediet__vegan=True)
        	elif p in ['gluten_free', 'gluten-free']:
            	recipes = recipes.filter(recipediet__gluten_free=True)
        	elif p in ['dairy_free', 'dairy-free']:
            	recipes = recipes.filter(recipediet__dairy_free=True)
        	elif p in ['nut_free', 'nut-free']:
            	recipes = recipes.filter(recipediet__nut_free=True)
        	elif p in ['low_carb', 'low-carb']:
            	recipes = recipes.filter(recipediet__low_carb=True)
        	elif p == 'keto':
            	recipes = recipes.filter(recipediet__keto=True)
        	elif p == 'paleo':
            	recipes = recipes.filter(recipediet__paleo=True)

	if not recipes.exists():
    	return Response({"message": "No recipes found matching your criteria."}, status=404)

	random_recipe_obj = random.choice(list(recipes))
	data = {
    	"id": random_recipe_obj.recipeid,
    	"name": random_recipe_obj.title,
    	"ingredients": random_recipe_obj.ingredients,
    	"instructions": random_recipe_obj.instructions,
    	"image_name": random_recipe_obj.image_name,
    	"cleaned_ingredients": random_recipe_obj.cleaned_ingredients,
	}
	return Response(data)



class UserProfileViewSet(viewsets.ModelViewSet):
	queryset = User.objects.all()
	serializer_class = UserSerializer


class RecipeViewSet(viewsets.ModelViewSet):
	queryset = Recipe.objects.all()
	serializer_class = RecipeSerializer


class DietViewSet(viewsets.ModelViewSet):
	queryset = Diet.objects.all()
	serializer_class = DietSerializer


class RecipeDietViewSet(viewsets.ModelViewSet):
	queryset = RecipeDiet.objects.all()
	serializer_class = RecipeDietSerializer


class UserDietViewSet(viewsets.ModelViewSet):
	queryset = UserDiet.objects.all()
	serializer_class = UserDietSerializer


# --- MISC VIEWS ---

def home(request):
	return HttpResponse("Welcome to TasteBuds!")


class LinkPartnerAPIView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, format=None):
    	print("DEBUG request.data:", request.data)

    	serializer = PartnerLinkSerializer(data=request.data)

    	if serializer.is_valid():
        	partner_email = serializer.validated_data['partner_email']
        	print("Partner email validated:", partner_email)

        	# Check if user exists
        	try:
            	to_user = CustomUser.objects.get(email__iexact=partner_email)
        	except CustomUser.DoesNotExist:
            	print("No user found with email:", partner_email)
            	return Response({'error': 'No user found with that email.'}, status=status.HTTP_404_NOT_FOUND)

        	if to_user == request.user:
            	print("Tried to partner with self")
            	return Response({'error': 'You cannot partner with yourself.'}, status=status.HTTP_400_BAD_REQUEST)

        	if request.user.partner or to_user.partner:
            	print("One of the users is already partnered")
            	return Response({'error': 'One of you is already linked with another account.'}, status=status.HTTP_400_BAD_REQUEST)

        	if PartnerRequest.objects.filter(from_user=request.user, to_user=to_user, accepted=False).exists():
            	print("Partner request already exists")
            	return Response({'error': 'Partner request already sent.'}, status=status.HTTP_400_BAD_REQUEST)

        	PartnerRequest.objects.create(from_user=request.user, to_user=to_user)
        	print("Partner request created successfully")
        	return Response({'message': 'Partner request sent successfully.'}, status=status.HTTP_201_CREATED)

    	print("Serializer failed:", serializer.errors)
    	return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)







@api_view(['POST'])
@permission_classes([IsAuthenticated])
def send_partner_request(request):
	partner_email = request.data.get('partner_email')
	if not partner_email:
    	return Response({'error': 'Partner email is required.'}, status=400)

	try:
    	to_user = CustomUser.objects.get(email__iexact=partner_email)
	except CustomUser.DoesNotExist:
    	return Response({'error': 'No user found with that email.'}, status=404)

	if to_user == request.user:
    	return Response({'error': 'You cannot send a partner request to yourself.'}, status=400)

	if request.user.partner or to_user.partner:
    	return Response({'error': 'One of you is already linked to a partner.'}, status=400)

	from .models import PartnerRequest
	if PartnerRequest.objects.filter(from_user=request.user, to_user=to_user).exists():
    	return Response({'error': 'Partner request already sent.'}, status=400)

	PartnerRequest.objects.create(from_user=request.user, to_user=to_user)
	return Response({'message': 'Partner request sent.'}, status=201)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_partner_requests(request):
	from .models import PartnerRequest
	pending_requests = PartnerRequest.objects.filter(to_user=request.user, accepted=False)

	data = [
    	{
        	"id": pr.id,
        	"from_user": {
            	"email": pr.from_user.email,
            	"username": pr.from_user.username,
            	"user_id": pr.from_user.id,
        	},
        	"created_at": pr.created_at
    	}
    	for pr in pending_requests
	]

	return Response(data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def respond_to_partner_request(request):
	from .models import PartnerRequest

	request_id = request.data.get('request_id')
	action = request.data.get('action')  # should be "accept" or "decline"

	if not request_id or action not in ['accept', 'decline']:
    	return Response({'error': 'Invalid data.'}, status=400)

	try:
    	partner_request = PartnerRequest.objects.get(id=request_id, to_user=request.user, accepted=False)
	except PartnerRequest.DoesNotExist:
    	return Response({'error': 'Request not found or already handled.'}, status=404)

	if action == 'accept':
    	from_user = partner_request.from_user
    	to_user = partner_request.to_user

    	if from_user.partner or to_user.partner:
        	return Response({'error': 'One of you is already linked to a partner.'}, status=400)

    	from_user.partner = to_user
    	to_user.partner = from_user
    	from_user.save()
    	to_user.save()

    	partner_request.accepted = True
    	partner_request.save()

    	return Response({'message': 'Partner request accepted.'}, status=200)

	elif action == 'decline':
    	partner_request.delete()
    	return Response({'message': 'Partner request declined.'}, status=200)






@method_decorator(csrf_exempt, name='dispatch')
class ExemptLoginView(LoginView):
	pass


@method_decorator(csrf_exempt, name='dispatch')
class ExemptSignupView(SignupView):
	pass



class PrivateRecipeListCreateView(generics.ListCreateAPIView):
	serializer_class = PrivateRecipeSerializer
	permission_classes = [permissions.IsAuthenticated]

	def get_queryset(self):
    	user = self.request.user
    	partner = user.partnerid
    	return PrivateRecipe.objects.filter(models.Q(user=user) | models.Q(user=partner))

	def perform_create(self, serializer):
    	serializer.save(user=self.request.user)

from rest_framework.permissions import BasePermission

class IsOwnerOrPartner(BasePermission):
	def has_object_permission(self, request, view, obj):
    	return obj.user == request.user or obj.user == request.user.partnerid

class PrivateRecipeDetailView(generics.RetrieveUpdateDestroyAPIView):
	serializer_class = PrivateRecipeSerializer
	permission_classes = [permissions.IsAuthenticated, IsOwnerOrPartner]

	def get_queryset(self):
    	user = self.request.user
    	partner = user.partnerid
    	return PrivateRecipe.objects.filter(models.Q(user=user) | models.Q(user=partner))




@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_user_diets(request):
	serializer = UserDietUpdateSerializer(data=request.data)
	if serializer.is_valid():
    	user = request.user
    	new_diets = serializer.validated_data['diets']

    	# Clear existing
    	UserDiet.objects.filter(user=user).delete()

    	# Add new
    	for diet_name in new_diets:
        	try:
            	diet = Diet.objects.get(dietname__iexact=diet_name)
            	UserDiet.objects.create(user=user, diet=diet)
        	except Diet.DoesNotExist:
            	continue  # Ignore unrecognized diets

    	return Response({"message": "Diet preferences updated successfully."})
	return Response(serializer.errors, status=400)







    def get_queryset(self):
        user = self.request.user
        partner = user.partnerid
        return PrivateRecipe.objects.filter(models.Q(user=user) | models.Q(user=partner))



@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    user = request.user
    old_password = request.data.get('old_password')
    new_password = request.data.get('new_password')
    confirm_password = request.data.get('confirm_password')

    if not user.check_password(old_password):
        return Response({'error': 'Incorrect old password'}, status=status.HTTP_400_BAD_REQUEST)

    if new_password != confirm_password:
        return Response({'error': 'New passwords do not match'}, status=status.HTTP_400_BAD_REQUEST)

    user.set_password(new_password)
    user.save()
    update_session_auth_hash(request, user)

    return Response({'message': 'Password changed successfully'})

