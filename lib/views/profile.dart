
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizflutter/components/hero_widget.dart';
import 'package:quizflutter/views/setting_page.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          HeroWidget(title: 'Profile',),
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/images/bg.png'),
          ),
          Text('Username')
        ],
      ),
    );
  }
  
}