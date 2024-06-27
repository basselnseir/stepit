import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';


class ChallengePageTemp extends StatefulWidget {
  @override
  _ChallengePageTempState createState() => _ChallengePageTempState();
}

class _ChallengePageTempState extends State<ChallengePageTemp> {
  bool hasShownCompletionDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Challenge'),
      ),
      body: Consumer<StepCounterProvider>(
        builder: (context, stepCounter, child) {
          final steps = stepCounter.stepCount; // Assuming stepCount is an int representing the current steps.
          _checkAndShowCompletionDialog(steps, context);

          return Center(
            child: Text(
              'Steps: $steps',
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        },
      ),
    );
  }

  void _checkAndShowCompletionDialog(int steps, BuildContext context) {
    if (steps >= 12580 && !hasShownCompletionDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context);
        hasShownCompletionDialog = true;
      });
    }
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Reset the flag when the widget is disposed to allow the dialog to be shown again if the page is revisited.
    hasShownCompletionDialog = false;
  }
}