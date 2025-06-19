import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/utility/notifier.dart';
import 'package:quizflutter/views/auth/login_screen.dart';
import 'package:quizflutter/views/auth/register_screen.dart';
import 'package:quizflutter/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, isDarkMode, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HoangHiep',
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.home: (context) => const Home(title: 'Welcome'),
              AppRoutes.register: (context) => const RegisterScreen()
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurpleAccent,
                  brightness: isDarkMode ? Brightness.dark : Brightness.light),
              useMaterial3: true,
            ),
            home: const Home(title: 'Welcome'),
          );
        });
  }
}