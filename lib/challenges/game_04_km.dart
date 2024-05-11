import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stepit/classes/game.dart';

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