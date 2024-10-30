from rest_framework import serializers
from .models import AllRecipes, Diets, Favorites, Partners, Recipes, Users 

class AllRecipesSerializer(serializers.ModelSerializer):
    class Meta:
        model = AllRecipes
        fields = '__all__' 

class DietsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Diets
        fields = '__all__'  

class FavoritesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favorites
        fields = '__all__' 

class PartnersSerializer(serializers.ModelSerializer):
    class Meta:
        model = Partners
        fields = '__all__'  # or specify a list of fields

class RecipesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recipes
        fields = '__all__'  

class UsersSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = '__all__'  