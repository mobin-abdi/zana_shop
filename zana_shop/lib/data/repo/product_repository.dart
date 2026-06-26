import 'package:zana_shop/data/model/category.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/source/product_data_source.dart';

abstract class IProductRepository {
  Future<List<Product>> getFeaturedProducts();

  Future<List<Product>> getRecommendedProducts();

  Future<List<Product>> getPopularProducts();

  Future<List<Product>> getAllProducts();

  Future<List<Category>> getCategories();

  Future<List<Product>> getAllByCategory(int categoryId);

  Future<List<Product>> searchProducts(String query);

  Future<Product> getProductById(int productId);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository({required this.dataSource});

  @override
  Future<List<Product>> getFeaturedProducts() =>
      dataSource.getFeaturedProducts();

  @override
  Future<List<Product>> getRecommendedProducts() =>
      dataSource.getRecommendedProducts();

  @override
  Future<List<Product>> getPopularProducts() => dataSource.getPopularProducts();

  @override
  Future<List<Product>> getAllProducts() => dataSource.getAllProducts();

  @override
  Future<List<Category>> getCategories() => dataSource.getCategories();

  @override
  Future<List<Product>> getAllByCategory(int categoryId) =>
      dataSource.getAllByCategory(categoryId);

  @override
  Future<List<Product>> searchProducts(String query) => dataSource.searchProducts(query);

  @override
  Future<Product> getProductById(int productId) => dataSource.getProductById(productId);
}
