import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:login_logout/core/service/authentication_service.dart';

@lazySingleton
class AuthenticationInterceptor extends Interceptor {
  final AuthenticationService authenticationService;

  AuthenticationInterceptor(this.authenticationService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (authenticationService.accessToken != null) {
      options.headers['Authorization'] = 'Beare ${authenticationService.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final success = await authenticationService.refreshAccessToken();
      if (success) {
        err.requestOptions.headers['Authorization'] = 'Bearer ${authenticationService.accessToken}';
        final cloneRequest = await authenticationService.dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters
        );
        return handler.resolve(cloneRequest);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }
}