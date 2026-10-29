from django.urls import path,include
from. import views
from rest_framework.routers import DefaultRouter
from .views import ArticleViewSet


app_name = "codex"

router = DefaultRouter()
router.register(r'articles',ArticleViewSet)

urlpatterns = [
    path('',views.list,name="list"),
    path('api/',include(router.urls)),
    path('create/',views.article_create,name ='create'),
    path('<slug:slug>/',views.layout_detail,name="detail"),
]
