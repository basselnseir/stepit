import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';


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
  int _initialSteps = 0;
  bool started = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _requestPermission();
  }

  void _requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // You can start listening to the pedometer here.
    }
  }

  Future<void> initPlatformState() async {
    _pedometer = Pedometer();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onData).onError(onError);

    // Get the initial step count
    _stepCountStream.first.then((StepCount event) {
      _initialSteps = event.steps;
      started = true;
    });
  }

  void onData(StepCount event) {
    setState(() {
      if (started){
        _steps = (event.steps - _initialSteps).toString();
      }
    });
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
    if (error is PlatformException && error.code == '1') {
      setState(() {
        _steps = 'Step counter not available on this device';
      });
    }
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