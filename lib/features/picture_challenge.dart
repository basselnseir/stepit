import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart';
import 'package:intl/intl.dart';

class TakePictureScreen extends StatefulWidget {
  final List<String> imagePaths;
  final String title;
  final String description;
  final String userID;
  final String gameID;
  
  // ignore: prefer_const_constructors_in_immutables
  TakePictureScreen({super.key, 
                    required this.imagePaths, 
                    required this.title, 
                    required this.description, 
                    required this.userID, 
                    required this.gameID});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _TakePictureScreenState createState() => _TakePictureScreenState(imagePaths, userID, gameID);
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  List<String> imagePaths;
  String userID;
  final String gameID;
  _TakePictureScreenState(this.imagePaths, this.userID, this.gameID);

  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  int _initialSteps = 0;
  bool started = false;
  String? enlargedImagePath;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _requestPermission();
    userID = userID.padLeft(6, '0');
    _loadImagePaths();
  }

  void _loadImagePaths() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users')
                                                          .doc(userID)
                                                          .collection('images')
                                                          .doc(gameID)
                                                          .collection('game_images')
                                                          .get();
    final urls = querySnapshot.docs.map((doc) => doc.data()['url']).toList();
    setState(() {
      imagePaths = List<String>.from(urls);
    });
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
    logEvent_('user steps increased in take_picture_challenge');
    setState(() {
      if (started){
        _steps = (event.steps - _initialSteps).toString();
      }
    });
  }

  void onError(error) {
    if (error is PlatformException && error.code == '1') {
      setState(() {
        _steps = 'Step counter not available on this device';
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    logEvent_('user took a picture in take_picture_challenge');
    if (pickedFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final targetPath = "images/image_$timestamp.jpg";
      final file = File(pickedFile.path);
      try {
        
        // Upload the file to Firebase Storage
        await firebase_storage.FirebaseStorage.instance
            .ref(targetPath)
            .putFile(file);
        // Add a delay before getting the download URL

        // Once the file upload is complete, get the download URL
        final downloadUrl = await firebase_storage.FirebaseStorage.instance
            .ref(targetPath)
            .getDownloadURL();


        setState(() {
          imagePaths.add(downloadUrl);
        });

        await FirebaseFirestore.instance.collection('users')
                                          .doc(userID)
                                          .collection('images')
                                          .doc(gameID)
                                          .collection('game_images')
                                          .add({
          'url': downloadUrl,
          'timestamp': timestamp,
        });
      } on firebase_storage.FirebaseException {
        // Handle any errors
      }
    }
  }

void _enlargeImage(String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Change this value to change the border radius
        ),
        child: GestureDetector(
          onTap: _closeEnlarged,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imagePath,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      );
    },
  );
}

void _closeEnlarged() {
  Navigator.of(context).pop();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.description,
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
                  children: imagePaths.map((url) {
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(url.split('_').last.split('.').first));

                    return TableRow(children: [
                      GestureDetector(
                        onTap: () => _enlargeImage(url),
                        child: Card(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 100, // Set the height of the image
                                width: 100, // Set the width of the image
                                child: Image.network(url, fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('dd/MM/yyyy').format(dateTime) + '\n' + DateFormat('HH:mm').format(dateTime),
                                style: TextStyle(fontSize: 20), // Change the value to your desired font size
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
                if (enlargedImagePath != null)
                  GestureDetector(
                    onTap: _closeEnlarged,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Image.network(
                          enlargedImagePath!,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}