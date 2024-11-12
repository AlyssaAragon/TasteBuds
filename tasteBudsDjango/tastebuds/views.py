from django.shortcuts import render
from rest_framework import generics
from django.contrib.auth.models import User #we will use this for user instead of using it from the database since django handles users
from django.contrib.auth import get_user_model
from .models import AllRecipe, Diet, Favorite, Partner, Recipe  # Include all models
from .serializers import UserSerializer, RecipeSerializer, AllRecipeSerializer, DietSerializer, FavoriteSerializer, PartnerSerializer

# Create your views here.
 #user views 

User = get_user_model()

class UserProfileListCreateView(generics.ListCreateAPIView):
    queryset = User.objects.all() 
    serializer_class = UserSerializer

class UserProfileDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Recipe views 
class RecipeListCreateView(generics.ListCreateAPIView):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

class RecipeDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

# AllRecipe views
class AllRecipeListCreateView(generics.ListCreateAPIView):
    queryset = AllRecipe.objects.all()
    serializer_class = AllRecipeSerializer

class AllRecipeDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = AllRecipe.objects.all()
    serializer_class = AllRecipeSerializer

# Diet views
class DietListCreateView(generics.ListCreateAPIView):
    queryset = Diet.objects.all()
    serializer_class = DietSerializer

class DietDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Diet.objects.all()
    serializer_class = DietSerializer

# Favorite views
class FavoriteListCreateView(generics.ListCreateAPIView):
    queryset = Favorite.objects.all()
    serializer_class = FavoriteSerializer

class FavoriteDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Favorite.objects.all()
    serializer_class = FavoriteSerializer

# Partner views
class PartnerListCreateView(generics.ListCreateAPIView):
    queryset = Partner.objects.all()
    serializer_class = PartnerSerializer

class PartnerDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Partner.objects.all()
    serializer_class = PartnerSerializer

''' 
we cant use ingredient yet because our database doesnt have ingredients therefore neither does our models
#ingredient views
class IngredientListCreateView(generics.ListCreateAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer

class IngredientDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer
'''