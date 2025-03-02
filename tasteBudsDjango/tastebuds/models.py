from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.conf import settings
from .managers import CustomUserManager
from django.utils import timezone 

class Diet(models.Model):
    dietid = models.AutoField(primary_key=True, db_column='dietid')
    dietname = models.CharField(max_length=255, unique=True, default="General", db_column='dietname')

    def __str__(self):
        return self.dietname

    class Meta:
        db_table = 'diet'
        managed = False  # Set to False if you don't want Django managing this table


class Recipe(models.Model):
    recipeid = models.AutoField(primary_key=True, db_column='recipeid')
    title = models.CharField(max_length=255, default="Untitled Recipe", db_column='title')
    ingredients = models.TextField(default="No ingredients listed", db_column='ingredients')
    instructions = models.TextField(default="No instructions provided", db_column='instructions')
    image_name = models.CharField(max_length=255, null=True, blank=True, db_column='image_name')
    cleaned_ingredients = models.TextField(default="", db_column='cleaned_ingredients')

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'recipe'
        managed = False


class RecipeDiet(models.Model):
    recipedietid = models.AutoField(primary_key=True, db_column='recipedietid')
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE, db_column='recipeid')
    
    vegetarian = models.BooleanField(default=False, db_column='vegetarian')
    vegan = models.BooleanField(default=False, db_column='vegan')
    gluten_free = models.BooleanField(default=False, db_column='gluten_free')
    dairy_free = models.BooleanField(default=False, db_column='dairy_free')
    nut_free = models.BooleanField(default=False, db_column='nut_free')
    low_carb = models.BooleanField(default=False, db_column='low_carb')
    keto = models.BooleanField(default=False, db_column='keto')
    paleo = models.BooleanField(default=False, db_column='paleo')

    class Meta:
        db_table = 'recipe_diet'
        managed = False
        
class Category(models.Model):
    category_id = models.AutoField(primary_key=True, db_column='category_id')
    category_name = models.CharField(max_length=50, unique=True, db_column='category_name')
    def __str__(self):
        return self.category_name
    class Meta:
        db_table = 'categories'
        managed = False
class RecipeCategory(models.Model):
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE, db_column='recipeid', related_name="categories")
    category = models.ForeignKey(Category, on_delete=models.CASCADE, db_column='category_id', related_name="recipes")

    class Meta:
        db_table = 'recipe_categories'
        managed = False



class SavedRecipe(models.Model):
    savedid = models.AutoField(primary_key=True, db_column='savedid')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, db_column='userid')
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE, db_column='recipeid')

    class Meta:
        db_table = 'saved_recipe'
        managed = False


class CustomUser(AbstractBaseUser, PermissionsMixin):
    userid = models.AutoField(primary_key=True, db_column='userid')
    # Remove the integer partnerid field and add a self-referential field:
    partner = models.OneToOneField(
        'self',
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name='partner_of',  # Optional: allows reverse access
        db_column='partnerid'
    )
    username = models.CharField(max_length=150, unique=True, default="defaultuser", db_column='username')
    email = models.EmailField(unique=True, default="user@example.com", db_column='email')
    firstlastname = models.CharField(max_length=255, default="First Last", db_column='firstlastname')
   

    # Permission-related fields
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        # Removing the custom table name now that everything is standardized:
        # db_table = 'users'
        managed = True

    def __str__(self):
        return self.username

 

class UserDiet(models.Model):
    userdietid = models.AutoField(primary_key=True, db_column='userdietid')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, db_column='userid')
    diet = models.ForeignKey(Diet, on_delete=models.CASCADE, db_column='dietid')

    class Meta:
        db_table = 'user_diet'
        managed = False
        
        

