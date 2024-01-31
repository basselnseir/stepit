import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Step Counter'),
//         ),
//         body: StepCounter(),
//       ),
//     );
//   }
// }

class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);

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
      return Scaffold(
          appBar: AppBar(
          title: const Text('500 STEPS CHALLENGE'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    const Text(
                      'Challenge: Walk 500 steps',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Steps count: $_steps',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ]
            ),
          ),
        ),
      );
    }
}