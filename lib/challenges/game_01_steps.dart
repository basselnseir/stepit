/* 
for this game, when the user enters the game for the first time, we should read the pedometer steps 
and update them to be the user steps for the day, in other words it should not start from 0 if the user already
walked for the day. And start counting from the current steps.
and the steps should always be updated to the database.
if the user steps are more than the game goal steps, the user wins the game.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';

class Game_01_steps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Steps: ${stepCounter.stepCount}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (stepCounter.stepCount >= 7000)
                    Text(
                      'Congratulations! You completed the challenge!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                ],
              ),
            );
          }
        },
      );
  }
}