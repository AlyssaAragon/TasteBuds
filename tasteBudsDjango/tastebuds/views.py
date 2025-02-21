from django.contrib.auth import get_user_model
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
import random
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
