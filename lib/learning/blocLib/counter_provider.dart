import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizflutter/learning/blocLib/counter_bloc.dart';

class CounterProvider extends StatelessWidget {
  final Widget child;
  const CounterProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
            create: (BuildContext context) => CounterBloc(), // create instance of bloc so all its children could use that bloc
            child: child,
    );
  }
}
