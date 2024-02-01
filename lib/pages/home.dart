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
                        '500 Steps',
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(imagePaths: [],)),
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