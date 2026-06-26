import 'package:dio/dio.dart';
import 'package:zana_shop/data/model/banner.dart';

abstract class IBannerDataSource {
  Future<List<Banner>> getAll();
}

class BannerRemoteDataSource implements IBannerDataSource {
  final Dio dio;

  BannerRemoteDataSource({required this.dio});

  @override
  Future<List<Banner>> getAll() async {
    try {
      final response = await dio.get("banners/");

      if (response.statusCode == 200) {
        List data;
        if (response.data is Map && (response.data as Map).containsKey('data')) {
          data = (response.data as Map)['data'] as List;
        } else {
          data = response.data as List;
        }
        return data.map((json) => Banner.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load banners ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load banners ${e.toString()}");
    }
  }
}