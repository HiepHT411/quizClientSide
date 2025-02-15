
import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/quiz_result.dart';
import 'package:quizflutter/providers/result_calculator.dart';

class QuizResultScreen extends StatefulWidget {
  final ResultCalculator resultCalculator;

  const QuizResultScreen({super.key, required this.resultCalculator});

  @override
  QuizResultScreenState createState() => QuizResultScreenState();
}

class QuizResultScreenState extends State<QuizResultScreen> {
  late QuizResult _quizResult;

  @override
  void initState() {
    super.initState();
    _quizResult = widget.resultCalculator.calculateResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Result"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'You got ${_quizResult.correctAnswer} out of ${_quizResult.totalQuestion} correct!',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.quizPlay,
                            arguments: widget.resultCalculator.quiz);
                      },
                      child: const Text("Retake Quiz")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.quizReview,
                            arguments: widget.resultCalculator);
                      },
                      child: const Text("Review Answers")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.quizList, (route) => false);
                      },
                      child: const Text("Go back to Quiz List")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
