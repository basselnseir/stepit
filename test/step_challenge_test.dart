import 'package:flutter/material.dart';
import 'package:stepit/pages/agreement.dart';
import 'package:stepit/features/steps_challenge.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stepit/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  MyApp({super.key, required this.isFirstTime});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          hintColor: Colors.cyan[600],
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 184, 239, 186), // Set your desired color here
              textStyle: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 255, 255, 255),
                
              ),
            ),
          ),          
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 184, 239, 186), // Set your desired color here
          ),
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    // textTheme: TextTheme(
    //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    // ),
  ),
      debugShowCheckedModeBanner: false,
      home: isFirstTime ? AgreementPage() : const StepCounter(),
    );
  }
}