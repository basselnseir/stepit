import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/challenges/tmp_game_01.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';

class ChallengePage extends StatefulWidget {
  final Game game;

  ChallengePage({required this.game});

  @override
  _ChallengePageState createState() => _ChallengePageState();
}


class _ChallengePageState extends State<ChallengePage> {

bool checkChallengeCompleted = false;

void updateParameter() {
  setState(() {
    // Update the parameter here
    checkChallengeCompleted = true;
  });
}

void _showCompletionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have completed the challenge.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final pipModeNotifier = Provider.of<PipModeNotifier>(context);

    if (pipModeNotifier.inPipMode){
      return pipModeNotifier.setPipModeImg();
    }

    if (checkChallengeCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCompletionDialog(context);
    });
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
            const SizedBox(width: 15), // Add some space between the title and the icon
            const Text("7500 Steps",
                style: TextStyle(
                fontSize: 20.0, // Adjust the font size as needed
                fontFamily: 'Roboto', // Change to your preferred font
                fontWeight: FontWeight.bold, // Make the text bold
              )
            ),
          ],
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your challenge is to walk at least 7500 steps today",
                  style: TextStyle(fontSize: 20),
                ),
                
               // Game_01_steps(onChallengeCompleted: updateParameter),
                //ChallengePageTemp(),
               
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}
