import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class KMChallengePage extends StatefulWidget {
  final String title;
  final String description;

  const KMChallengePage({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  _KMChallengePageState createState() => _KMChallengePageState();
}

class _KMChallengePageState extends State<KMChallengePage> {
  double distanceTraveled = 0;
  bool challengeStarted = false;
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;

  @override
  void initState() {
    super.initState();
    setUpPedometer();
  }

  void setUpPedometer() {
    int previousStepCount = 0;

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen((StepCount event) {
      if (challengeStarted) {
        int stepCountDifference = event.steps - previousStepCount;

        if (stepCountDifference >= 10) {
          setState(() {
            distanceTraveled += (stepCountDifference * 0.000762); // Assuming an average step length of 0.762 meters
            previousStepCount = event.steps;
          });
        }
      }
    });

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  },
            child: Text('Start Challenge'),
            style: ElevatedButton.styleFrom(
              backgroundColor: challengeStarted ? Colors.grey : null,
            ),
          ),
          StreamBuilder<StepCount>(
            stream: _stepCountStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Here you can calculate the distance traveled based on the step count
                // For simplicity, we're just showing the step count
                return Text('Distance Traveled: ${(snapshot.data!.steps * 0.000762).toStringAsFixed(2)} km');
              } else {
                return Text('No step count data');
              }
            },
          ),
        ],
      ),
    );
  }
}