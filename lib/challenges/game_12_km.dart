import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/features/step_count.dart';

class Game_12_km extends StatefulWidget {
  final String gameID;
  final int userID;

  Game_12_km({required this.gameID, required this.userID});

  // const Game_04_km({Key? key})
  //     : super(key: key);

  @override
  _Game_12_kmState createState() => _Game_12_kmState();
}

class _Game_12_kmState extends State<Game_12_km> {
  double distanceTraveled = 0;
  bool challengeStarted = false;
  int previousStepCount = 0;
  int initialStepCount = 0;
  int stepsTakenSinceChallengeStarted = 0;
  StreamSubscription<int>? stepCountSubscription;
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
        previousStepCount = currentStepCount;
        initialStepCount = currentStepCount;
        distanceTraveled = 0;
        stepsTakenSinceChallengeStarted = 0;
      });
    });

    subscribeToStepCountStream();
  }

  void subscribeToStepCountStream() {
    final provider = Provider.of<StepCounterProvider>(context, listen: false);
    stepCountSubscription?.cancel(); // Cancel existing subscription if any
    stepCountSubscription = provider.stepCountStream.listen((stepCount) {
      if (challengeStarted) {
        int stepCountDifference = stepCount - previousStepCount;
        setState(() {
          stepsTakenSinceChallengeStarted = stepCount - initialStepCount;
        });
        if (stepCountDifference >= 10) {
          setState(() {
            distanceTraveled += (stepCountDifference * 0.000762);
            previousStepCount = stepCount;
            //stepsTakenSinceChallengeStarted += stepCountDifference;
          });
          if (distanceTraveled >= 2) {
            challengeStarted = false;
            CollectionReference userGames = FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userID.toString().padLeft(6, '0'))
                .collection('userGames');
            _challengeEndTime = DateTime.now();
            userGames.doc(widget.gameID).update({
              'Completed': true,
              'End Time': _challengeEndTime,
              'Steps': stepsTakenSinceChallengeStarted,
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Congratulations!'),
                content: const Text('You have completed the 1 km challenge.'),
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
        }
      } else {
        previousStepCount = stepCount;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    subscribeToStepCountStream(); // Subscribe to the stream when the widget initializes
  }

  @override
  void dispose() {
    stepCountSubscription
        ?.cancel(); // Don't forget to cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pipModeNotifier = Provider.of<PipModeNotifier>(context);

    if (pipModeNotifier.inPipMode) {
      return pipModeNotifier.setPipModeImg();
    }
    return WillPopScope(
      onWillPop: () async {
        if (challengeStarted) {
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
                        distanceTraveled = 0;
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
                Game.getGameIcon("1 km"), // Replace with your image path
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
              ),
              const SizedBox(
                  width: 15), // Add some space between the title and the icon
              const Text("1 km",
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
                    "Your challenge is to walk for 1 kilometers in a row.",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Distance Traveled: ${distanceTraveled.toStringAsFixed(2)} km',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Steps Taken: $stepsTakenSinceChallengeStarted',
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
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
