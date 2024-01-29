import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Step Counter'),
        ),
        body: StepCounter(),
      ),
    );
  }
}

class StepCounter extends StatefulWidget {
  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late Pedometer _pedometer;
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _pedometer = Pedometer();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onData)
      ..onError(onError);
  }

  void onData(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Steps: $_steps',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}