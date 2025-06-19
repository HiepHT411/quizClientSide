import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quizflutter/components/container_widget.dart';
import 'package:quizflutter/components/hero_widget.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/constants/constants.dart';

class OnboardingPage extends StatefulWidget {

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() {
    return _OnboardingState();
  }
}

class _OnboardingState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    List<String> listContainer = [Headers.keyConcepts, Headers.basicLayout, Headers.cleanUI, Headers.fixBugs];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeroWidget(
                title: 'Let\'s go',
                nextPage: AppRoutes.quizList,
              ),
              ...List.generate(listContainer.length, (index)  {
                return ContainerWidget(title: listContainer.elementAt(index), description: 'Sample description');
              })
            ],
          ),
        ));
  }

}