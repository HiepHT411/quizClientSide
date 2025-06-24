
class PetState {

  String kind;

  String name;

  String gender;

  final bool isSleeping;

  final bool isShowered;

  final bool isFed;

  final bool isPetted;

  PetState({required this.kind, required this.name, required this.gender, required this.isSleeping, required this.isShowered, required this.isFed, required this.isPetted});


  factory PetState.initial() {
    return PetState(
        kind: '',
        name: '',
        gender: '',
        isSleeping: false,
        isShowered: false,
        isFed: false,
        isPetted: false);
  }

  factory PetState.showering(PetState currentState) {
    return PetState(
        kind: currentState.kind,
        name: currentState.name,
        gender: currentState.gender,
        isSleeping: false,
        isShowered: true,
        isFed: currentState.isFed,
        isPetted: currentState.isPetted);
  }

  factory PetState.petting(PetState currentState) {
    return PetState(
        kind: currentState.kind,
        name: currentState.name,
        gender: currentState.gender,
        isSleeping: false,
        isShowered: currentState.isShowered,
        isFed: currentState.isFed,
        isPetted: true);
  }

  factory PetState.feeding(PetState currentState) {
    return PetState(
        kind: currentState.kind,
        name: currentState.name,
        gender: currentState.gender,
        isSleeping: false,
        isShowered: currentState.isShowered,
        isFed: true,
        isPetted: currentState.isPetted);
  }

  factory PetState.sleep(PetState currentState) {
    return PetState(
        kind: currentState.kind,
        name: currentState.name,
        gender: currentState.gender,
        isSleeping: true,
        isShowered: false,
        isFed: false,
        isPetted: false);
  }


  @override
  String toString() {
    return 'PetState{kind: $kind, name: $name, gender: $gender, isSleeping: $isSleeping, isShowered: $isShowered, isFed: $isFed, isPetted: $isPetted}';
  }
}