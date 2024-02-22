import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:stepit/pages/homepage.dart';

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  String _username = '';
  late Future<int> _uniqueNumber;

  @override
  void initState() {
    super.initState();
    _uniqueNumber = _generateUniqueNumber();
  }

  Future<int> _generateUniqueNumber() async {
    int uniqueNumber = 100000 +
        Random().nextInt(
            900000); // Generates a random number between 100000 and 999999
    bool isUnique = await _checkUniqueNumber(uniqueNumber);
    while (!isUnique) {
      uniqueNumber = 100000 + Random().nextInt(900000);
      isUnique = await _checkUniqueNumber(uniqueNumber);
    }
    return uniqueNumber;
  }


  Future<bool> _checkUniqueNumber(int uniqueNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueNumber', isEqualTo: uniqueNumber)
        .get();
    return result.docs.isEmpty;
  }

  void _saveToFirestore() async {
    int uniqueNumber = await _uniqueNumber;
    FirebaseFirestore.instance.collection('users').add({
      'username': _username,
      'uniqueNumber': uniqueNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200, // Adjust this value as needed
          padding: const EdgeInsets.all(10), // Add this line to add padding
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 248, 246,
                246), // Change this color to match your background color
            borderRadius: BorderRadius.all(Radius.circular(
                20)), // Add this line to make the corners rounded
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Change this color as needed
                spreadRadius: 5, // Change this value as needed
                blurRadius: 7, // Change this value as needed
                offset: Offset(0, 3), // Change this value as needed
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter username',
                ),
              ),
              FutureBuilder<int>(
                future: _uniqueNumber,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text('Unique number: ${snapshot.data}');
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _saveToFirestore();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
