import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';

class Game_02_speed extends StatefulWidget {
  @override
  _Game_02_speed createState() => _Game_02_speed();
}

class _Game_02_speed extends State<Game_02_speed> {
  Timer? _timer;
  int _timeRemaining = 15 * 60; // 15 minutes in seconds
  int _stepCount = 0;
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
    print('memormeret');
    stepCounter.stepCountStream.listen((stepCount) {
      print('New step count: $stepCount');
      final timeElapsed = DateTime.now().difference(_startTime!).inSeconds;
      setState(() {
        _stepCount = stepCount;
        if (timeElapsed > 0) {
          _speed = _stepCount / timeElapsed;
        }
      });
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
                  title: Text('Warning'),
                  content: Text(
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
          title: Text('Speed Challenge'),
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
