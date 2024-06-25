import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/step_count.dart';

class Game_02_speed extends StatefulWidget {
  @override
  _Game_02_speed createState() => _Game_02_speed();
}

class _Game_02_speed extends State<Game_02_speed> {
  Timer? _timer;
  Timer? _everyThreeSecondsTimer;
  int _timeRemaining = 15 * 60 ; // 15 minutes in seconds
  int _stepCount = 0;
  double _speed = 0.0;
  bool challengeStarted = false;
  DateTime previousTime = DateTime.now();
  int previousStepCount = 0; // Move this variable to the class level
  double max_speed = 0;
  bool challendgeEnded = false;

  void startNewChallenge() {
    final provider = Provider.of<StepCounterProvider>(context, listen: false);
    provider.stepCountStream.first.then((currentStepCount) {
      setState(() {
        challengeStarted = true;
        previousStepCount =
            currentStepCount; // Capture the current step count as baseline
      });
    });
    startChallenge();
  }


  void startChallengeTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining == 0) {
        _endChallenge();
      } else {
        setState(() {
          _timeRemaining--;
        });
      }
    });
  }


  void startChallenge() {
    startChallengeTimer();
    int previousCurrSteps = 0;
    int challengeStepCount = 0;
    
    _everyThreeSecondsTimer = Timer.periodic(Duration(seconds: 3), (timer) {
    if (challengeStarted == previousCurrSteps) {
      _speed = 0;
    } else {
      double distance = (challengeStepCount - previousCurrSteps) * 0.762; // Assuming each step is 0.762 meters
      _speed = distance / 3;
    }

    if (_speed > max_speed) {
      max_speed = _speed;
    }

    previousCurrSteps = challengeStepCount;
    });

    Future.delayed(Duration.zero, () {
      if (challengeStarted) {
        final provider =
            Provider.of<StepCounterProvider>(context, listen: false);
        provider.stepCountStream.listen((stepCount) {
          challengeStepCount = stepCount - previousStepCount;
          setState(() {
            _stepCount = challengeStepCount;
          });
        });
      } else {
        previousStepCount =
            challengeStepCount; // Reset the previous step count when the challenge is not started
      }
    });
  }

  void _endChallenge() {
    _timer?.cancel();
    _everyThreeSecondsTimer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text('Congratulations! You completed the challenge. \n your maximum speed was $max_speed meters per second.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              challendgeEnded = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (challengeStarted && !challendgeEnded) {
          return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Warning'),
                  content: const Text(
                      'The challenge will reset if you leave. Are you sure you want to stop the challenge?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        _timer?.cancel();
                        _everyThreeSecondsTimer?.cancel();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ) ??
              false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                Game.getGameIcon("Fast 15 min"), // Replace with your image path
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
              ),
              const SizedBox(
                  width: 15), // Add some space between the title and the icon
              const Text("Fast 15 min",
                  style: TextStyle(
                    fontSize: 20.0, // Adjust the font size as needed
                    fontFamily: 'Roboto', // Change to your preferred font
                    fontWeight: FontWeight.bold, // Make the text bold
                  )),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Time remaining: ${_timeRemaining ~/ 60} minutes ${_timeRemaining % 60} seconds',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Speed: $_speed meters per second',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Steps: $_stepCount',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: challengeStarted
                      ? null
                      : () {
                          setState(() {
                            challengeStarted = true;
                          });
                          startNewChallenge();
                        },
                  child: Text('Start Challenge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: challengeStarted ? Colors.grey : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
