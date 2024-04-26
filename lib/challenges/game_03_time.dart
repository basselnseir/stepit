import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';
import 'dart:async';

class ChallengeState extends ChangeNotifier {
  Timer? _timer;
  int _startSteps = 0;
  int _remainingSeconds = 3600;

  void startChallenge(BuildContext context) {
    _timer?.cancel(); // Cancel any existing timer
    _startSteps = Provider.of<StepCounterProvider>(context, listen: false).stepCount;
    _remainingSeconds = 3600;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  void dispose() {
    _timer?.cancel();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('One Hour Challenge'),
      ),
      backgroundColor: Colors.white,
      body: Consumer2<StepCounterProvider, ChallengeState>(
        builder: (context, stepCounter, challengeState, child) {
          if (challengeState._timer != null && challengeState._startSteps == 0) {
            challengeState._startSteps = stepCounter.stepCount;
          }

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
        'Steps: ${stepCounter.stepCount - challengeState._startSteps}',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      // Show the success message if the challenge is completed
      if (challengeState._timer == null && stepCounter.stepCount - challengeState._startSteps >= 3000)
        Text(
          'Congratulations! You completed the challenge!',
          style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }
}