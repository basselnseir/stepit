import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart';


class TakePictureFeature extends StatefulWidget {
  final List<String> imagePaths;

  const TakePictureFeature({super.key, required this.imagePaths});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _TakePictureFeatureState createState() => _TakePictureFeatureState(imagePaths);
}

class _TakePictureFeatureState extends State<TakePictureFeature> {
  List<String> imagePaths;

  _TakePictureFeatureState(this.imagePaths);

  bool started = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _loadImagePaths();
  }

  void _loadImagePaths() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('images').get();
    final urls = querySnapshot.docs.map((doc) => doc['url']).toList();
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

      await FirebaseFirestore.instance.collection('images').add({
        'url': downloadUrl,
        'timestamp': timestamp,
      });
    } on firebase_storage.FirebaseException {
      // Handle any errors
    }
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Take Picture'),
                ),
                const SizedBox(height: 20),
                Table(
                  children: imagePaths.map((url) {
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(url.split('_').last.split('.').first));

                    return TableRow(children: [
                      Card(
                        child: Row(
                          children: [
                            Container(
                              height: 100, // Set the height of the image
                              width: 100, // Set the width of the image
                              child: Image.network(url, fit: BoxFit.contain),
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