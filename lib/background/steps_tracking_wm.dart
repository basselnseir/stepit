import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/database.dart';
import 'package:stepit/features/step_count.dart';
import 'package:stepit/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stepit/features/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';


final class MapEntryLinkedList extends LinkedListEntry<MapEntryLinkedList> {
  final Map<String, dynamic> map;

  MapEntryLinkedList(this.map);

  @override
  String toString() {
    return map.toString();
  }
}




class StepsTracker {
  // late Pedometer _pedometer;
  // static Stream<StepCount> stepCountStream = Pedometer.stepCountStream;
  // static int steps = 0;
  // static late int initialSteps;
  static Workmanager wm = Workmanager();
  // static bool firstTime = true;
  static LinkedList<MapEntryLinkedList> dataList = LinkedList<MapEntryLinkedList>();

}

void startStepsTracking () async {
  
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  bool permissionsDenied = true;
  while (permissionsDenied) {
    bool stepsPermission = await Permission.activityRecognition.request().isGranted;
    bool locationPermission = await Permission.location.request().isGranted;
    if (stepsPermission && locationPermission) {
      permissionsDenied = false;
    }
  }

  // Save steps the first time
   await setAndSaveSteps();

  // Register the callback dispatcher
  StepsTracker.wm.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Start the WorkManager
  // Save steps each 15 mins
  StepsTracker.wm.registerPeriodicTask(
    "1",
    "stepCountTask",
    frequency: const Duration(minutes: trackingFreq),
  );
  
}


// Future<void> initPlatformState() async {
//   StepsTracker.stepCountStream = Pedometer.stepCountStream;
  
// }

void callbackDispatcher() {
  StepsTracker.wm.executeTask((task, inputData) async {
    await setAndSaveSteps();
    return Future.value(true);
  });
}

Future<void> setAndSaveSteps () async {
  // // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  int steps;
  
  try {
    // Get steps
    steps = await getSteps();
  } catch(e) {
    print('!!!!! Error caught in setAndSaveSteps: $e !!!!!');
    steps = -1;
  }

  // Save steps to Firebase

  // await saveStepsToFirebase(StepsTracker.steps);

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String time = DateFormat('HH:mm:ss').format(DateTime.now());
  // int un = await DataBase.getUserId();

  // Get the location
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // Create a GeoPoint with the location
  GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);

  int un = await DataBase.getUserId();
  FirebaseFirestore.instance.collection('users').doc(un.toString().padLeft(6, '0')).set({
    'steps and location': {
      '$date $time': {
        'steps': steps,
        'location': geoPoint,
      },
    }
  }, SetOptions(merge: true));

  // if (MyAppState.isAppInForeground()) {
  //     // Add data to Firestore
  //     int un = await DataBase.getUserId();
  //     FirebaseFirestore.instance.collection('users').doc(un.toString().padLeft(6, '0')).set({
  //       'steps and location': {
  //         '$date $time': {
  //           'steps': steps,
  //           'location': geoPoint,
  //         },
  //       }
  //     }, SetOptions(merge: true));
  //     print("!!!!! In foreground -> stored in firebase !!!!!");
  //   } else {
  //     // Add data to dataList
  //     StepsTracker.dataList.add(MapEntryLinkedList({
  //       'steps and location': {
  //         '$date $time': {
  //           'steps': steps,
  //           'location': geoPoint,
  //         },
  //       }
  //     }));
  //     print("!!!!! In background -> stored in list !!!!!");
  //   }

  // StepsTracker.dataList.add(MapEntryLinkedList({
  //   'steps and location': {
  //     '$date $time': {
  //       'steps': steps,
  //       'location': geoPoint,
  //     },
  //   }
  // }));

  // print(StepsTracker.dataList);

}

Future<int> getSteps() async {
   int steps = 0;
  // // StepCount stepCount = await Pedometer.stepCountStream.first;

  // await Pedometer.stepCountStream.first.then((StepCount event) { steps = event.steps;});
  // return steps;
  StepCounterProvider stepCounterProvider = StepCounterProvider();
   //int steps = await stepCounterProvider.stepCountStream.first;
  await stepCounterProvider.stepCountStream.first.then((stepCount) {
    print('Current step count: $stepCount');
    steps = stepCount;
  });
  return steps;
}

// Future<void> saveStepsToFirebase(int steps) async {
//   String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String time = DateFormat('HH:mm:ss').format(DateTime.now());
//   int un = await DataBase.getUserId();

//   // Get the location
//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//   // Create a GeoPoint with the location
//   GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);


//   // add the steps to the user's daily steps with the current timestamp as the key
//   // print('!!!!! unique number: $un, date&time: $date $time, steps: $steps, location: $geoPoint !!!!!');
  
//   // FirebaseFirestore.instance.collection('users').doc(un.toString().padLeft(6, '0')).set({
//   //   'steps and location': {
//   //     '$date $time': {
//   //       'steps': steps,
//   //       'location': geoPoint,
//   //     },
//   //   }
//   // }, SetOptions(merge: true));

// }
