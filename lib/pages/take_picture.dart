import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';


class TakePictureScreen extends StatefulWidget {
  final List<String> imagePaths;

  TakePictureScreen({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState(imagePaths);
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  List<String> imagePaths;

  _TakePictureScreenState(this.imagePaths);

  // String _stepCount = '0';
  // late Stream<StepCount> _stepCountStream;
  // late StreamSubscription<StepCount> _stepCountSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _startPedometer();
  // }

  // @override
  // void dispose() {
  //   _stopPedometer();
  //   super.dispose();
  // }

  // void _startPedometer() {
  //   _stepCountStream = Pedometer.stepCountStream;
  //   _stepCountSubscription = _stepCountStream.listen((stepCount) {
  //     setState(() {
  //       _stepCount = stepCount.steps.toString();
  //     });
  //   });
  // }

  // void _stopPedometer() {
  //   _stepCountSubscription.cancel();
  // }

  // late Pedometer _pedometer;
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  int _initialSteps = 0;
  bool started = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _requestPermission();
  }

  void _requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // You can start listening to the pedometer here.
    }
  }

  Future<void> initPlatformState() async {
    // _pedometer = Pedometer();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onData).onError(onError);

    // Get the initial step count
    _stepCountStream.first.then((StepCount event) {
      _initialSteps = event.steps;
      started = true;
    });
  }

  void onData(StepCount event) {
    setState(() {
      if (started){
        _steps = (event.steps - _initialSteps).toString();
      }
    });
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
    if (error is PlatformException && error.code == '1') {
      setState(() {
        _steps = 'Step counter not available on this device';
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final targetPath = dir.absolute.path + "/image_${timestamp}.jpg";
      final file = await File(pickedFile.path).copy(targetPath);

      setState(() {
        imagePaths.add(file.path);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHALLENGE: TREES'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'In this challenge, you should take as many trees\' pictures as you can.',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'Steps count: $_steps',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Take Picture'),
                ),
                const SizedBox(height: 20),
                Table(
                  children: imagePaths.map((path) {
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(path.split('_').last.split('.').first));

                    return TableRow(children: [
                      Card(
                        child: Row(
                          children: [
                            Container(
                              height: 100, // Set the height of the image
                              width: 100, // Set the width of the image
                              child: Image.file(File(path), fit: BoxFit.contain),
                            ),
                            const SizedBox(width: 10),
                            Text(dateTime.toString()), // Display the date and time
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}