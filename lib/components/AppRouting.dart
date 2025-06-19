import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/main.dart';
import 'package:quizflutter/models/question.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/providers/result_calculator.dart';
import 'package:quizflutter/views/auth/login_screen.dart';
import 'package:quizflutter/views/auth/register_screen.dart';
import 'package:quizflutter/views/onboarding_page.dart';
import 'package:quizflutter/views/profile.dart';
import 'package:quizflutter/views/question/question_detail_screen.dart';
import 'package:quizflutter/views/question/question_form_screen.dart';
import 'package:quizflutter/views/quiz/quiz_detail_screen.dart';
import 'package:quizflutter/views/quiz/quiz_list_screen.dart';
import 'package:quizflutter/views/quiz/quiz_play_screen.dart';
import 'package:quizflutter/views/quiz/quiz_result_screen.dart';
import 'package:quizflutter/views/quiz/quiz_review_screen.dart';
import 'package:quizflutter/views/setting_page.dart';
import 'package:quizflutter/views/websocket/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutingApp extends StatelessWidget {
  const RoutingApp({super.key});
  static String username = "";
  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("email");
    if (email != null) {
        username = email;
    }
  }

  String loadInitRoute() {
    loadUsername();
    if (username.isNotEmpty) {
      return AppRoutes.home;
    } else {
      return AppRoutes.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Quiz Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: loadInitRoute(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (context) => const MyApp());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case AppRoutes.register:
            return MaterialPageRoute(
                builder: (context) => const RegisterScreen());
          case AppRoutes.quizList:
            return MaterialPageRoute(
                builder: (context) => const QuizListScreen());
          case AppRoutes.quizDetail:
            return MaterialPageRoute(builder: (context) =>
                QuizDetailScreen(quiz: settings.arguments as Quiz));
          case AppRoutes.quizPlay:
            return MaterialPageRoute(builder: (context) =>
                QuizPlayScreen(quiz: settings.arguments as Quiz));
          case AppRoutes.questionDetail:
            return MaterialPageRoute(builder: (context) =>
                QuestionDetailScreen(
                    question: settings.arguments as Question));
          case AppRoutes.questionForm:
            return MaterialPageRoute(builder: (context) {
              final args = settings.arguments as QuestionFormScreenArgs;
              return QuestionFormScreen(
                  quizId: args.quizId, question: args.question);
            });
          case AppRoutes.quizResult:
            return MaterialPageRoute(builder: (context) => QuizResultScreen(
                resultCalculator: settings.arguments as ResultCalculator));
          case AppRoutes.quizReview:
            return MaterialPageRoute(builder: (context) => QuizReviewScreen(
                resultCalculator: settings.arguments as ResultCalculator));
          case AppRoutes.chatPlatform:
            loadUsername();
            return MaterialPageRoute(builder: (context) => ChatPage(title: "Chatting Platform", username: username));
          case AppRoutes.setting:
            return MaterialPageRoute(builder: (context) => const SettingPage(title: "Setting"));
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          case AppRoutes.onboarding:
            return MaterialPageRoute(builder: (context) => const OnboardingPage());
          default:
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  }


}