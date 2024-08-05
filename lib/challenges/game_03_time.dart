import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/features/step_count.dart';

class Game_03_time extends StatefulWidget {
  final String gameID;
  final int userID;

  Game_03_time({required this.gameID, required this.userID});

  @override
  _Game_03_time createState() => _Game_03_time();
}

class _Game_03_time extends State<Game_03_time> {
  Timer? _timer;
  int _timeRemaining = 60 * 60; // 15 minutes in seconds
  int _stepCount = 0;
  bool challengeStarted = false;
  DateTime previousTime = DateTime.now();
  int previousStepCount = 0; // Move this variable to the class level
  bool challendgeEnded = false;
  DateTime? _challengeStartTime;
  DateTime? _challengeEndTime;

  void startNewChallenge() {
    // Save start time to Firestore
    _challengeStartTime = DateTime.now();
    CollectionReference userGames = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID.toString().padLeft(6, '0'))
        .collection('userGames');
    userGames.doc(widget.gameID).update({
      'Start Time': _challengeStartTime,
    });
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

    Future.delayed(Duration.zero, () {
      if (challengeStarted) {
        final provider =
            Provider.of<StepCounterProvider>(context, listen: false);
        provider.stepCountStream.listen((stepCount) {
          challengeStepCount = stepCount - previousStepCount;
          setState(() {
            _stepCount = challengeStepCount;
          });
          if (challengeStepCount >= 2000) {
            _endChallenge();
          }
        });
      } else {
        previousStepCount =
            challengeStepCount; // Reset the previous step count when the challenge is not started
      }
    });
  }

  void _endChallenge() {
    _timer?.cancel();

    String message;
    if (_stepCount >= 2000) {
      CollectionReference userGames = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID.toString().padLeft(6, '0'))
          .collection('userGames');
      _challengeEndTime = DateTime.now();
      userGames.doc(widget.gameID).update({
        'Completed': true,
        'End Time': _challengeEndTime,
        'Steps Taken during Challenge': _stepCount,
      });
      message = 'Congratulations! You have completed the challenge.';
    } else {
      message = 'You have not completed the challenge. Try again next time.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text(message),
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
    final pipModeNotifier = Provider.of<PipModeNotifier>(context);

    if (pipModeNotifier.inPipMode) {
      return pipModeNotifier.setPipModeImg();
    }
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
                Game.getGameIcon(
                    "2000 in an hour"), // Replace with your image path
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
              ),
              const SizedBox(
                  width: 15), // Add some space between the title and the icon
              const Text("2000 in an hour",
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
                  'Your challenge is to walk at least 2000 steps in an hour',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height:
                        40), // Add some space between the description and the time remaining
                Text(
                  'Time remaining: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
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
