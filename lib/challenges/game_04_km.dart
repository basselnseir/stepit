import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/step_count.dart';

class Game_04_km extends StatefulWidget {
  final String title;
  final String description;

  const Game_04_km({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  _Game_04_kmState createState() => _Game_04_kmState();
}

class _Game_04_kmState extends State<Game_04_km> {
  double distanceTraveled = 0;
  bool challengeStarted = false;
  int previousStepCount = 0; // Move this variable to the class level


void startNewChallenge() {
  final provider = Provider.of<StepCounterProvider>(context, listen: false);
  provider.stepCountStream.first.then((currentStepCount) {
    setState(() {
      challengeStarted = true;
      previousStepCount = currentStepCount; // Capture the current step count as baseline
      distanceTraveled = 0; // Reset distance traveled for the new challenge
    });
  });
}


  @override
  void initState() {
    super.initState();
    //setUpPedometer();
        Future.delayed(Duration.zero, () {
      final provider = Provider.of<StepCounterProvider>(context, listen: false);
      provider.stepCountStream.listen((stepCount) {
        if (challengeStarted) {
          int stepCountDifference = stepCount - previousStepCount;
          if (stepCountDifference >= 10) {
            setState(() {
              distanceTraveled += (stepCountDifference * 0.000762); // Assuming an average step length of 0.762 meters
              previousStepCount = stepCount;
            });
            // Check if the challenge is completed
                  if (distanceTraveled >= 3) {
        challengeStarted = false; // Stop the challenge

        // Show a dialog to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('You have completed the 3 km challenge.'),
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
        }else {
    previousStepCount = stepCount; // Reset the previous step count when the challenge is not started
  }
      });
    });
  }

 /* void setUpPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
_stepCountStream!.listen((StepCount event) {
  if (challengeStarted) {
    int stepCountDifference = event.steps - previousStepCount;

    if (stepCountDifference >= 10) {
      setState(() {
        distanceTraveled += (stepCountDifference * 0.000762); // Assuming an average step length of 0.762 meters
        previousStepCount = event.steps;
      });

      // Check if the challenge is completed
      if (distanceTraveled >= 3) {
        challengeStarted = false; // Stop the challenge

        // Show a dialog to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('You have completed the 3 km challenge.'),
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
    previousStepCount = event.steps; // Reset the previous step count when the challenge is not started
  }
});

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  }*/

  @override
  Widget build(BuildContext context) {
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
                Game.getGameIcon("3 km"), // Replace with your image path
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
              ),
              const SizedBox(width: 15), // Add some space between the title and the icon
              const Text("3 km",
                  style: TextStyle(
                  fontSize: 20.0, // Adjust the font size as needed
                  fontFamily: 'Roboto', // Change to your preferred font
                  fontWeight: FontWeight.bold, // Make the text bold
                )
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              'Distance Traveled: ${distanceTraveled.toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
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
            // StreamBuilder<StepCount>(
            //   stream: _stepCountStream,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       // Here you can calculate the distance traveled based on the step count
            //       // For simplicity, we're just showing the step count
            //       return Text('Distance Traveled: ${(snapshot.data!.steps * 0.000762).toStringAsFixed(2)} km');
            //     } else {
            //       return Text('No step count data');
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}