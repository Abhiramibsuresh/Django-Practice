import requests

from django.http import JsonResponse
from django.shortcuts import render
from django.conf import settings


def homepage(request):
    return render(request, "home.html")


def aboutpage(request):
    return render(request, "about.html")


def search_movie(request):

    search_query = request.GET.get("q", "").strip()

    base_url = "https://api.themoviedb.org/3"

    def tmdb_request(endpoint, params=None):

        if params is None:
            params = {}

        params["api_key"] = settings.TMDB_API_KEY

        try:
            response = requests.get(
                f"{base_url}{endpoint}",
                params=params,
                timeout=20
            )

            print("TMDB:", endpoint, response.status_code)

            response.raise_for_status()

            return response.json().get("results", [])

        except requests.exceptions.RequestException as e:

            print("TMDB ERROR:", endpoint, e)

            return []

    # Search
    movies = []

    if search_query:
        movies = tmdb_request(
            "/search/movie",
            {
                "query": search_query,
                "include_adult": False
            }
        )

    # Trending
    trending = tmdb_request(
        "/trending/movie/week"
    )

    # Now Playing
    now_playing = tmdb_request(
        "/movie/now_playing",
        {
            "language": "en-US",
            "page": 1
        }
    )

    # Top Rated
    top_rated = tmdb_request(
        "/movie/top_rated",
        {
            "language": "en-US",
            "page": 1
        }
    )

    # Upcoming
    upcoming = tmdb_request(
        "/movie/upcoming",
        {
            "language": "en-US",
            "page": 1
        }
    )

    context = {
        "movies": movies,
        "search_query": search_query,
        "trending": trending,
        "now_playing": now_playing,
        "top_rated": top_rated,
        "upcoming": upcoming,
    }

    return render(request, "movies.html", context)