from .models import Recipe, Favorite, CustomUser

def swipe_recipe(user, recipe_id, liked):
    try:
        recipe = Recipe.objects.get(id=recipe_id)
        #SeenRecipe.objects.get_or_create(user=user, recipe=recipe, liked=liked)

        if liked:
            Favorite.objects.get_or_create(user=user, recipe=recipe)
            return f"{recipe.title} added to favorites."
    except Recipe.DoesNotExist:
        return "recipe not found"

def get_favorites(user):
    favorites = Favorite.objects.filter(user=user)
    return [favorite.recipe for favorite in favorites]