from django.shortcuts import render

def customerpage(request):
    return render(request,'cust.html')
def manufacturerpage(request):
    return render(request,'manufac.html')
