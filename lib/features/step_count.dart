import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterProvider with ChangeNotifier {
  int stepCount = 0;
  int _previousStepCount = 0;
  int yesterdayLastStepCount = 0;
  String _lastUpdateDate = "null";
  String? _error;

  String? get error => _error;
  final _stepCountController = StreamController<int>.broadcast();
  Stream<int> get stepCountStream => _stepCountController.stream;

  StepCounterProvider() {

    Pedometer.stepCountStream.listen(
      (StepCount event) async {
       // await _saveNewDate("2024-08-05");
        await _loadSavedDate();
        String today = DateTime.now().toIso8601String().split('T')[0];
        if (today != _lastUpdateDate) {
          await _loadPreviousSteps(); // Save the previous step count
          _lastUpdateDate = today; // Update last update date to now
          await _saveNewDate(_lastUpdateDate);
          await _saveYesterdaySteps(_previousStepCount); // Save the updated data
        }
        else {
          await _savePreviousSteps(event.steps); // Save the last step count of yesterday
        }

        await _loadYesterdaySteps();
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

  Future<void> _loadSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString('date');
    _lastUpdateDate = storedDate ?? "null";
    
  }

  Future<void> _loadPreviousSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _previousStepCount = prefs.getInt('previousStepCount') ?? 0;
  }

  Future<void> _loadYesterdaySteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    yesterdayLastStepCount = prefs.getInt('yesterdayStepCount') ?? 0;
  }

  Future<void> _saveNewDate(String today) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', today);
  }

    Future<void> _saveYesterdaySteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('yesterdayStepCount', steps);
  }

      Future<void> _savePreviousSteps(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('previousStepCount', steps);
  }


  void updateStepCount(int newStepCount) {
    stepCount = newStepCount;
    _stepCountController.add(stepCount);
    notifyListeners();
  }

    // Singleton instance
  static final StepCounterProvider _instance = StepCounterProvider._internal();

  // Factory constructor to return the singleton instance
  factory StepCounterProvider._() {
    // Private constructor for singleton pattern
    return _instance;
  }

  // Private constructor for singleton pattern
  StepCounterProvider._internal();
}