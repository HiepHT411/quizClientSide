import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/providers/quiz_provider.dart';

class QuizListScreen extends StatefulWidget {

  const QuizListScreen({super.key});

  @override
  State createState() {
    return _QuizListScreenState();
  }
}

class _QuizListScreenState extends State<QuizListScreen> {

  List<Quiz> quizzes = [];


  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    final quizProvider = QuizProvider();
    await quizProvider.fetchQuizzes();
    setState(() {
      quizzes = quizProvider.quizzes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadQuizzes,
            tooltip: "Refresh",
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, AppRoutes.login.toString());
            },
            tooltip: "Logout",
          )
        ],
      ),
      body: buildQuizList(quizzes),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Quiz",
        onPressed: addQuiz,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildQuizList(List<Quiz> quizzes) {
    if (quizzes.isEmpty) {
      return const Center(
        child: Text('No quizzes available.'),
      );
    }

    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return buildQuizTile(context, quiz);
      },
    );
  }

  Widget buildQuizTile(BuildContext context, Quiz quiz) {
    return GestureDetector(
      onTapDown: (details) {
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
                deleteQuiz(quiz);
              },
            )
          ],
        );
      },
      child: Card(
        child: ListTile(
          title: Text(quiz.title),
          subtitle: Text(quiz.description),
          onTap: () async {
            Quiz tmpQuiz = await Navigator.pushNamed(
                context, AppRoutes.quizDetail.toString(), arguments: quiz)
            as Quiz;
            setState(
                  () {
                quizzes[quizzes.indexWhere(
                        (element) => element.id == tmpQuiz.id)] = tmpQuiz;
              },
            );
          },
        ),
      ),
    );
  }

  void addQuiz() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController titleController = TextEditingController();
          final TextEditingController descriptionController =
          TextEditingController();

          return AlertDialog(
              content: Stack(
                children: <Widget>[
                  const Text("Add Quiz",
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
                                  saveAdd(titleController.text,
                                      descriptionController.text);
                                }))
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  Future<void> saveAdd(String title, String description) async {
    final quizProvider = QuizProvider();
    try {
      Quiz tmpQuiz = await quizProvider.addQuiz(title, description);
      setState(() {
        quizzes.add(tmpQuiz);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> deleteQuiz(Quiz quiz) async {
    final quizProvider = QuizProvider();
    try {
      await quizProvider.deleteQuiz(quiz.id);
      setState(() {
        quizzes.removeWhere((element) => element.id == quiz.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}