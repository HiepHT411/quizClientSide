import 'package:quizflutter/models/answer.dart';

class Question {
  final int id;
  final int quizId;
  final String questionText;
  final bool isMultipleChoice;
  final List<Answer> answers;

  Question(this.id, this.quizId, this.questionText, this.isMultipleChoice,
      this.answers);
}