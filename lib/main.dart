import 'package:final_project/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//////////////////// INSTRUCTIONS TO RUN ////////////////////
// 1. To make Firebase sign-in work, run line below in local Terminal
    // flutter run -d chrome --web-hostname localhost --web-port 5000
// 2. Copy link generated in debugging Chrome into regular Chrome
// 3. Use app on regular Chrome normally

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Pink color
        scaffoldBackgroundColor: const Color(0xffF4E1E6), // Light pink color
      ),
      home: SignIn(),
    );
  }
}