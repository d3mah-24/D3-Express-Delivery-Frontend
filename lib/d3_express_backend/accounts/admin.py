from django.contrib import admin

from .models import *


# Register your models here.

@admin.register(CustomUser)
class User(admin.ModelAdmin):
    list_display = ["id", "first_name", "email", "is_staff"]
