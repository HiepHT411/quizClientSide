import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/question.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/providers/quiz_provider.dart';
import 'package:quizflutter/views/question/question_form_screen.dart';

class QuizDetailScreen extends StatefulWidget{
  final Quiz quiz;

  const QuizDetailScreen({super.key, required this.quiz});

  @override
  State createState() {
    return QuizDetailScreenState();
  }
}

class QuizDetailScreenState extends State<QuizDetailScreen> {
  late Quiz _quiz;

  @override
  void initState() {
    _quiz = widget.quiz;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _quiz);
      },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_quiz.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: "Edit Quiz",
                onPressed: showEditDialog,
              ),
              IconButton(
                  icon: const Icon(Icons.play_arrow),
                  tooltip: "Start Quiz",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.quizPlay,
                        arguments: _quiz);
                  })
            ],
          ),
          body: buildQuizQuestionsList(),
          floatingActionButton: FloatingActionButton(
              tooltip: "Add Question",
              onPressed: () async {
                QuestionFormScreenArgs args =
                QuestionFormScreenArgs(quizId: _quiz.id);
                Quiz tmpQuiz = await Navigator.pushNamed(
                    context, AppRoutes.questionForm,
                    arguments: args) as Quiz;
                setState(() {
                  _quiz = tmpQuiz;
                });
              },
              child: const Icon(Icons.add)),
        )
    );
  }

  Widget buildQuizQuestionsList() {
    final List<Question> questions = _quiz.questions;

    if (questions.isEmpty) {
      return const Center(
        child: Text('No questions available.'),
      );
    }

    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return buildQuestionTile(context, question);
      },
    );
  }

  Widget buildQuestionTile(BuildContext context, Question question) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(question.questionText),
          onTap: () async {
            Question tmpQuestion = await Navigator.pushNamed(
                context, AppRoutes.questionDetail, arguments: question)
            as Question;
            setState(() {
              // update _quiz with the edited question
              _quiz.questions[_quiz.questions
                  .indexWhere((q) => q.id == tmpQuestion.id)] = tmpQuestion;
            });
          },
        ),
      ),
      onTapDown: (TapDownDetails details) {
        final screenSize = MediaQuery.of(context).size;
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              screenSize.width - details.globalPosition.dx,
              screenSize.height - details.globalPosition.dy),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              child: const Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Text("Delete"),
                ],
              ),
              onTap: () {
                deleteQuestion(question);
              },
            )
          ],
        );
      },
    );
  }

  void showEditDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController titleController =
          TextEditingController(text: _quiz.title);
          final TextEditingController descriptionController =
          TextEditingController(text: _quiz.description);

          return AlertDialog(
              content: Stack(
                children: <Widget>[
                  const Text("Edit Quiz",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                child: const Text("Save"),
                                onPressed: () {
                                  saveEdit(titleController.text,
                                      descriptionController.text);
                                }))
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  Future<void> saveEdit(String title, String description) async {
    final quizProvider = QuizProvider();
    try {
      Quiz tmpQuiz =
      await quizProvider.updateQuiz(_quiz.id, title, description);
      setState(() {
        _quiz = tmpQuiz;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> deleteQuestion(Question question) async {
    final quizProvider = QuizProvider();
    try {
      await quizProvider.deleteQuestion(question.quizId, question.id);
      setState(() {
        _quiz.questions.removeWhere((q) => q.id == question.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
