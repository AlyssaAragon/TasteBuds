from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Diet(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name

class Recipe(models.Model):
    title = models.CharField(max_length=255)
    body = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    diets = models.ManyToManyField(Diet, through='RecipeDiet') 

    def __str__(self):
        return self.title

class RecipeDiet(models.Model):
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE)
    diet = models.ForeignKey(Diet, on_delete=models.CASCADE)

class AllRecipe(models.Model):
    name = models.TextField()
    ingredients = models.TextField()
    ingredients_raw_str = models.TextField()
    serving_size = models.TextField()
    servings = models.IntegerField()
    steps = models.TextField()
    tags = models.TextField()
    search_terms = models.TextField()

    def __str__(self):
        return self.name

class Favorite(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user', 'recipe')

class Partner(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='partners')
    partner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='partner_of')

    class Meta:
        unique_together = ('user', 'partner')

class Users(models.Model):
    username = models.CharField(max_length=150, unique=True) 
    password = models.CharField(max_length=128)  # Password storage (hope to eventually use hashed passwords)
    created_at = models.DateTimeField(auto_now_add=True)  
    diet_id = models.ForeignKey('Diet', on_delete=models.CASCADE)  

    def __str__(self):
        return self.username