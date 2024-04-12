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
  int _timeRemaining = 15 * 60; // 15 minutes in seconds
  int _stepCount = 0;
  int _initialStepCount = 0;
  double _speed = 0.0;
  bool _challengeStarted = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
  }

  void _startChallenge() {
    _startTime = DateTime.now();
    setState(() {
      _challengeStarted = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining == 0) {
        _endChallenge();
      } else {
        setState(() {
          _timeRemaining--;
        });
      }
    });

    final stepCounter =
        Provider.of<StepCounterProvider>(context, listen: false);
    _initialStepCount = stepCounter.stepCount; // Save the initial step count

    int previousStepCount = _initialStepCount;
    DateTime previousTime = DateTime.now();
    stepCounter.stepCountStream.listen((stepCount) {
      final challengeStepCount = stepCount - _initialStepCount;
      setState(() {
        _stepCount = challengeStepCount;
      });

      final currentTime = DateTime.now();
      final timeInterval = currentTime.difference(previousTime).inSeconds;
      if (timeInterval > 0) {
        final currentSpeed =
            (challengeStepCount - previousStepCount) / timeInterval;
        setState(() {
         // _stepCount = challengeStepCount;
          _speed = currentSpeed;
        });
      }
      previousStepCount = challengeStepCount;
      previousTime = currentTime;
    });
  }

  void _endChallenge() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Challenge Completed!'),
        content: Text('Congratulations! You completed the challenge.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_challengeStarted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text(
              'The challenge will reset if you leave. Are you sure you want to stop the challenge?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _timer?.cancel();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_challengeStarted) {
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
            const SizedBox(width: 15), // Add some space between the title and the icon
            const Text("Fast 15 min",
                style: TextStyle(
                fontSize: 20.0, // Adjust the font size as needed
                fontFamily: 'Roboto', // Change to your preferred font
                fontWeight: FontWeight.bold, // Make the text bold
              )
            ),
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
                  'Speed: $_speed steps per second',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Steps: $_stepCount',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Start', style: TextStyle(fontSize: 18)),
                  onPressed: _challengeStarted ? null : _startChallenge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
