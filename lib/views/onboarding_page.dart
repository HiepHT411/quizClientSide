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
  bool isFirst = true;

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
              }),
              Padding(padding: const EdgeInsets.all(16.0),
                child: AnimatedCrossFade(
                    firstChild: Center(
                      child: Image.asset('assets/images/quizapplogo.png'),
                    ),
                    secondChild: Center(
                      child: Image.asset('assets/images/bg.png'),
                    ),
                    crossFadeState: isFirst ? CrossFadeState.showSecond : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300)),
              ),
              IconButton(onPressed: () {
                setState(() {
                  isFirst = !isFirst;

                });
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
        ));
  }

}