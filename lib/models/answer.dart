class Answer {
  final int? id;
  final String text;
  final bool correct;

  Answer({this.id, required this.text, required this.correct});

  toJson() {
    return {
      'text': text,
      'correct': correct
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] != null ? json['id'] as int : null,
      text: json['text'] as String,
      correct: json['correct'] as bool,
    );
  }
}