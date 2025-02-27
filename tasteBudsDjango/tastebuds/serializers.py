from rest_framework import serializers
from .models import CustomUser, Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet
from django.conf import settings 
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['userid', 'partnerid', 'username', 'email', 'firstlastname']

class RecipeSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(source='recipeid', read_only=True)
    name = serializers.CharField(source='title', read_only=True)
    
    class Meta:
        model = Recipe
        fields = ['id', 'name', 'ingredients', 'instructions', 'image_name', 'cleaned_ingredients']


class DietSerializer(serializers.ModelSerializer):
    class Meta:
        model = Diet
        fields = '__all__'

class RecipeDietSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecipeDiet
        fields = '__all__'

class SavedRecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SavedRecipe
        fields = '__all__'

class UserDietSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDiet
        fields = '__all__'
