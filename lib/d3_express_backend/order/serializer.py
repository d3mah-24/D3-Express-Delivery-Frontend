from order.models import OrderItems, Orders
from rest_framework import serializers

from products.serializers import ProductSerializer
from products.models import Product


class OrderSerializer(serializers.ModelSerializer):
    products = serializers.SerializerMethodField()

    def get_products(self, obj):
        r = OrderItems.objects.filter(order=obj.id)
        return OrderItemsGetSerializer(r, many=True).data

    class Meta:
        model = Orders
        fields = "__all__"


class OrderItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItems
        fields = "__all__"


class ProductSerializerOrder(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = [
            "id",
            "name",
            "price",
            "initialLat",
            "initialLong",
        ]


class OrderItemsGetSerializer(serializers.ModelSerializer):
    item = ProductSerializerOrder()

    class Meta:
        model = OrderItems
        exclude = ("order",)
