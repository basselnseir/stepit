import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';
import 'dart:async';

class ChallengeState extends ChangeNotifier {
  Timer? _timer;
  int _startSteps = 0;
  int _challengeSteps = 0; // New variable to keep track of steps during the challenge
  int _remainingSeconds = 3600;
  bool _challengeCompleted = false; // Add this line

void startChallenge(BuildContext context) {
  resetChallenge();
  _startSteps = Provider.of<StepCounterProvider>(context, listen: false).stepCount;
  _challengeSteps = 0; // Reset the challenge steps
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    _remainingSeconds--;
    if (_remainingSeconds <= 0 || _challengeSteps >= 3000) {
      _timer?.cancel();
      _timer = null;
      if (_challengeSteps >= 3000) {
        _challengeCompleted = true; // Mark the challenge as completed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('You completed the challenge!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  resetChallenge();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        resetChallenge();
      }
    }
    notifyListeners();
  });
}

  void updateChallengeSteps(int currentSteps) {
    _challengeSteps = currentSteps - _startSteps;
    notifyListeners();
  }

  void resetChallenge() {
    _timer?.cancel();
    _timer = null;
    _startSteps = 0;
    _remainingSeconds = 3600;
  }

  void dispose() {
    resetChallenge();
    super.dispose();
  }
}

class Game_03_time extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Game_03_timeBody();
  }
}

class _Game_03_timeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChallengeState challengeState = Provider.of<ChallengeState>(context);
    return WillPopScope(
      onWillPop: () async {
        if (challengeState._timer != null) {
          // Show a dialog asking the user if they are sure they want to leave
          bool leave = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('If you leave, the challenge will be reset.'),
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
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ) ?? false;

          if (leave) {
            // Reset the challenge
            challengeState._timer?.cancel();
            challengeState._timer = null;
            challengeState._startSteps = 0;
            challengeState._remainingSeconds = 3600;
            challengeState.notifyListeners();
          }

          return leave;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('One Hour Challenge'),
        ),
        backgroundColor: Colors.white,
        body: Consumer2<StepCounterProvider, ChallengeState>(
          builder: (context, stepCounter, challengeState, child) {
            if (challengeState._timer != null && challengeState._startSteps == 0) {
              challengeState._startSteps = stepCounter.stepCount;
            }
          challengeState.updateChallengeSteps(stepCounter.stepCount);

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
                    // Always show the challenge description at the top
                      Text(
                        'Reach 3000 steps in one hour!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    // Then show the timer if it's running
                    if (challengeState._timer != null)
                      Text(
                        'Time remaining: ${challengeState._remainingSeconds ~/ 60}:${challengeState._remainingSeconds % 60}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    // Show the current step count
                    Text(
                      'Steps: ${challengeState._timer == null ? 0 : stepCounter.stepCount - challengeState._startSteps}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    // Show the timeout message if the challenge is failed
                    if (challengeState._timer == null && challengeState._remainingSeconds == 0 && stepCounter.stepCount - challengeState._startSteps < 3000)
                      Text(
                        'Timeout! Try again!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    // Show the start button if the timer is not running
                    if (challengeState._timer == null)
                      ElevatedButton(
                        onPressed: () => challengeState.startChallenge(context),
                        child: Text('Start Challenge'),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}