import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterProvider with ChangeNotifier {
  int stepCount = 0;
  int _previousStepCount = 0;
  DateTime _lastUpdateDate = DateTime.now();
  String? _error;

  String? get error => _error;
  final _stepCountController = StreamController<int>.broadcast();
  Stream<int> get stepCountStream => _stepCountController.stream;

  StepCounterProvider() {
    _loadSavedData();
    Pedometer.stepCountStream.listen(
      (StepCount event) {
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime lastStepDate = DateTime(_lastUpdateDate.year, _lastUpdateDate.month, _lastUpdateDate.day);

        if (today.isAfter(lastStepDate)) {
          _previousStepCount = event.steps; // Save the previous step count
          _lastUpdateDate = now; // Update last update date to now
          _saveData(); // Save the updated data
        }

        print('Received step count event: $event');
        stepCount = event.steps - _previousStepCount; // Calculate steps for the new day
        _stepCountController.add(stepCount);
        notifyListeners();
      },
      onError: (error) {
        print('Error listening to step count stream: $error');
        _error = 'Failed to access step counter: $error';
        notifyListeners();
      },
    );
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _previousStepCount = prefs.getInt('previousStepCount') ?? 0;
    int? lastUpdateDateMillis = prefs.getInt('lastUpdateDate');
    if (lastUpdateDateMillis != null) {
      _lastUpdateDate = DateTime.fromMillisecondsSinceEpoch(lastUpdateDateMillis);
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('previousStepCount', _previousStepCount);
    await prefs.setInt('lastUpdateDate', _lastUpdateDate.millisecondsSinceEpoch);
  }

  void updateStepCount(int newStepCount) {
    stepCount = newStepCount;
    _stepCountController.add(stepCount);
    notifyListeners();
  }
}