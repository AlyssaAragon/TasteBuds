from rest_framework import serializers
from .models import CustomUser, Recipe, Diet, RecipeDiet, SavedRecipe, UserDiet, Category, RecipeCategory, PrivateRecipe
import re
from django.db import IntegrityError
from rest_framework.exceptions import ValidationError
from rest_framework import serializers
from .models import UserDiet, Diet


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
            'recipe',        
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
    user = serializers.PrimaryKeyRelatedField(read_only=True)  # <- add this line

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


class RegisterUserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'firstlastname', 'password', 'password2']

    def validate_password(self, value):
        errors = []

        if len(value) < 8:
            errors.append("must be at least 8 characters long.")
        if len(value) > 128:
            errors.append("must not exceed 128 characters.")
        if not re.search(r"[A-Z]", value):
            errors.append("must include at least one uppercase letter.")
        if not re.search(r"\d", value):
            errors.append("must include at least one number.")
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", value):
            errors.append("must include at least one special character.")

        if errors:
            raise serializers.ValidationError("Password " + ", ".join(errors))

        return value

    def validate(self, data):
        if data.get("password") != data.get("password2"):
            raise serializers.ValidationError({"password2": "Passwords do not match."})
        return data

    def create(self, validated_data):
        validated_data.pop('password2')
        try:
            return CustomUser.objects.create_user(
                username=validated_data['username'],
                email=validated_data['email'],
                firstlastname=validated_data.get('firstlastname', ''),
                password=validated_data['password']
            )
        except IntegrityError as e:
            if "users_username_key" in str(e):
                raise ValidationError({"username": "Username is already taken."})
            elif "users_email_key" in str(e):
                raise ValidationError({"email": "Email is already registered with an account."})
            raise ValidationError("Signup failed due to a server error.")


class UserDietUpdateSerializer(serializers.Serializer):
    diets = serializers.ListField(
        child=serializers.CharField(), allow_empty=True
    )





class UserDietUpdateSerializer(serializers.Serializer):
    diets = serializers.ListField(
        child=serializers.CharField(),
        allow_empty=True
    )








