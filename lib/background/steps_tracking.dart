import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stepit/features/globals.dart';


class StepsTracker {
  // late Pedometer _pedometer;
  static late Stream<StepCount> stepCountStream;
  static int steps = 0;
  static bool started = false;

  static void startStepsTracking() {
    // Initialize Firebase

    initPlatformState();
    _requestPermission();
    
    Firebase.initializeApp();

    // Register the callback dispatcher
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    // Start the WorkManager
    Workmanager().registerPeriodicTask(
      "1",
      "stepCountTask",
      frequency: const Duration(minutes: trackingFreq),
    );
    
  }

  static void _requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // You can start listening to the pedometer here.
    }
  }

  static Future<void> initPlatformState() async {
    stepCountStream = Pedometer.stepCountStream;
    
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // Initialize Firebase
      await Firebase.initializeApp();

      try {
        // Get steps
        steps = await getSteps();
      } catch(e) {
        steps = -1;
      }

      // Save steps to Firebase
      await saveStepsToFirebase(steps);

      return Future.value(true);
    });
  }

  static Future<int> getSteps() async {
    StepCount stepCount = await stepCountStream.first;
    return stepCount.steps;
  }

  static Future<void> saveStepsToFirebase(int steps) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // add the steps to the user's daily steps with the current timestamp as the key
    await FirebaseFirestore.instance.collection('steps_$date').doc(user?.uniqueNumber.toString()).set({
      DateFormat('HH:mm:ss').format(DateTime.now()): steps,
    });

  }
}