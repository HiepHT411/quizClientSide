import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/authentication_result.dart';
import 'package:quizflutter/providers/authentication_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State createState() {
    return RegisterScreenState();
  }
}
class RegisterScreenState extends State<RegisterScreen> {
  final AuthenticationProvider authenticationProvider = AuthenticationProvider();

  final TextEditingController usernameEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController passwordEditController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  late AuthenticationResult authenticationResult;


  @override
  void initState() {
    authenticationResult = AuthenticationResult(success: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameEditController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
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
            TextField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final username = usernameEditController.text;
                final email = emailEditController.text;
                final password = passwordEditController.text;
                final confirmPassword = passwordConfirmController.text;

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match.'),
                    ),
                  );
                  return;
                }
                final AuthenticationResult result =
                await authenticationProvider.signup(username, email, password);
                authenticationResult = result;
                // if (result.success) {
                //   Navigator.pushReplacementNamed(
                //       context, AppRoutes.login.toString());
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(result.errorMessage),
                //     ),
                //   );
                // }
                if (result.success) {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog (
                    title: const Text('Registration Successfully'),
                    content: const Text('Please activate your account through activate link sent to your email account.'),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                      TextButton(onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pushReplacementNamed(
                              context, AppRoutes.login.toString()),

                      }, child: const Text('Back to login Page'))
                    ],
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.errorMessage),
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.login.toString());
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}