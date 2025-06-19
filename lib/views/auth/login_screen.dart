import 'package:flutter/material.dart';
import 'package:quizflutter/components/hero_widget.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/authentication_result.dart';
import 'package:quizflutter/providers/authentication_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:quizflutter/views/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginScreen> {
  final AuthenticationProvider authProvider = AuthenticationProvider();

  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController passwordEditController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailEditController.dispose();
    passwordEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width; // get device's screen size
    return Scaffold(
        // appBar: AppBar(
        //     leading: BackButton(onPressed: (){Navigator.pop(context);}),
        //     ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return FractionallySizedBox(
                    widthFactor: widthScreen > 500 ? 0.5 : 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const HeroWidget(),
                        Lottie.asset('assets/animations/login.json', height: 300),
                        const FittedBox(
                          child: Text('Easy English',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 45.0,
                                  letterSpacing: 18)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: emailEditController,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: passwordEditController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () async {
                            onLoginPress();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40.0)),
                          child: const Text('Login'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.register);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40.0)),
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                  );
                })
          ),
        )));
  }

  void onLoginPress() async {
    final email = emailEditController.text;
    final password = passwordEditController.text;

    final AuthenticationResult result =
        await authProvider.login(email, password);

    if (result.success) {
      // Navigator.pushReplacementNamed(
      //     context, AppRoutes.home.toString());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return const Home(title: 'Welcome');}), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage),
        ),
      );
    }
  }
}
