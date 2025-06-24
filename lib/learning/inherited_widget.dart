
import 'package:flutter/material.dart';

void main() {
  runApp(const ParentWidget());
}

class FamilyProvider extends InheritedWidget {

   final String? hairColor;

   final Function(String) changeHairColor;

  const FamilyProvider({super.key, required super.child, this.hairColor, required this.changeHairColor});

  @override
  bool updateShouldNotify(FamilyProvider oldWidget) {
   return hairColor != oldWidget.hairColor;
  }

  static FamilyProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FamilyProvider>();

}

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String hairColor = 'Black';

  void changeHairColor(String newColor) {
    setState(() {
      hairColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( home: Scaffold(
      body: Center(
        child: FamilyProvider(hairColor: hairColor, changeHairColor: changeHairColor, child: ChildWidget()),
      ),
    ));
  }
}


class ChildWidget extends StatelessWidget {
  ChildWidget({super.key});
  final TextEditingController hairEditController = TextEditingController();

    @override
  Widget build(BuildContext context) {

    final familyProvider = FamilyProvider.of(context);

    final String? hairColor = familyProvider?.hairColor;

    onButtonPressed() {
      var newHairColor = hairEditController.text;
      familyProvider?.changeHairColor(newHairColor);
    }
    return Column(
      children: [

        hairColor == null ? const  CircularProgressIndicator() : Text(hairColor),
        TextFormField(controller: hairEditController, decoration: InputDecoration(
            hintText: 'Hair Color',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)))
        ),
        ElevatedButton(
          onPressed: () => onButtonPressed()  ,
          child: const Text('Dye hair'),
        ),
      ],
    );
  }
}
