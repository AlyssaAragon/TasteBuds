# Alyssa and Hannah
from django.contrib.auth import get_user_model
from .models import AllRecipe, Diet, Favorite, Partner, Recipe  # Include all models
from .serializers import UserSerializer, RecipeSerializer, AllRecipeSerializer, DietSerializer, FavoriteSerializer, PartnerSerializer
from rest_framework import viewsets
import random
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q

User = get_user_model()

# View to get a random recipe (for the swiping)
@api_view(['GET'])
def random_recipe(request):
    recipes = AllRecipe.objects.all()
    if not recipes:
        return Response({"message": "No recipes available."}, status=404)
    recipe = random.choice(recipes)
    serializer = AllRecipeSerializer(recipe)
    return Response(serializer.data)

# View to get the current user's profile data
@api_view(['GET'])
@permission_classes([IsAuthenticated])  # Only authenticated users can access
def user_profile(request):
    try:
        user = request.user
        user_data = {
            'username': user.username,
            # Include more fields like first_name and last_name when needed
        }
        return Response(user_data)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

# diet filter 
@api_view (['GET'])
def filter_recipes(request):
    dietary_preferences = request.GET.getlist('tags')
    recipes = AllRecipe.objects.all()

    if dietary_preferences:
        query = Q()

        for preference in dietary_preferences:
            query |= Q(tags__icontains=preference) | Q(search_terms__icontains=preference)  
        recipes = recipes.filter(query)

    if not recipes.exists():
        return Response({"message": "No recipes found matching your criteria."})

    recipe = random.choice(list(recipes))

    serializer = AllRecipeSerializer(recipe)
    return Response(serializer.data)


# User views
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Recipe views
class RecipeViewSet(viewsets.ModelViewSet):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

# AllRecipe views
class AllRecipeViewSet(viewsets.ModelViewSet):
    queryset = AllRecipe.objects.all()
    serializer_class = AllRecipeSerializer

# Diet views
class DietViewSet(viewsets.ModelViewSet):
    queryset = Diet.objects.all()
    serializer_class = DietSerializer

# Favorite views
class FavoriteViewSet(viewsets.ModelViewSet):
    queryset = Favorite.objects.all()
    serializer_class = FavoriteSerializer

# Partner views
class PartnerViewSet(viewsets.ModelViewSet):
    queryset = Partner.objects.all()
    serializer_class = PartnerSerializer
