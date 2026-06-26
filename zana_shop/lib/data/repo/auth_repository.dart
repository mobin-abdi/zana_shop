import 'package:zana_shop/data/source/auth_data_source.dart';

abstract class IAuthRepository {
  Future<String> login(String username, String password);
  Future<String> register(String username, String password);
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  @override
  Future<String> login(String username, String password) => dataSource.login(username, password);

  @override
  Future<String> register(String username, String password) => dataSource.register(username, password);
}