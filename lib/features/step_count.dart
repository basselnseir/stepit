import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterProvider with ChangeNotifier {
  int stepCount = 0;
  int _previousStepCount = 0;
  int yesterdayLastStepCount = 0;
  String _lastUpdateDate = DateTime.now().toIso8601String().split('T')[0];
  String? _error;

  String? get error => _error;
  final _stepCountController = StreamController<int>.broadcast();
  Stream<int> get stepCountStream => _stepCountController.stream;

  StepCounterProvider() {
    _loadSavedData();
    Pedometer.stepCountStream.listen(
      (StepCount event) {
        String today = DateTime.now().toIso8601String().split('T')[0];

        if (today != _lastUpdateDate) {
          yesterdayLastStepCount = _previousStepCount; // Save the previous step count
          _lastUpdateDate = today; // Update last update date to now
          _saveNewDate(_lastUpdateDate); // Save the updated data
        }
        else {
          _saveYesterdaySteps(event.steps); // Save the last step count of yesterday
        }

        print('Received step count event: $event');
        stepCount = event.steps - yesterdayLastStepCount; // Calculate steps for the new day
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _previousStepCount = prefs.getInt('previousStepCount') ?? 0;
    String? storedDate = prefs.getString('date');
    _lastUpdateDate = storedDate ?? DateTime.now().toIso8601String().split('T')[0];
    
  }

  Future<void> _saveNewDate(String today) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setInt('previousStepCount', _previousStepCount);
    await prefs.setString('date', today);
  }

    Future<void> _saveYesterdaySteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('previousStepCount', steps);
  }

  void updateStepCount(int newStepCount) {
    stepCount = newStepCount;
    _stepCountController.add(stepCount);
    notifyListeners();
  }
}