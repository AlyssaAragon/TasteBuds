from django.db import models

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.conf import settings 
class Diet(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name

class Recipe(models.Model):
    title = models.CharField(max_length=255)
    body = models.TextField()
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    diets = models.ManyToManyField(Diet, through='RecipeDiet') 

    def __str__(self):
        return self.title

class RecipeDiet(models.Model):
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE)
    diet = models.ForeignKey(Diet, on_delete=models.CASCADE)

class AllRecipe(models.Model):
    name = models.TextField()
    description = models.TextField(null=True, blank=True)
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
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user', 'recipe')

class Partner(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='partners')
    partner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='partner_of')

    class Meta:
        unique_together = ('user', 'partner')

class CustomUserManager(BaseUserManager):
    def create_user(self, email, username, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, username, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, username, password, **extra_fields)


class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, unique=True)
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def __str__(self):
        return self.username