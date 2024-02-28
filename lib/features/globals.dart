import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stepit/classes/objects.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

late User user;

const int trackingFreq = 1; // in minutes

void logEvent_(String eventName) {
  analytics.logEvent(
    name: eventName,
    parameters: <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}