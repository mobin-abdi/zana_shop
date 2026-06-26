from django.db import models
from django.contrib.auth.models import User

class Category(models.Model):
    name = models.CharField(max_length=64)
    slug = models.SlugField()

    def __str__(self):
        return f"category {self.name}"
    
class Product(models.Model):
    title = models.CharField(max_length=128, db_index=True)
    price = models.PositiveIntegerField()
    discount_percent = models.PositiveIntegerField(default=0)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, db_index=True)
    description = models.TextField()
    image = models.ImageField(upload_to="product_images/")
    created_at = models.DateTimeField(auto_now_add=True)
    
    @property
    def final_price(self):
        if self.discount_percent > 0:
            return self.price - (self.price * self.discount_percent // 100)
        return self.price

    def __str__(self):
        return self.title

class ProductView(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='views')
    viewed_at = models.DateTimeField(auto_now_add=True)

class Banner(models.Model):
    image = models.ImageField(upload_to="banners/")
    text = models.CharField(max_length=32)
    url = models.URLField()
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.text

class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveBigIntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.quantity} x {self.product.title}"
