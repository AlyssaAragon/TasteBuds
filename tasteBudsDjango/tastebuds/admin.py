from django.contrib import admin
from .models import Diet, Recipe, AllRecipe, Favorite, Partner

# Register your models here.
admin.site.register(Diet)
admin.site.register(Recipe)
admin.site.register(AllRecipe)
admin.site.register(Favorite)
admin.site.register(Partner)