import 'package:dio/dio.dart';
import 'package:zana_shop/data/model/auth.dart';

abstract class IAuthDataSource {
  Future<String> login(String username, String password);

  Future<String> register(String username, String password);
}

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        "auth/login/",
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        return loginResponse.token;
      } else {
        throw Exception("server error");
      }
    } catch (e) {
      throw Exception("login failed :$e");
    }
  }

  @override
  Future<String> register(String username, String password) async {
    try {
      final response = await dio.post(
        "auth/register/",
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['token'];
      } else {
        throw Exception("server error");
      }
    } catch (e) {
      throw Exception("signup failed : $e");
    }
  }
}
