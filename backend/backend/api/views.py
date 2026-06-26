from rest_framework import viewsets, filters, status
from django_filters.rest_framework import DjangoFilterBackend
from .models import CartItem, Product, Banner, Category, Cart
from .serializers import CartSerializer, ProductSerializer, BannerSerializer, CategorySerializer
from rest_framework.decorators import action, api_view
from rest_framework.response import Response
from django.db.models import Count
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    
    search_fields = ['title']

    filterset_fields = ['category', 'title']

    @action(detail=False, methods=['get'])
    def recommended(self, request):
        products = Product.objects.filter(discount_percent__gt=0)
        return Response(self.get_serializer(products, many=True).data)

    @action(detail=False, methods=['get'])
    def featured(self, request):
        products = Product.objects.all().order_by('-created_at')
        return Response(self.get_serializer(products, many=True).data)

    @action(detail=False, methods=['get'])
    def popular(self, request):
        products = Product.objects.annotate(count=Count('views')).order_by('-count')
        return Response(self.get_serializer(products, many=True).data)
    
    @action(detail=True, methods=['post'])
    def view(self, request, pk=None):
        product = self.get_object()
        ProductView.objects.create(product=product)
        return Response({'status': 'viewed'})
    
    @action(detail=False, methods=['get'])
    def category(self, request):
        category_id = request.query_params.get('id')
        products = Product.objects.filter(category_id=category_id)
        return Response(self.get_serializer(products, many=True).data)
    
    @action(detail=False, methods=['get'])
    def get_all_categories(self, request):
        categories = Category.objects.all()
        return Response(CategorySerializer(categories, many=True).data)

@api_view(["GET"])
def banner_api(request):
    banners = Banner.objects.filter(is_active=True)
    serializer = BannerSerializer(banners, many=True)
    return Response(serializer.data)

class RegisterView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if User.objects.filter(username=username).exists():
            return Response({'error': 'this username already exist!'}, status=status.HTTP_400_BAD_REQUEST)
        
        user = User.objects.create_user(username=username, password=password)        
        token, _ = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})
    
class LoginView(APIView):
    def post(self, request):
        user = authenticate(username=request.data.get('username'), password=request.data.get('password'))
        if user:
            token, _ = Token.objects.get_or_create(user=user)
            return Response({"token": token.key})
        return Response({"message": "اطلاعات اشتباه است"}, status=status.HTTP_401_UNAUTHORIZED)
    
class LogoutView(APIView):
    def post(self, request):
        request.user.auth_token.delete()
        return Response({'message': 'you are loged out'}, status=status.HTTP_200_OK)
    
class CartView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        serializer = CartSerializer(cart) 
        return Response(serializer.data)
        
    def post(self, request):
        product_id = request.data.get('product_id')
        cart, _ = Cart.objects.get_or_create(user=request.user)
        product = Product.objects.get(id=product_id)

        item, created = CartItem.objects.get_or_create(cart=cart, product=product)
        if not created:
            item.quantity += 1
            item.save()

        serializer = CartSerializer(cart)
        return Response(serializer.data)

@api_view(['POST'])
def change_quantity(request):
    product_id = request.data.get('product_id')
    action = request.data.get('action')
    cart = Cart.objects.get(user=request.user)
    
    item = CartItem.objects.get(cart=cart, product_id=product_id)
    
    if action == "increase":
        item.quantity += 1
        item.save()
    elif action == "decrease":
        if item.quantity > 1:
            item.quantity -= 1
            item.save()
        else:
            item.delete()
    
    serializer = CartSerializer(cart)
    return Response(serializer.data)