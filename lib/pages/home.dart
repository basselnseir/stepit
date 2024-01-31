import 'package:flutter/material.dart';
import '100_steps.dart'; 
import 'take_picture.dart'; 

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepIT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Go to 100 Steps Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepCounter()), // Replace with your actual StatefulWidget
                );
              },
            ),
            ElevatedButton(
              child: const Text('Go to Take Picture Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePictureScreen(imagePaths: [],)), // Replace with your actual StatefulWidget
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}