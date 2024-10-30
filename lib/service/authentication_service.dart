import 'package:injectable/injectable.dart';
import 'package:login_logout/service/dio_service.dart';

@lazySingleton
class AuthenticationService {
  final DioService _dioService;
  String? _token;

  AuthenticationService(this._dioService);

  Future<bool> login(String username, String password) async {
    final response = await _dioService.login(username, password);
    if (response.statusCode == 200) {
      _token = response.data['token'];
      _dioService.setAuthToken(_token!);
      return true;
    }
    return false;
  }

  Future<bool> refreshToken() async {
    // Implement token refresh logic here
    return false;
  }

  void logout() {
    _token = null;
    _dioService.clearAuthToken();
  }

}