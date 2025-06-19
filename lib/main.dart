import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/constants/constants.dart';
import 'package:quizflutter/utility/notifier.dart';
import 'package:quizflutter/views/auth/login_screen.dart';
import 'package:quizflutter/views/auth/register_screen.dart';
import 'package:quizflutter/views/home.dart';
import 'package:quizflutter/views/onboarding_page.dart';
import 'package:quizflutter/views/quiz/quiz_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    initThemMode();
  }

  void initThemMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool(Constants.themeModeKey);
    isDarkModeNotifier.value = isDarkMode ?? false;
  }

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
              AppRoutes.register: (context) => const RegisterScreen(),
              AppRoutes.quizList: (context) => const QuizListScreen()
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