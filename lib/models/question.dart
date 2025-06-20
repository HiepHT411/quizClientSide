import 'package:quizflutter/models/answer.dart';

class Question {
  final int id;
  final int quizId;
  final String questionText;
  final bool isMultipleChoice;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.isMultipleChoice,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json, int quizId) {
    return Question(
      id: json['id'] as int,
      quizId: quizId,
      questionText: json['prompt'] as String,
      isMultipleChoice: json['isMultipleChoice'] != null ? json['isMultipleChoice'] as bool : true,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}