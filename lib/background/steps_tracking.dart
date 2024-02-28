import 'package:pedometer/pedometer.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stepit/features/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';


void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Get steps
    int steps = await getSteps();

    // Save steps to Firebase
    await saveStepsToFirebase(steps);

    return Future.value(true);
  });
}

Future<int> getSteps() async {
  Stream<StepCount> stepCountStream = Pedometer.stepCountStream;
  StepCount stepCount = await stepCountStream.first;
  return stepCount.steps;
}

// Future<DocumentReference> saveStepsToFirebase(int steps) async {
//   CollectionReference stepsCollection = FirebaseFirestore.instance.collection('steps');
//   return stepsCollection.add({'timestamp': DateTime.now(), 'steps': steps});
// }

Future<void> saveStepsToFirebase(int steps) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int uniqueNumber = prefs.getInt('uniqueNumber') ?? 0;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  

  // Use the date as part of the collection name
  await FirebaseFirestore.instance.collection('steps_$date').add({
    'steps': steps,
    'timestamp': DateTime.now(),
  });

  // Save the steps to the user's daily steps list
  DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uniqueNumber.toString());
  DocumentSnapshot userSnapshot = await userDoc.get();
  List<dynamic> dailyStepsList = userSnapshot.data()!['dailyStepsList'];

}

void startStepsTracking() {
  // Initialize Firebase
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