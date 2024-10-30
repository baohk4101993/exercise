// service/dio_service.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ""));

  DioService() {
    _dio.interceptors.add(_AuthInterceptor(this));
  }

  Dio get dio => _dio;

  Future<Response> login(String username, String password) async {
    return await _dio.post("/login", data: {
      "username": username,
      "password": password,
    });
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer$token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}


// Interceptor to handle token and error responses
class _AuthInterceptor extends Interceptor {
  final DioService dioService;

  _AuthInterceptor(this.dioService);

@override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Automatically adds the token to headers if available
  	if (dioService._token != null) {
      options.headers['Authorization'] = 'Bearer ${dioService._token}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Automatically refresh token on 401 error
    if (err.response?.statusCode == 401) {
      try {
        bool refreshed = await dioService.refresheToken();
        if (refreshed) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${dioService._token}';
          final newResponse = await dioService.dio.fetch(options);
          return handler.resolve(newResponse);
        }
      } catch (e) {

      }
    }
    super.onError(err, handler);
  }

}