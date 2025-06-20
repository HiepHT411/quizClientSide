
Stream<int> countStream(int value) async* {
  for (int i=0; i<value; i++) {
    yield i;
  }
}

Future<int> sumStream(Stream<int> stream) async {
  int sum = 0;
  await for (int value in stream) {
    sum += value;
  }
  return sum;
}

main() async {
  print('begin1');
  countStream(10).listen((event) {
    print (event.toString());
  });
  print('end1');

  print('begin2');
  await for (int value in countStream(10)) {
    print(value);
  }
  print('end2');
  print('\n---------------');

  print('Sum ${await sumStream(countStream(7))}');
  print('\n---------------');

  var dataFuture = Future.delayed(const Duration(seconds: 2), () {
    return 99;
  });

  Stream<int> streamFuture = Stream.fromFuture(dataFuture);

  streamFuture.listen((e) => print('dataFuture ${e}') );

  var dataIterable = Iterable.generate(6, (value) => value);

  Stream<int> streamIterable = Stream.fromIterable(dataIterable);
  streamIterable.listen((event) {
    print ('Iterable data ${event.toString()}');
  });

  Stream<int> streamPeriodic = Stream.periodic(const Duration(seconds: 1), (value) => value); // single subscription
  streamPeriodic.listen((event) {
    print ('Periodic single subscription: ${event.toString()}');
  });

  Stream<int> streamPeriodicBroadcast = Stream.periodic(const Duration(seconds: 1), (value) => value).asBroadcastStream(); // single subscription
  streamPeriodicBroadcast.listen((event) {
    print ('Periodic broadcast 1: ${event.toString()}');
  });
  streamPeriodicBroadcast.listen((event) {
    print ('Periodic broadcast 2: ${event.toString()}');
  });
}