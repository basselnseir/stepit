import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepCounterProvider with ChangeNotifier {
  int _stepCount = 0;
  int get stepCount => _stepCount;
  DateTime _lastStepDate = DateTime.now();

  String? _error;
  String? get error => _error;

  final _stepCountController = StreamController<int>.broadcast();

  Stream<int> get stepCountStream => _stepCountController.stream;

  StepCounterProvider() {
    Pedometer.stepCountStream.listen(
      (StepCount event) {
        print('Received step count event: $event');  // Add this line
        _stepCount = event.steps;
        _stepCountController.add(_stepCount);
        notifyListeners();
      },
      onError: (error) {
        print('Error listening to step count stream: $error');  // Add this line
        _error = 'Failed to access step counter: $error';
        notifyListeners();
      },
    );
  }

   void updateStepCount(int newStepCount) {
    _stepCount = newStepCount;
    _stepCountController.add(_stepCount);
    notifyListeners();
  }

  @override
  void dispose() {
    _stepCountController.close();
    super.dispose();
  }
}

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }