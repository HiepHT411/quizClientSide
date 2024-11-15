import 'package:quizflutter/models/question.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final List<Question> questions;

  Quiz(this.id, this.title, this.description, this.questions);

  copyWith({required List<Question> questions}) {
    return Quiz(id, title, description, questions);
  }
}