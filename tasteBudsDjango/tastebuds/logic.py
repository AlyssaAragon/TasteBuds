from django.core.cache import cache
from .models import Recipe, Favorite, CustomUser

def swipe_recipe(user, recipe_id, liked):
    try:
        recipe = Recipe.objects.get(id=recipe_id)
        
        # Use caching to check if the user has already seen the recipe
        cache_key = f"user_{user.id}_seen_recipe_{recipe_id}"
        if cache.get(cache_key):
            return "You have already seen this recipe."

        # Cache the fact that the user has seen the recipe 
        cache.set(cache_key, 'seen', timeout=86400) #times out after 1 day

        if liked:
            Favorite.objects.get_or_create(user=user, recipe=recipe)
            return f"{recipe.title} added to favorites."
        
        return f"Recipe {recipe.title} swiped."

    except Recipe.DoesNotExist:
        return "Recipe not found."

def get_favorites(user):
    favorites = Favorite.objects.filter(user=user)
    return [favorite.recipe for favorite in favorites]
