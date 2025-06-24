import 'package:flutter/material.dart';
import 'package:quizflutter/constants/constants.dart';
import 'package:quizflutter/learning/blocPattern/pet_bloc.dart';
import 'package:quizflutter/learning/blocPattern/pet_event.dart';
import 'package:quizflutter/learning/blocPattern/pet_state.dart';

void main() {
  runApp(const PetScreen());
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final TextEditingController nameEditController = TextEditingController();
  final TextEditingController kindEditController = TextEditingController();
  final TextEditingController genderEditController = TextEditingController();
  final TextEditingController timeEditController = TextEditingController();

  PetBloc petBloc = PetBloc();

  PetState petState = PetState.initial();

  @override
  void dispose() {
    nameEditController.dispose();
    kindEditController.dispose();
    genderEditController.dispose();
    petBloc.dispose();
    super.dispose();
  }

  onPressed(PetEvent event) {
    petState.name = nameEditController.text;
    petState.kind = kindEditController.text;
    petState.gender = genderEditController.text;

    print('current petState: ${petState.toString()}');
    print('onPressed: $event');
    petBloc.handleEvent(event, petState, int.tryParse(timeEditController.text));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Pet app')),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                stream: petBloc.state,
                builder: (context, snapshot) {
                  final petStateSnapshot = snapshot.data;
                  if (petStateSnapshot != null) {
                    petState = petStateSnapshot;
                    print('after petState: ${petState.toString()}');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (petStateSnapshot == null)
                        const CircularProgressIndicator()
                      else if (petState.isShowered)
                        const Text('Showered', style: Constants.descText)
                      else if (petState.isPetted)
                        const Text('Petted', style: Constants.descText)
                      else if (petState.isFed)
                        const Text('Fed', style: Constants.descText)
                      else if (petState.isSleeping)
                        const Text('Sleeping', style: Constants.descText),
                      TextField(
                        controller: nameEditController,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: kindEditController,
                        decoration: InputDecoration(
                            hintText: 'Kind',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: genderEditController,
                        decoration: InputDecoration(
                            hintText: 'Gender',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: timeEditController,
                        decoration: InputDecoration(
                            hintText: 'Time',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () => onPressed(PetEvent.shower),
                        child: const Text('Shower'),
                      ),
                      ElevatedButton(
                        onPressed: () => onPressed(PetEvent.feed),
                        child: const Text('Feed'),
                      ),
                      ElevatedButton(
                        onPressed: () => onPressed(PetEvent.pet),
                        child: const Text('Pet')
                      ),
                      ElevatedButton(
                        onPressed: () => onPressed(PetEvent.sleep),
                        child: const Text('Put to sleep'),
                      ),
                    ],
                  );
                },
                initialData: petState,
              ),
            )));
  }
}
