import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/cam_mode_notifier.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/pages/homepage.dart';
import 'globals.dart';
import 'package:intl/intl.dart';

class TakePictureScreen extends StatefulWidget {
  final List<String> imagePaths;
  final String title;
  final String description;
  final String userID;
  final String gameID;

  // ignore: prefer_const_constructors_in_immutables
  TakePictureScreen(
      {super.key,
      required this.imagePaths,
      required this.title,
      required this.description,
      required this.userID,
      required this.gameID});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _TakePictureScreenState createState() =>
      _TakePictureScreenState(imagePaths, userID, gameID);
}

class _TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  List<String> imagePaths;
  String userID;
  final String gameID;
  _TakePictureScreenState(this.imagePaths, this.userID, this.gameID);

  late Stream<StepCount> _stepCountStream;
  //String _steps = '0';
  int _initialSteps = 0;
  bool started = false;
  String? enlargedImagePath;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    //initPlatformState();
    _requestPermission();
    userID = userID.padLeft(6, '0');
    _loadImagePaths();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);
  //   pipModeNotifier.floating.dispose();
  //   final camModeNotifier = Provider.of<CamModeNotifier>(context, listen: false);
  //   camModeNotifier.floating.dispose();
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
  //   final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);
  //   final camModeNotifier = Provider.of<CamModeNotifier>(context, listen: false);
  //   if (lifecycleState == AppLifecycleState.inactive && !camModeNotifier.inCamMode) {
  //     pipModeNotifier.enablePip(context);
  //     pipModeNotifier.inPipMode = true;
  //   }
  //   if (lifecycleState == AppLifecycleState.resumed && pipModeNotifier.inPipMode) {
  //     setState(() {
  //       pipModeNotifier.inPipMode = false;
  //     });
  //   }
  // }

  void _loadImagePaths() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('userGames')
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

  /* Future<void> initPlatformState() async {
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
  }*/

  Future<void> _takePicture() async {
    final camModeNotifier =
        Provider.of<CamModeNotifier>(context, listen: false);
    camModeNotifier.inCamMode = true;
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    logEvent_('user took a picture in take_picture_challenge');
    camModeNotifier.inCamMode = false;
    if (pickedFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final targetPath = "images/$userID/image_$timestamp.jpg";
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

        // Convert the timestamp back to a DateTime object
        final DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestamp);

        // Extract the date and time with two digits for hour, minute, and second
        final String formattedDate =
            "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        final String formattedTime =
            "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

        setState(() {
          imagePaths.add(downloadUrl);
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('userGames')
            .doc(gameID)
            .collection('game_images')
            .add({
          'url': downloadUrl,
          'timestamp': timestamp,
          'date': formattedDate,
          'time': formattedTime,
        });
      } on firebase_storage.FirebaseException {
        // Handle any errors
      }
    } else {
      print("*************** take picture failed !!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  void _enlargeImage(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20), // Change this value to change the border radius
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
    final pipModeNotifier = Provider.of<PipModeNotifier>(context);

    if (pipModeNotifier.inPipMode) {
      return pipModeNotifier.setPipModeImg();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              Game.getGameIcon(widget.title), // Replace with your
              width: 30, // Adjust the width as needed
              height: 30, // Adjust the height as needed
            ),
            const SizedBox(
                width: 15), // Add some space between the title and the icon
            Text(widget.title,
                style: const TextStyle(
                  fontSize: 20.0, // Adjust the font size as needed
                  fontFamily: 'Roboto', // Change to your preferred font
                  fontWeight: FontWeight.bold, // Make the text bold
                )),
          ],
        ),
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
                  // style: const TextStyle(
                  //       fontSize: 20.0, // Adjust the font size as needed
                  //       fontFamily: 'Roboto', // Change to your preferred font
                  //     ),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Text(
                //   'Steps count: $_steps',
                //   style: const TextStyle(fontSize: 18),
                // ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    // camModeNotifier.inCamMode = true;
                    _takePicture();
                    // camModeNotifier.inCamMode = false;
                  },
                  backgroundColor: const Color.fromARGB(
                      255, 177, 216, 179), // Set the background color as needed
                  child: const Icon(Icons.camera_alt), // Use the camera icon
                ),
                const SizedBox(height: 30),
                Table(
                  children: imagePaths.map((url) {
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(url.split('_').last.split('.').first));

                    return TableRow(children: [
                      GestureDetector(
                        onTap: () => _enlargeImage(url),
                        child: Card(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 200, // Set the height of the image
                                width: 200, // Set the width of the image
                                child: Image.network(url, fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${DateFormat('dd/MM/yyyy').format(dateTime)}\n${DateFormat('HH:mm').format(dateTime)}',
                                style: const TextStyle(
                                  fontSize:
                                      16.0, // Adjust the font size as needed
                                  fontFamily:
                                      'Roboto', // Change to your preferred font
                                  fontWeight: FontWeight.bold,
                                ), // Change the value to your desired font size
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
