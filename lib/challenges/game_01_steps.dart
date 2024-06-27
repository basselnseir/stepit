/* 
for this game, when the user enters the game for the first time, we should read the pedometer steps 
and update them to be the user steps for the day, in other words it should not start from 0 if the user already
walked for the day. And start counting from the current steps.
and the steps should always be updated to the database.
if the user steps are more than the game goal steps, the user wins the game.
*/

import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/features/step_count.dart';

class Game_01_steps extends StatelessWidget {
  //steps = [7500, 10000, 13000];

final VoidCallback onChallengeCompleted;

int stepsTaken = 0;

Game_01_steps({Key? key, required this.onChallengeCompleted}) : super(key: key);

void showCompletionDialog(BuildContext context) {
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

    if(stepsTaken >= 7500){
      onChallengeCompleted();
      showCompletionDialog(context);
    }

    if (pipModeNotifier.inPipMode){
      return pipModeNotifier.setPipModeImg();
    }
    return  Consumer<StepCounterProvider>(
        builder: (context, stepCounter, child) {
          if (stepCounter.error != null) {
            
            return Center(
              child: Text(
                stepCounter.error!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          } else {
            stepsTaken = stepCounter.stepCount;
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Steps: ${stepCounter.stepCount}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
      
                  if (stepCounter.stepCount >= 7500) 
                    //onChallengeCompleted();
                    ElevatedButton(
                      onPressed: () {
                       // _showCompletionDialog(context);
                       onChallengeCompleted();
                      },
                      child: Text('Complete Challenge'),)
                   
                ],
              ),
              
            );
          }
        },
      );
  }
}