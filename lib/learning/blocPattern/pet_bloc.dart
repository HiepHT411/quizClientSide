import 'dart:async';

import 'package:quizflutter/learning/blocPattern/pet_event.dart';
import 'package:quizflutter/learning/blocPattern/pet_state.dart';

class PetBloc {

  final stateController = StreamController<PetState>();

  Stream<PetState> get state => stateController.stream;

  void handleEvent(PetEvent event, PetState currentState, int? time) {
    switch (event) {
      case PetEvent.shower:
        Future.delayed(Duration(seconds: time ?? 2), () => stateController.sink.add(PetState.showering(currentState)));
        break;

      case PetEvent.feed:
        Future.delayed(Duration(seconds: time ?? 2), () => stateController.sink.add(PetState.feeding(currentState)));
        break;
      case PetEvent.pet:
        Future.delayed(Duration(seconds: time ?? 2), () => stateController.sink.add(PetState.petting(currentState)));
        break;
      case PetEvent.sleep:
        Future.delayed(Duration(seconds: time ?? 2), () => stateController.sink.add(PetState.sleep(currentState)));
        break;
        default:
          break;
    }
  }

  void dispose() {
    stateController.close();
  }
}