import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_logout/core/service/authentication_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = GetIt.I<AuthenticationService>();


  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final success = await _authService.login(username, password);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failure")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      	child: Column(
      		mainAxisAlignment: MainAxisAlignment.center,
      		children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login"))
          ],
        ),
      )
    );
  }
}
