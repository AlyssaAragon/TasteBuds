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

from tastebuds.views import (
    UserProfileListCreateView,
    UserProfileDetailView,
    RecipeListCreateView,
    RecipeDetailView,
    AllRecipeListCreateView,
    AllRecipeDetailView,
    DietListCreateView,
    DietDetailView,
    FavoriteListCreateView,
    FavoriteDetailView,
    PartnerListCreateView,
    PartnerDetailView,
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('allauth.urls')), #Django user thing Allauth
    path('profiles/', UserProfileListCreateView.as_view(), name='user-profile-list'),
    path('profiles/<int:pk>/', UserProfileDetailView.as_view(), name='user-profile-detail'),
    path('recipes/', RecipeListCreateView.as_view(), name='recipe-list'),
    path('recipes/<int:pk>/', RecipeDetailView.as_view(), name='recipe-detail'),
    path('allrecipes/', AllRecipeListCreateView.as_view(), name='allrecipe-list'),
    path('allrecipes/<int:pk>/', AllRecipeDetailView.as_view(), name='allrecipe-detail'),
    path('diets/', DietListCreateView.as_view(), name='diet-list'),
    path('diets/<int:pk>/', DietDetailView.as_view(), name='diet-detail'),
    path('favorites/', FavoriteListCreateView.as_view(), name='favorite-list'),
    path('favorites/<int:pk>/', FavoriteDetailView.as_view(), name='favorite-detail'),
    path('partners/', PartnerListCreateView.as_view(), name='partner-list'),
    path('partners/<int:pk>/', PartnerDetailView.as_view(), name='partner-detail'),
]
