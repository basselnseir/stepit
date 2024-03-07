import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stepit/classes/objects.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//User? user;

const int trackingFreq = 15; // in minutes, needs to be larger than 15

void logEvent_(String eventName) {
  analytics.logEvent(
    name: eventName,
    parameters: <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}