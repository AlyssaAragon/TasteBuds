from django.contrib.auth import get_user_model, authenticate
from django.http import JsonResponse
from django.contrib.auth.hashers import make_password
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
import random
import json
from django.shortcuts import redirect
from .models import Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet
from .serializers import (
    UserSerializer, RecipeSerializer, DietSerializer, RecipeDietSerializer, 
    SavedRecipeSerializer, UserDietSerializer
)

User = get_user_model()

# View to get a random recipe (for the swiping)
@api_view(['GET'])
def random_recipe(request):
    recipes = Recipe.objects.all()
    if not recipes.exists():
        return Response({"message": "No recipes available."}, status=404)
    recipe = random.choice(recipes)
    serializer = RecipeSerializer(recipe)
    return Response(serializer.data)

# View to get the current user's profile data
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_profile(request):
    user = request.user
    user_data = {'username': user.username}
    return Response(user_data)

# Diet filter
@api_view(['GET'])
def filter_recipes(request):
    dietary_preferences = request.GET.getlist('tags')
    recipes = Recipe.objects.all()

    if dietary_preferences:
        query = Q()
        for preference in dietary_preferences:
            query |= Q(tags__icontains=preference) | Q(search_terms__icontains=preference)
        recipes = recipes.filter(query)

    if not recipes.exists():
        return Response({"message": "No recipes found matching your criteria."})

    recipe = random.choice(list(recipes))
    serializer = RecipeSerializer(recipe)
    return Response(serializer.data)

# User views
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Recipe views
class RecipeViewSet(viewsets.ModelViewSet):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

# Diet views
class DietViewSet(viewsets.ModelViewSet):
    queryset = Diet.objects.all()
    serializer_class = DietSerializer

# RecipeDiet views
class RecipeDietViewSet(viewsets.ModelViewSet):
    queryset = RecipeDiet.objects.all()
    serializer_class = RecipeDietSerializer

# SavedRecipe views
class SavedRecipeViewSet(viewsets.ModelViewSet):
    queryset = SavedRecipe.objects.all()
    serializer_class = SavedRecipeSerializer

# UserDiet views
class UserDietViewSet(viewsets.ModelViewSet):
    queryset = UserDiet.objects.all()
    serializer_class = UserDietSerializer


from django.http import HttpResponse

def home(request):
    return HttpResponse("Welcome to TasteBuds!")

@api_view(['POST'])
def login_view(request):
    data = json.loads(request.body)
    email = data.get("email")
    password = data.get("password")

    user = authenticate(request, username=email, password=password)

    if user:
        return Response({"success": True, "message": "Login successful", "userid": user.userid})
    else:
        return Response({"success": False, "message": "Invalid credentials"}, status=400)
    
@api_view(['POST'])
def signup_view(request):
    data = json.loads(request.body)
    email = data.get("email")
    username = data.get("username")
    password = data.get("password")

    if User.objects.filter(email=email).exists():
        return Response({"success": False, "message": "Email already taken"}, status=400)

    user = User.objects.create(
        email=email,
        username=username,
        password=make_password(password)
    )

    return Response({"success": True, "message": "User created", "userid": user.userid})