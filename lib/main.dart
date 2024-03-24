import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/background/steps_tracking_wm.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/classes/database.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/pages/agreement.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floating/floating.dart';
import 'dart:math';

//final userProviderKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  //bool isFirstTime = true;

  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => GameProvider()),
      ChangeNotifierProvider(create: (context) => PipModeNotifier()),
    ],
    child: MyApp(isFirstTime: isFirstTime),
  ));
}

class MyApp extends StatefulWidget {
  final bool isFirstTime;
  const MyApp({superKey, Key? key, required this.isFirstTime});
  @override
  MyAppState createState() => MyAppState(isFirstTime: isFirstTime);
}

class MyAppState extends State<MyApp> {

  static AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  final bool isFirstTime;
  final floating = Floating();
  MyAppState({Key? key, required this.isFirstTime});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> enablePip(BuildContext context) async {
    const rational = Rational.landscape();
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final status = await floating.enable(
      aspectRatio: rational,
      sourceRectHint: Rectangle<int>(
        0,
        (screenSize.height ~/ 2) - (height ~/ 2),
        screenSize.width.toInt(),
        height,
      ),
    );
    debugPrint('PiP enabled? $status');
  }

  static bool isAppInForeground() {
    return _appLifecycleState == AppLifecycleState.resumed;
  }

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
      home: isFirstTime ? AgreementPage() : HomePage(),
      // TODO: Add theme:, Learn themes
    );
  }
}