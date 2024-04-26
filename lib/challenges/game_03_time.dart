import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';
import 'dart:async';

class Game_01_time extends StatefulWidget {
  @override
  _Game_01_timeState createState() => _Game_01_timeState();
}

class _Game_01_timeState extends State<Game_01_time> {
  Timer? _timer;
  int _startSteps = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(hours: 1), () {
      setState(() {
        _timer = null;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StepCounterProvider>(
      builder: (context, stepCounter, child) {
        if (_timer != null && _startSteps == 0) {
          _startSteps = stepCounter.stepCount;
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
                Text(
                  'Steps: ${stepCounter.stepCount - _startSteps}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (_timer == null && stepCounter.stepCount - _startSteps >= 3000)
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