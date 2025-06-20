import 'package:quizflutter/models/question.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final List<Question> questions;

  // Quiz(this.id, this.title, this.description, this.questions);

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  copyWith({required List<Question> questions}) {
    return Quiz(id: id, title: title, description:  description, questions: questions);
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>, json['id']))
          .toList(),
    );
  }
}