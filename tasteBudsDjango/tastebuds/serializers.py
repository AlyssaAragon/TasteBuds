from rest_framework import serializers
from django.contrib.auth.models import User
from .models import AllRecipe, Diet, Favorite, Partner, Recipe 
from django.contrib.auth import get_user_model


class AllRecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = AllRecipe
        fields = '__all__' 

class DietSerializer(serializers.ModelSerializer):
    class Meta:
        model = Diet
        fields = '__all__'  

class FavoriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favorite
        fields = '__all__' 

class PartnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Partner
        fields = '__all__'  # or specify a list of fields

class RecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recipe
        fields = '__all__'  

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()  #uses our custom user model
        fields = '__all__'
