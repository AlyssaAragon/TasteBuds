from django.contrib.auth import get_user_model, authenticate
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.hashers import make_password
from django.db.models import Q
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
import random
import json
from allauth.account.views import LoginView, SignupView
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from .models import Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet, CustomUser, Category, RecipeCategory
from .serializers import (
    UserSerializer, RecipeSerializer, DietSerializer, RecipeDietSerializer,
    SavedRecipeSerializer, UserDietSerializer, PartnerLinkSerializer
)

User = get_user_model()

# --- API SIGNUP ENDPOINT (CSRF-EXEMPT) ---
@api_view(['POST'])
@csrf_exempt
def api_signup(request):
    # Extract required fields from the request data
    email = request.data.get('email')
    username = request.data.get('username')
    password = request.data.get('password')
    
    # Validate required fields
    if not email or not username or not password:
        return Response(
            {"error": "Email, username, and password are required."},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    try:
        # Create the user using your custom manager
        user = CustomUser.objects.create_user(email=email, password=password, username=username)
    except Exception as e:
        return Response(
            {"error": str(e)},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    return Response({"message": "User created successfully."}, status=status.HTTP_200_OK)


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
        'userid': user.id,  # Use user.id for consistency
        'username': user.username,
        'email': user.email,
        'firstlastname': user.firstlastname,
    }
    # Include partner details if available
    if user.partner:
        user_data['partner'] = {
            'userid': user.partner.id,
            'username': user.partner.username,
            'email': user.partner.email,
        }
    return Response(user_data)


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
        "recipeid": random_recipe_obj.recipeid,
        "title": random_recipe_obj.title,
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
        "recipeid": random_recipe_obj.recipeid,
        "title": random_recipe_obj.title,
        "ingredients": random_recipe_obj.ingredients,
        "instructions": random_recipe_obj.instructions,
        "image_name": random_recipe_obj.image_name,
        "cleaned_ingredients": random_recipe_obj.cleaned_ingredients
    })


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
        "recipeid": random_recipe_obj.recipeid,
        "title": random_recipe_obj.title,
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


class SavedRecipeViewSet(viewsets.ModelViewSet):
    queryset = SavedRecipe.objects.all()
    serializer_class = SavedRecipeSerializer


class UserDietViewSet(viewsets.ModelViewSet):
    queryset = UserDiet.objects.all()
    serializer_class = UserDietSerializer


# --- MISC VIEWS ---

def home(request):
    return HttpResponse("Welcome to TasteBuds!")


class LinkPartnerAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, format=None):
        serializer = PartnerLinkSerializer(data=request.data)
        if serializer.is_valid():
            partner_email = serializer.validated_data['partner_email']
            try:
                partner = CustomUser.objects.get(email=partner_email)
            except CustomUser.DoesNotExist:
                return Response({'error': 'No user found with that email.'},
                                status=status.HTTP_404_NOT_FOUND)

            if partner == request.user:
                return Response({'error': 'You cannot link with your own account.'},
                                status=status.HTTP_400_BAD_REQUEST)

            if partner.partner is not None and partner.partner != request.user:
                return Response({'error': 'This user is already linked with another account.'},
                                status=status.HTTP_400_BAD_REQUEST)

            request.user.partner = partner
            partner.partner = request.user
            request.user.save()
            partner.save()

            return Response({'message': 'Partner linked successfully!'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@method_decorator(csrf_exempt, name='dispatch')
class ExemptLoginView(LoginView):
    pass


@method_decorator(csrf_exempt, name='dispatch')
class ExemptSignupView(SignupView):
    pass




