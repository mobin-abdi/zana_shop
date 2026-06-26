class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class LoginResponse {
  final String token;

  LoginResponse.fromJson(Map<String, dynamic> json) : token = json['token'];
}

class RegisterRequest {
  final String username;
  final String password;

  RegisterRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class RegisterResponse {
  final String token;

  RegisterResponse.fromJson(Map<String, dynamic> json) : token = json['token'];
}
