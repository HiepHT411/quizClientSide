import 'package:flutter/material.dart';
import 'package:quizflutter/components/AppRouting.dart';
import 'package:quizflutter/constants/app_routes.dart';
import 'package:quizflutter/views/auth/login_screen.dart';
import 'package:quizflutter/views/quiz/quiz_list_screen.dart';
import 'package:quizflutter/views/websocket/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoangHiep',
      initialRoute: AppRoutes.login,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const Home(title: 'Welcome'),
    );
  }
}
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
      )
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
            })),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Text('Hi, $username')),
          ListTile(
              title: const Text('Quiz'),
              selected: selectedIdx == 0,
              onTap: () {
                if (username.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizListScreen()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RoutingApp()));
                }
              }),
          ListTile(
              title: const Text('Chat'),
              selected: selectedIdx == 1,
              onTap: () {
                if (username.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(title: "Chatting Platform", username: username,)));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RoutingApp()));
                }
              })
        ])),
        body: Center(child: Text('Welcome $username to Quiz Flutter')),
    );
  }
}
