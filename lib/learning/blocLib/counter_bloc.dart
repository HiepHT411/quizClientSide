
import 'package:bloc/bloc.dart';
import 'package:quizflutter/learning/blocLib/counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {

  // count start from Zero
  CounterBloc() : super(0) {
    // emit: publish event
    on<IncreaseEvent>((event, emit) => _increase(emit));

    on<DecreaseEvent>((event, emit) => _decrease(emit));
  }
    _increase(Emitter emit) {
      emit(state + 1);
    }

    _decrease(Emitter emit) {
      emit(state - 1);
    }


}