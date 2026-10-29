from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

from . import views


urlpatterns = [
    path("admin/", admin.site.urls),

    path("", views.homepage, name="home"),
    path("about/", views.aboutpage, name="about"),

    path("codex/", include("codex.urls")),
    path("accounts/", include("accounts.urls")),

    path("movies/", views.search_movie, name="movies"),
]


if settings.DEBUG:
    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT
    )