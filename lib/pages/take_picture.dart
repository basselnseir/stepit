import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class TakePictureScreen extends StatefulWidget {
  var imagePath;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  String? imagePath;
  String _stepCount = '0';
  late Stream<StepCount> _stepCountStream;
  late StreamSubscription<StepCount> _stepCountSubscription;

  @override
  void initState() {
    super.initState();
    _startPedometer();
  }

  @override
  void dispose() {
    _stopPedometer();
    super.dispose();
  }

  void _startPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream.listen((stepCount) {
      setState(() {
        _stepCount = stepCount.steps.toString();
      });
    });
  }

  void _stopPedometer() {
    _stepCountSubscription.cancel();
  }

  Future<void> _takePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final targetPath = dir.absolute.path + "/image.jpg";
      final file = await File(pickedFile.path).copy(targetPath);

      setState(() {
        imagePath = file.path;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(imagePath: file.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Image.file(File(widget.imagePath)),
            ),
            const Text(
              'Make your challenge',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Step Count: $_stepCount',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Take Picture'),
            ),
            const SizedBox(height: 20),
            Table(
              children: [
                TableRow(
                  children: [
                    if (imagePath != null)
                      Card(
                        child: Image.file(File(imagePath!)),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
