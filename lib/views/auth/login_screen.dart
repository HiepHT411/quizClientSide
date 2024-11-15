import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/authentication_result.dart';
import 'package:quizflutter/providers/authentication_provider.dart';

class LoginScreen extends StatelessWidget {
  final AuthenticationProvider authProvider = AuthenticationProvider();

  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController passwordEditController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailEditController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordEditController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = emailEditController.text;
                final password = passwordEditController.text;

                final AuthenticationResult result =
                    await authProvider.login(email, password);

                if (result.success) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.quizList.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.errorMessage),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.register.toString());
              },
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
