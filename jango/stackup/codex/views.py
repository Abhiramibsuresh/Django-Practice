from rest_framework import viewsets
from .serializers import ArticleSerializer
from django.shortcuts import render,redirect
from.models import Article
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from .import forms


def list(request):
    articles = Article.objects.all().order_by('date')
    return render(request,'codex/code.html',{'articles':articles})

def layout_detail(request,slug):
    rami = Article.objects.get(slug=slug)
    return render(request,'codex/detail.html',{'rami':rami})

def article_create(request):
    return render(request,'codex/article_create.html')

@login_required(login_url = '/codex/login/')
def article_create(request):
    if request.method =='POST':
        form = forms.CreateArticle(request.POST,request.FILES)
        if form.is_valid():
            instance = form.save(commit=False)
            instance.author = request.user
            instance.save()
            return redirect('codex:list')
    form = forms.CreateArticle()
    return render(request,'codex/article_create.html',{'form':form})


class ArticleViewSet(viewsets.ModelViewSet):
    queryset = Article.objects.all() 
    serializer_class = ArticleSerializer
    