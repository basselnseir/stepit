import 'package:flutter/material.dart';
import '100_steps.dart'; 
import 'globals.dart';
import 'package:stepit/features/picture_challenge.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('StepIT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  logEvent_('user entered 100_steps_challenge');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StepCounter()),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.directions_walk),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        '100 Steps',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              width: 100,
              height: 100,
              child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Adjust this value to your desired corner radius
    ),
  ),
  onPressed: () {
    logEvent_('user entered trees_challenge');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureFeature(imagePaths: [],)),
    );
  },
  child: const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(Icons.camera_alt),
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          'Trees',
          style: TextStyle(fontSize: 10),
        ),
      ),
    ],
  ),
),
            ),
          ],
        ),
      ),
    );
  }
}