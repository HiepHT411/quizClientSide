import 'package:quizflutter/models/quiz.dart';

class QuizResult {
  final Quiz quiz;
  final int correctAnswer;
  final int totalQuestion;

  QuizResult(this.quiz, this.correctAnswer, this.totalQuestion);
}