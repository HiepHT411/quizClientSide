import 'package:flutter/material.dart';
import 'package:quizflutter/models/answer.dart';
import 'package:quizflutter/models/question.dart';
import 'package:quizflutter/models/quiz.dart';
import 'package:quizflutter/providers/quiz_provider.dart';

class QuestionFormScreenArgs {
  final int quizId;
  final Question? question;

  QuestionFormScreenArgs({required this.quizId, this.question});
}

class QuestionFormScreen extends StatefulWidget {
  final int quizId;
  final Question? question;

  const QuestionFormScreen({super.key, required this.quizId, this.question});

  @override
  State createState() {
    return QuestionFormScreenState();
  }
}

class QuestionFormScreenState extends State<QuestionFormScreen> {
  int answerCount = 1;
  String prompt = '';
  List<Answer> answers = [];

  @override
  void initState() {
    answerCount = widget.question != null ? widget.question!.answers.length + 1 : 1;
    prompt = widget.question != null ? widget.question!.questionText : '';
    answers = widget.question?.answers ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController(text: prompt);
    return Scaffold(
      appBar: AppBar(title: const Text('Question Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              onChanged: (value) => prompt = value,
              decoration: const InputDecoration(
                labelText: 'Question',
                hintText: 'Enter the question prompt'
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Answers'),
            const SizedBox(height: 16.0),
            Expanded(child: answerListBuilder()),
            const SizedBox(height: 16.0),
            ElevatedButton(onPressed: () async {
              Quiz? tmpQuiz = await addQuestion(prompt, answers);
              if (tmpQuiz != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Question saved successfully!"))
                );
                Navigator.pop(context, tmpQuiz);
              }
            }, child: const Text('Save Question'))
          ],
        )
      ),
    );
  }

  Widget answerListBuilder() {
    return ListView.builder(
      itemCount: answerCount,
      itemBuilder: (context, index) {
        // if last item, show the add answer button
        if (index == answerCount - 1) {
          return Card(
            child: ListTile(
              title: const Text('Add Answer'),
              onTap: () {
                setState(() {
                  answerCount++;
                });
              },
            ),
          );
        }
        return answerTileBuilder(index);
      },
    );
  }

  Widget answerTileBuilder(int index) {
    if (answerCount - 1 > answers.length) {
      answers.add(Answer(correct: false, text: ''));
    }

    final TextEditingController answerController = TextEditingController(text: answers[index].text);
    return Card(
      child: ListTile(
        title: TextField(
          controller: answerController,
          onChanged: (value) => answers[index] = Answer(text: value, correct: answers[index].correct),
          decoration: const InputDecoration(
            labelText: 'Answer Text',
            hintText: 'Enter the answer text'
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(value: answers[index].correct,
                    onChanged: (value) => {
                      setState(() {
                        answers[index] =Answer(correct: value, text: answers[index].text);
                      })
                    }
            ),
            IconButton(onPressed: () {
              setState(() {
                answerCount --;
                answers.removeAt(index);
              });
            }, icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );

  }


  Future<Quiz>? addQuestion(String prompt, List<Answer> answers) {
    QuizProvider quizProvider = QuizProvider();

    if (prompt.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Please enter a question prompt"))
     );
     return null;
    }
    for (final answer in answers) {
      if (answer.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a all answers for this question"))
        );
        return null;
      }
    }

    try {
      if (widget.question != null) {
        return quizProvider.updateQuestion(widget.quizId, widget.question!.id, prompt, answers);
      } else {
        return quizProvider.addQuestion(widget.quizId, prompt, answers);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save question!"))
      );
      return null;
    }
  }
}