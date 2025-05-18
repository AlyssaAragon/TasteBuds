from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from tastebuds import views
from tastebuds.views import (
    home,
    random_recipe,
    user_profile,
    filter_recipes_by_diet,
    LinkPartnerAPIView,
    get_random_recipe_by_category,
    filter_recipes_combined,
    ExemptLoginView,
    ExemptSignupView,
    api_signup,
    PrivateRecipeListCreateView,
    PrivateRecipeDetailView,
    get_partner_requests,
    respond_to_partner_request,
    remove_partner,
    update_user_diets,
    RateLimitedTokenObtainPairView,
    change_password
)
from django.views.decorators.csrf import csrf_exempt
from rest_framework_simplejwt.views import TokenRefreshView
from django.conf import settings
from django.conf.urls.static import static

router = DefaultRouter()
router.register(r'profiles', views.UserProfileViewSet)
router.register(r'recipes', views.RecipeViewSet)
router.register(r'diets', views.DietViewSet)
router.register(r'savedrecipe', views.SavedRecipeViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('tastebuds/', include('tastebuds.urls')),
    path('accounts/', include('allauth.urls')),
    path('accounts/signup/', ExemptSignupView.as_view(), name='account_signup'),
    path('accounts/login/', ExemptLoginView.as_view(), name='account_login'),
    path('api/', include(router.urls)),
    path('api/random_recipe/', random_recipe, name='random_recipe'),
    path('api/user_profile/', user_profile, name='user_profile'),
    path('api/filter_recipes_by_diet/', filter_recipes_by_diet, name='filter_recipes_by_diet'),
    path('api/get_random_recipe_by_category/', get_random_recipe_by_category, name='get_random_recipe_by_category'),
    path('api/link-partner/', LinkPartnerAPIView.as_view(), name='api-link-partner'),
    path('api/filter_recipes_combined/', filter_recipes_combined, name='filter_recipes_combined'),
    path('', home, name='home'),
    path('api/token/', RateLimitedTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/signup/', api_signup, name='api_signup'),
    path('private-recipes/', PrivateRecipeListCreateView.as_view(), name='private-recipe-list-create'),
    path('private-recipes/<int:pk>/', PrivateRecipeDetailView.as_view(), name='private-recipe-detail'),
    path('api/partner-requests/', get_partner_requests, name='get_partner_requests'),
    path('api/respond-partner-request/', respond_to_partner_request, name='respond_partner_request'),
    path('api/remove-partner/', remove_partner, name='remove_partner'),
    path('api/user_diets/', update_user_diets, name='update_user_diets'),
    path('api/change-password/', change_password, name='change-password'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)




