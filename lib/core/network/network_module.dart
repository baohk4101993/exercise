import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:login_logout/core/service/authentication_interceptor.dart';

@module
abstract class NetworkModule {

  @lazySingleton
  Dio dio(AuthenticationInterceptor authenticationInterceptor) {
    final dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api'));
    dio.interceptors.add(authenticationInterceptor);
    return dio;
  }
}