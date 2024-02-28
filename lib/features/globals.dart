import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

const int trackingFreq = 5; // in minutes

void logEvent_(String eventName) {
  analytics.logEvent(
    name: eventName,
    parameters: <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}