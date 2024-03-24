import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.app/step_counter');

void startStepCounterService() async {
  try {
    await platform.invokeMethod('startStepCounterService');
  } on PlatformException catch (e) {
    rethrow;
  }
}