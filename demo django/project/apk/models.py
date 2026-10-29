from django.db import models

class User(models.Model):
    title = models.CharField(max_length=100)
    slug = models.SlugField()
    body = models.TextField()
    date = models.DateTimeField(auto_now_add=True)

def __str__(self):
    return self.title
def __snippet__(self):
    return self.body[:50] +'...'