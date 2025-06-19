import 'package:flutter/material.dart';

class HeroWidget extends StatefulWidget {
  HeroWidget({super.key, required this.title, this.nextPage});

  String? title;
  final String? nextPage;

  @override
  State<StatefulWidget> createState() {
    return HeroWidgetState();
  }
}

class HeroWidgetState extends State<HeroWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.nextPage != null ? () {
        Navigator.pushNamed(
            context, widget.nextPage!);
      } : null,
      child: Stack(
      alignment: Alignment.center,
        children: [
          Hero(
        tag: 'hero1',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset('assets/images/bg.png', color: Colors.green, colorBlendMode: BlendMode.darken,),
        )),
          FittedBox(
            child: Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                letterSpacing: 20,
                color: Colors.white60
              ),
            ),
          )
      ]
    ));
  }
}
