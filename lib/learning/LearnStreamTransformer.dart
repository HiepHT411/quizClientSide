import 'dart:async';

main() async {
  int sum = 0;
  Stream<String> streamIn = Stream.fromIterable(['1', '2', '3', '4']);

  StreamTransformer<String, int> stringToEvenIntTransformer = StreamTransformer.fromHandlers(
    handleData: ((data, sink) {
      int num = int.parse(data);
      if (num % 2 == 0) {
        sink.add(num);
      }
      sum += num;
    })
  );

  Stream streamOut = streamIn.transform(stringToEvenIntTransformer);
  streamOut.listen((e) {
    print(e);
  }, onDone: () => print("Sum $sum"));
}