import 'package:dio/dio.dart';
import 'package:zana_shop/common/storage.dart';

final httpClient =
    Dio(
        BaseOptions(
          baseUrl: "http://10.0.2.2:8000/api/",
          headers: {'Accept': 'application/json'},
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (!options.path.contains('auth/login/') || !options.path.contains("auth/register/")) {
              final token = await TokenManager.instance.getToken();
              if (token != null) {
                options.headers['Authorization'] = 'Token $token';
              }
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) {
            return handler.next(e);
          },
        ),
      );
