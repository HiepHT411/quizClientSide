import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quizflutter/components/AppRouting.dart';
import 'package:quizflutter/components/hero_widget.dart';
import 'package:quizflutter/components/navbar_widget.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/constants/constants.dart';
import 'package:quizflutter/utility/notifier.dart';
import 'package:quizflutter/views/auth/login_screen.dart';
import 'package:quizflutter/views/onboarding_page.dart';
import 'package:quizflutter/views/profile.dart';
import 'package:quizflutter/views/quiz/quiz_list_screen.dart';
import 'package:quizflutter/views/setting_page.dart';
import 'package:quizflutter/views/websocket/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [const OnboardingPage(), const ProfilePage()];

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text(title),
        titleTextStyle: const TextStyle(
          fontSize: 24,          // Set font size
          fontWeight: FontWeight.bold, // Set font weight
        ),
        leading: const Icon(Icons.notification_add, color: Colors.amber,),
      ),
      floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(onPressed: () {print ('Floating Action Button');}, child: const Icon(Icons.arrow_upward)),
            const SizedBox(height: 10.0,)
          ]
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
        ],
        onDestinationSelected: (int value) {},
        selectedIndex: 0,
      ),
    );
  }
}

class HomeState extends State<Home> {

  int selectedIdx = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late String username = '';

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("email");
    if (email != null) {
      setState(() {
        username = email;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  } // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Hi, $username'),
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu));
          }),
        actions: [
          IconButton(
              onPressed: () async {
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool(Constants.themeModeKey, isDarkModeNotifier.value);
              },
              icon: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, isDarkMode, child) {
                    return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
                  }))
        ],
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
            child: Text('Hi, $username')
        ),
        ListTile(
            leading: const Icon(Icons.join_full),
            title: const Text('Quiz'),
            selected: selectedIdx == 0,
            onTap: () {
              if (username.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuizListScreen()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoutingApp()));
              }
            }),
        ListTile(
          title: const Text('Chat'),
          selected: selectedIdx == 1,
          onTap: () {
            if (username.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            title: "Chatting Platform",
                            username: username,
                          )));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RoutingApp()));
            }
          },
          trailing: const Text('realtime'),
        ),
        ListTile(
          title: const Text('Setting'),
          onTap: () {
            if (username.isNotEmpty) {
              Navigator.push(context,  //pushReplacement will remove previous page so we can not pop back
                  MaterialPageRoute(
                    builder: (context) => const SettingPage( title: 'Settings',)
                  ));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RoutingApp()));
            }
          },
        ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                if (username.isNotEmpty) {
                  final SharedPreferences prefs = await SharedPreferences.getInstance() ;
                  prefs.remove('email');
                  prefs.remove('accessToken');
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.login);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RoutingApp()));
                }
              },
            )
      ])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const Center(child: Text('Welcome ')),
            SizedBox(
              height: 500,
              child: ValueListenableBuilder(
                valueListenable: selectedPageNotifier,
                builder: (context, selectedPage, child) {
                  return pages.elementAt(selectedPage);
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}