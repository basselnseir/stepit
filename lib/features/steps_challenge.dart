import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'dart:async';



class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  // late Pedometer _pedometer;
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  int _initialSteps = 0;
  bool started = false;
  int goal = 100;
  bool _buttonPressed = false;
  StreamSubscription<StepCount>? _stepCountSubscription;
  Timer? _timer;
  Duration _duration = const Duration();

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
    // _pedometer = Pedometer();
    _stepCountStream = Pedometer.stepCountStream;
    // _stepCountStream.listen(onData).onError(onError);

    // // Get the initial step count
    // _stepCountStream.first.then((StepCount event) {
    //   _initialSteps = event.steps;
    //   started = true;
    // });
  }

  void onData(StepCount event) {
    logEvent_('user steps increased in 100_steps_challenge');
    setState(() {
      if (started){
        _steps = (event.steps - _initialSteps).toString();
      }
      if (int.parse(_steps) >= goal){
        _steps = 'You have reached your goal of $goal steps!';
        logEvent_('100_steps_challenge completed');
      }
    });
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
    if (error is PlatformException && error.code == '1') {
      setState(() {
        _steps = 'Step counter not available on this device.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Steps count: $_steps',
                      style: const TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          if (_buttonPressed){
                            bool? shouldReset = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Reset steps challenge'),
                                  content: const Text('Are you sure you want to reset the steps challenge?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldReset == true) {
                              logEvent_('100_steps_challenge reset');
                              setState(() {
                                _buttonPressed = false;
                                started = false;
                                _steps = '0';
                                _stepCountSubscription?.cancel();
                                _timer?.cancel();
                                _duration = const Duration();
                              });
                            }
                          }
                          else{
                            logEvent_('100_steps_challenge started');
                            _buttonPressed = true;
                            _stepCountSubscription = _stepCountStream.listen(onData);
                            _stepCountSubscription?.onError(onError);

                            // Get the initial step count
                            _stepCountStream.first.then((StepCount event) {
                              _initialSteps = event.steps;
                              started = true;
                            });

                            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                              setState(() {
                                _duration += const Duration(seconds: 1);
                              });
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _buttonPressed ? Colors.red : Colors.green, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Text(_buttonPressed ? 'RESET' : 'START!'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), // Adjust this value to move the text down
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.access_time, size: 20), // This is the clock logo
                          const SizedBox(width: 10), // This adds some space between the logo and the text
                          Text(
                            'Timer: ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 20), // Adjust the font size here
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ),
      );
    }
}