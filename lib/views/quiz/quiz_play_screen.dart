import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/models/question.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/providers/result_calculator.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State createState() {
    return QuizPlayScreenState();
  }
}

class QuizPlayScreenState extends State<QuizPlayScreen> {
  late ResultCalculator resultCalculator;
  int index = 1;

  @override
  void initState() {
    resultCalculator = ResultCalculator(quiz: widget.quiz);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) => setState(() {
                        index = value + 1;
                      }),
                  itemCount: widget.quiz.questions.length,
                  itemBuilder: (context, index) {
                    return buildQuestionCard(widget.quiz.questions[index]);
                  })),
          Text("Question $index of ${widget.quiz.questions.length}",
              style: const TextStyle(fontSize: 16.0)),
          ElevatedButton(
            onPressed: () {
              if (index < widget.quiz.questions.length) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.quizResult,
                  arguments: resultCalculator,
                );
              }
            },
            child: const Text('Next', style: TextStyle(fontSize: 14)),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.quizResult,
                    arguments: resultCalculator);
              },
              child: const Text('Submit', style: TextStyle(fontSize: 14)))

        ],
      ),
    );
  }

  Widget buildQuestionCard(Question question) {
    return Card(
        borderOnForeground: true,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(question.questionText,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: question.answers.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(question.answers[index].text),
                      value: resultCalculator.answers[question.id]
                              ?.contains(question.answers[index].id) ??
                          false,
                      onChanged: (value) {
                        setState(() {
                          var answers = resultCalculator.answers;
                          var quiz = resultCalculator.quiz;

                          if (value == true) {
                            if (question.answers[index].id != null) {
                              answers[question.id] = [
                                ...answers[question.id] ?? [],
                                question.answers[index].id!
                              ];
                              resultCalculator = ResultCalculator(quiz: quiz);
                              resultCalculator.setAnswers(answers);
                            }
                          } else {
                            if (question.answers[index].id != null) {
                              answers[question.id] = [
                                ...answers[question.id] ?? []
                              ];
                              answers[question.id]
                                  ?.remove(question.answers[index].id);
                              resultCalculator = ResultCalculator(quiz: quiz);
                              resultCalculator.setAnswers(answers);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
