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
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('allauth.urls')), #Django user thing Allauth
    path('profiles/', UserProfileListCreateView.as_view(), name='user-profile-list'), #for listing and creating user profiles
    path('profiles/<int:pk>/', UserProfileDetailView.as_view(), name='user-profile-detail'), #for retrieving, updating, and deleting a specific user profile
    path('recipes/', RecipeListCreateView.as_view(), name='recipe-list'), #for listing and creating recipes
    path('recipes/<int:pk>/', RecipeDetailView.as_view(), name='recipe-detail'), #for retrieving, updating, and deleting a specific recipe
    ]

