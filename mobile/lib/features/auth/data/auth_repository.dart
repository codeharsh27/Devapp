import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/dio_provider.dart';
import '../../drops/domain/user_model.dart';

// Token Response Model
class AuthToken {
  final String accessToken;
  final String tokenType;

  AuthToken({required this.accessToken, required this.tokenType});

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

class AuthRepository {
  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this._dio);

  Future<AuthToken> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/token',
        data: {
          'username': email,
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final token = AuthToken.fromJson(response.data);

      // Save Token
      await _storage.write(key: 'access_token', value: token.accessToken);

      return token;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      });
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  Exception _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 401) {
        return Exception("Invalid Credentials");
      }
      if (e.response?.statusCode == 400) {
        return Exception(e.response?.data['detail'] ?? "Bad Request");
      }
    }
    return Exception("Authentication Failed: $e");
  }
}
