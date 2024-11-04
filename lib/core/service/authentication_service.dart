import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationService {
  final Dio dio;
  String? _accessToken;
  String? _refreshToken;

  AuthenticationService(this.dio);

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post('/login', data: {
        'username': username,
      	'password': password
      });

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        _refreshToken = response.data['refresh_token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login failure: $e");
      return false;
    }
  }

  String? get accessToken => _accessToken;

  Future<bool> refreshAccessToken() async {
    try {
      final response = await dio.post('/refresh', data: {
        'refresh_token': _refreshToken,
      });

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print('Refresh token failure: $e');
      return false;
    }
  }
}