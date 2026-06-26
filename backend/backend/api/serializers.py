from rest_framework import serializers
from .models import Cart, CartItem, Product, Banner, Category

class ProductSerializer(serializers.ModelSerializer):
    final_price = serializers.ReadOnlyField()
    category_name = serializers.CharField(source="category.name", read_only=True)
    category_id = serializers.PrimaryKeyRelatedField(source="category", read_only=True)

    class Meta:
        model = Product
        fields = ["id", "title", "price", "discount_percent", "category_name", "category_id", "final_price", "image", "description"]

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'slug']

class BannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Banner
        fields = '__all__'

class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'quantity']

class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)

    class Meta:
        model = Cart
        fields = ['id', 'user', 'items']