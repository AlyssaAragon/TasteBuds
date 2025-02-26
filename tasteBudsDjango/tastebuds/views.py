from django.contrib.auth import get_user_model
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
import random
from django.shortcuts import redirect
from rest_framework.decorators import action
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


class SavedRecipeViewSet(viewsets.ModelViewSet):
    queryset = SavedRecipe.objects.all()
    serializer_class = SavedRecipeSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        #filters to return the user's saved recipes
        return SavedRecipe.objects.filter(user=self.request.user)

    @action(detail=False, methods=['GET'])
    def shared_favorites(self, request):
        #returns recipes liked by both the user and their partner
        if not request.user.partnerid:
            return Response({"error": "No partner found"}, status=400)

        user_favorites = SavedRecipe.objects.filter(user=request.user).values_list('recipe_id', flat=True)
        shared_favorites = SavedRecipe.objects.filter(user_id=request.user.partnerid, recipe_id__in=user_favorites)

        return Response(SavedRecipeSerializer(shared_favorites, many=True).data)


# UserDiet views
class UserDietViewSet(viewsets.ModelViewSet):
    queryset = UserDiet.objects.all()
    serializer_class = UserDietSerializer


from django.http import HttpResponse

def home(request):
    return HttpResponse("Welcome to TasteBuds!")

