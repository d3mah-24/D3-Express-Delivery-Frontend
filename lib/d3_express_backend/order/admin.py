from django.contrib import admin

from order.models import OrderItems, Orders


@admin.register(Orders)
class order(admin.ModelAdmin):
    list_display = [
        "id",
        "customer",
        "delivery_person",
        "fee",
        "destLat",
        "destLong",
        "is_paid",
        "status",
    ]


@admin.register(OrderItems)
class orderitem(admin.ModelAdmin):
    list_display = ["id", "item", "quantity", "order"]
