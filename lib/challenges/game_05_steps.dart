import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/features/step_count.dart';

class Game_05_steps extends StatefulWidget {
  final String gameID;
  final int userID;

  Game_05_steps({required this.gameID, required this.userID});

  @override
  _Game_05_steps createState() => _Game_05_steps();
}

class _Game_05_steps extends State<Game_05_steps> {
  // 15 minutes in seconds
  int _stepCount = 0;
  DateTime? _challengeStartTime;
  DateTime? _challengeEndTime;

  void startChallenge() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<StepCounterProvider>(context, listen: false);
      provider.stepCountStream.listen((stepCount) {
        setState(() {
          _stepCount = stepCount;
        });
        if (_stepCount >= 7500) {
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
          _endChallenge();
        }
      });
    });
  }

  void _endChallenge() {
    String message;
    message = 'Congratulations! You have completed the challenge.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
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
    startChallenge();
  }

  @override
  Widget build(BuildContext context) {
    final pipModeNotifier = Provider.of<PipModeNotifier>(context);

    if (pipModeNotifier.inPipMode) {
      return pipModeNotifier.setPipModeImg();
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              Game.getGameIcon("7500 Steps"), // Replace with your image path
              width: 30, // Adjust the width as needed
              height: 30, // Adjust the height as needed
            ),
            const SizedBox(
                width: 15), // Add some space between the title and the icon
            const Text("7500 Steps",
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
                'Your challenge is to walk for 7500 steps',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height:
                      40), // Add some space between the description and the time remaining
              Consumer<StepCounterProvider>(
                builder: (context, provider, child) {
                  return Text(
                    'Steps: ${provider.stepCount}',
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
