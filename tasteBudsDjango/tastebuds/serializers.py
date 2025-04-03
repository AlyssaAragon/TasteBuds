from rest_framework import serializers
from .models import CustomUser, Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet, Category, RecipeCategory, PrivateRecipe

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

class PartnerLinkSerializer(serializers.Serializer):
    partner_email = serializers.EmailField()

class DietSerializer(serializers.ModelSerializer):
    class Meta:
        model = Diet
        fields = '__all__'

class RecipeDietSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecipeDiet
        fields = (
            'recipedietid',
            'recipe',        # You could also nest RecipeSerializer if needed
            'vegetarian',
            'vegan',
            'gluten_free',
            'dairy_free',
            'nut_free',
            'low_carb',
            'keto',
            'paleo',
        )

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = (
            'category_id',
            'category_name',
        )


class RecipeCategorySerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)
    recipe = RecipeSerializer(read_only=True)
    class Meta:
        model = RecipeCategory
        fields = ('recipe', 'category')





class SavedRecipeSerializer(serializers.ModelSerializer):
    recipe = RecipeSerializer(read_only=True)
    recipe_id = serializers.PrimaryKeyRelatedField(
        queryset=Recipe.objects.all(), source='recipe', write_only=True
    )

    class Meta:
        model = SavedRecipe
        fields = ['savedid', 'user', 'recipe', 'recipe_id']
        extra_kwargs = {
            'user': {'read_only': True},
        }





class PrivateRecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = PrivateRecipe
        fields = '__all__'

class UserDietSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDiet
        fields = '__all__'
