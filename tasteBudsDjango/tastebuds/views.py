from django.shortcuts import render
from rest_framework import generics
from rest_framework.response import Response
from .models import UserProfile, Recipe, Ingredient
from .serializers import UserProfileSerializer, RecipeSerializer, IngredientSerializer
# Create your views here.
 #user views 

#GET (listing all) and POST (create new) user profiles
class UserProfileListCreateView(generics.ListCreateAPIView):
    queryset = UserProfile.objects.all() 
    serializer_class = UserProfileSerializer

# GET, PUT, and DELETE profiles by pk (id)
class UserProfileDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

 #recipe views 
class RecipeListCreateView(generics.ListCreateAPIView):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

class RecipeDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

#ingredient views
class IngredientListCreateView(generics.ListCreateAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer

class IngredientDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer