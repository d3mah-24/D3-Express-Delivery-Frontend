from django.db import models
from django.contrib.auth import get_user_model
from shortuuid.django_fields import ShortUUIDField

from products.models import Product

User = get_user_model()
choices = [
    ("Pending", "Pending"),
    ("Completed", "Completed"),
    ("In Progress", "In Progress"),
    ("Paid", "Paid"),
]


class Orders(models.Model):
    id = ShortUUIDField(length=16, primary_key=True)
    customer = models.ForeignKey(User, on_delete=models.CASCADE)
    delivery_person = models.CharField(max_length=30, null=True, blank=True)
    fee = models.DecimalField(max_digits=10, decimal_places=2)
    refNo = models.CharField(max_length=30, default="")
    destLat = models.CharField(max_length=30)
    destLong = models.CharField(max_length=30)
    is_paid = models.BooleanField(default=False)
    status = models.CharField(max_length=30, choices=choices, default="Pending")
    date = models.DateField(auto_now_add=True)
    total_price = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    class Meta:
        verbose_name = "Order"
        verbose_name_plural = "Orders"

    def __str__(self):
        return self.customer.first_name


class OrderItems(models.Model):
    id = ShortUUIDField(length=16, primary_key=True)
    item = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField(default=1)
    order = models.ForeignKey(Orders, on_delete=models.CASCADE)

    class Meta:
        verbose_name = "OrderItem"
        verbose_name_plural = "OrderItems"

    def __str__(self):
        return self.id
