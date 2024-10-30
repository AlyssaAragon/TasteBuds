from rest_framework import serializers
from django.contrib.auth.models import User #uses django's user not the model's
from .models import AllRecipe, Diet, Favorite, Partner, Recipe 

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
        model = User
        fields = '__all__'  