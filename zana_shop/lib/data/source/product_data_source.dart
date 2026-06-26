import 'package:dio/dio.dart';
import 'package:zana_shop/data/model/category.dart';
import 'package:zana_shop/data/model/product.dart';

abstract class IProductDataSource {
  Future<List<Product>> getFeaturedProducts();

  Future<List<Product>> getRecommendedProducts();

  Future<List<Product>> getPopularProducts();

  Future<List<Product>> getAllProducts();

  Future<List<Category>> getCategories();

  Future<List<Product>> getAllByCategory(int categoryId);

  Future<List<Product>> searchProducts(String query);

  Future<Product> getProductById(int productId);
}

class ProductRemoteDataSource implements IProductDataSource {
  final Dio dio;

  ProductRemoteDataSource({required this.dio});

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await dio.get("products/featured/");

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<List<Product>> getRecommendedProducts() async {
    try {
      final response = await dio.get("products/recommended/");

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await dio.get("products/");

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<List<Product>> getPopularProducts() async {
    try {
      final response = await dio.get("products/popular/");

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await dio.get("products/get_all_categories/");
    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
    }
    throw Exception("Error");
  }

  @override
  Future<List<Product>> getAllByCategory(int categoryId) async {
    final response = await dio.get("products/?category=$categoryId");
    final List data = response.data as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await dio.get(
        "products/",
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> getProductById(int productId) async {
    try {
      final response = await dio.get("products/$productId/");

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception("server error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("failed to load to product ${e.toString()}");
    }
  }
}
