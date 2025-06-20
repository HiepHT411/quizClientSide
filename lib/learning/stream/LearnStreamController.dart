import 'dart:async';

import 'package:flutter/material.dart';

class Logic {
  StreamController countController = StreamController();

  Sink get sink => countController.sink;

  Stream get stream => countController.stream;

  Logic();

  Logic.assign(StreamController streamController) {
    countController = streamController;
  }

  int count = 0;

  void increase() {
    count++;
    sink.add(count);
  }

  addValue(String value) {
    sink.add(value);
  }
}

class Logic2 {
  Logic logic;

  Logic2(this.logic);

  Sink get sink => logic.sink;

  Stream get stream => logic.stream;

  void addValue(var value) {
    logic.sink.add(value);
  }

  void printValue() {
    logic.stream.listen((event) => print(event.toString()));
  }
}

void main() {
  runApp(const CounterWidget());
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  Logic logic = Logic();

  @override
  void dispose() {
    super.dispose();
    logic.countController.close();
  }

  onPressed() {
    logic.increase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    onChanged: ((value) => logic.addValue(value)),
                  )
              ),
              Center(
                  child: StreamBuilder(
                      stream: logic.stream,
                      builder: (context, snapshot) => snapshot.hasData
                          ? Text(snapshot.data.toString())
                          : const CircularProgressIndicator())),
              Center(
                  child: ElevatedButton(
                      onPressed: onPressed, child: const Text('Click me')))
            ],
          ),
        ));
  }
}
