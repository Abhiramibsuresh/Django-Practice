from django.shortcuts import render
from.models import User
from django.http import HttpResponse


def demo(request):
    return render(request)
