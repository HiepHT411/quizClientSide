import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quizflutter/components/hero_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  TextEditingController dumController = TextEditingController();
  bool? isChecked = false;
  bool isSwitch = true;
  double sliderValue = 0.0;
  String? selectedItem = 'e1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false, // remove default back to previous arrow button so I can create my own
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton(
                  value: selectedItem,
                  items: const [
                    DropdownMenuItem(value: 'e1', child: Text('element 1')),
                    DropdownMenuItem(value: 'e2', child: Text('element 2')),
                    DropdownMenuItem(value: 'e3', child: Text('element 3')),
                  ],
                  onChanged: (String? val) => {
                        setState(() {
                          selectedItem = val;
                        })
                      }),
              TextField(
                controller: dumController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onEditingComplete: () => setState(() {}),
              ),
              Text(dumController.text),
              CheckboxListTile.adaptive(
                  value: isChecked,
                  tristate: true,
                  title: const Text('Click me'),
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value;
                    });
                  }),
              SwitchListTile.adaptive(
                  title: const Text('Switch me'),
                  value: isSwitch,
                  onChanged: (bool value) => setState(() {
                        isSwitch = value;
                      })),
              Slider.adaptive(
                  max: 100,
                  min: 0,
                  value: sliderValue,
                  divisions: 100,
                  onChanged: (double value) => setState(() {
                        sliderValue = value;
                      })),
              InkWell(
                  splashColor: Colors.teal,
                  onTap: () => {print('image clicked')},
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.white12,
                  )),
              GestureDetector(
                  onTap: () => {print('image clicked 2')},
                  child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.white12,
                      child: const HeroWidget())),
              ElevatedButton(
                  onPressed: () {}, child: Text('default elevated button')),
              ElevatedButton(
                  onPressed: () {},
                  child: Text('custom elevated button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  )),
              FilledButton(
                  onPressed: () {}, child: const Text('Filled Button')),
              TextButton(onPressed: () {}, child: const Text('Text button')),
              OutlinedButton(
                  onPressed: () {}, child: const Text('Outline Button')),
              CloseButton(),
              BackButton()
            ],
          ),
        )));
  }
}
