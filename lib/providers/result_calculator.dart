import 'package:quizflutter/models/answer.dart';
import 'package:quizflutter/models/question.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/models/quiz_result.dart';

class ResultCalculator {
  final Quiz quiz;

  final Map<int, List<int>> answers;


  ResultCalculator({required this.quiz}) : answers = {};

  void addAnswers(int questionId, List<int> answerIds) {
    answers[questionId] = answerIds;
  }

  void setAnswers(Map<int, List<int>> answers) {
    this.answers.clear();
    this.answers.addAll(answers);
  }

  QuizResult calculateResult() {
    int correctAnswers = 0;
    for (Question ques in quiz.questions) {
      List<int> selectedAnswerIds = answers[ques.id] ?? [];
      bool correct = true;
      for (Answer ans in ques.answers) {
        if ((selectedAnswerIds.contains(ans.id) && !ans.correct) || (!selectedAnswerIds.contains(ans.id) && ans.correct)) {
          correct = false;
          break;
        }
      }
      if (correct) {
        correctAnswers ++;
      }
    }
    return QuizResult(quiz, correctAnswers, quiz.questions.length);
  }
}