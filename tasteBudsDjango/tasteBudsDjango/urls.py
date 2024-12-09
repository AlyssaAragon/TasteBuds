"""
URL configuration for tasteBudsDjango project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from tastebuds import views
from tastebuds.views import random_recipe


router = DefaultRouter()
router.register(r'profiles', views.UserProfileViewSet)
router.register(r'recipes', views.RecipeViewSet)
router.register(r'allrecipes', views.AllRecipeViewSet)
router.register(r'diets', views.DietViewSet)
router.register(r'favorites', views.FavoriteViewSet)
router.register(r'partners', views.PartnerViewSet)


urlpatterns = [
    path('admin/', admin.site.urls),  
    path('tastebuds/', include('tastebuds.urls')),  
    path('accounts/', include('allauth.urls')),  
    path('api/', include(router.urls)),  
    path('api/random_recipe/', random_recipe, name='random_recipe'),

]