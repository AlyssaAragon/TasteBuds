from django.contrib import admin
from .models import Diet, Recipe, RecipeDiet, SavedRecipe, CustomUser, UserDiet

admin.site.register(CustomUser)
admin.site.register(Diet)
admin.site.register(Recipe)
admin.site.register(RecipeDiet)
admin.site.register(SavedRecipe)
admin.site.register(UserDiet)
