import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizflutter/constants/constants.dart';
import 'package:quizflutter/learning/blocLib/counter_bloc.dart';
import 'package:quizflutter/learning/blocLib/counter_event.dart';
import 'package:quizflutter/learning/blocLib/counter_provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return CounterProvider( // put this at high level so all its children could inherit
        child: Scaffold(
          body: BlocBuilder<CounterBloc, int>(builder:  ((context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text('Count $state', style: Constants.titleTealText,),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _customButton(() =>  _increase(context), "Increase"),
                    _customButton(() => _decrease(context), "Decrease")
                  ],
                )
              ],
            );
          })),
        )
    );
  }

  void _increase(BuildContext context) {
    context.read<CounterBloc>().add(IncreaseEvent());
  }

  void _decrease(BuildContext context) {
    context.read<CounterBloc>().add(DecreaseEvent());
  }

  Widget _customButton(Function() onPressed, String text) {
    return ElevatedButton(onPressed: onPressed, child: Text(text,));
  }
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Counter App",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const CounterPage(),
    );
  }
}

void main() {
  runApp(const CounterApp());
}

