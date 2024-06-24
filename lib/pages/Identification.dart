import 'package:flutter/material.dart';
import 'dart:math';
import "package:stepit/background/steps_tracking_wm.dart";
import 'package:stepit/classes/database.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:stepit/classes/user.dart';

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  String _username = '';
  late Future<int> _uniqueNumber;
  late String _gameType;
  bool connectionState = false;

  @override
  void initState() {
    super.initState();
    _uniqueNumber = _generateUniqueNumber();
    _gameType = _generateGameType();
    //_gameType = 'Influence';
  }

  Future<int> _generateUniqueNumber() async {
    // return the number of user in the database
    return await DataBase.getNumberOfUsers();
  }


  String _generateGameType()  {
    if(Random().nextInt(2) == 0) {
      return 'Challenge';
    }
    return 'Influence';
  }
  
  // Future<int> _generateUniqueNumber() async {
    //     Random().nextInt(
    //         900000); // Generates a random number between 100000 and 999999
    // bool isUnique = await _checkUniqueNumber(uniqueNumber);
    // while (!isUnique) {
    //   uniqueNumber = 100000 + Random().nextInt(900000);
    //   isUnique = await _checkUniqueNumber(uniqueNumber);
    // }
    // return uniqueNumber;
  // }

  // Future<bool> _checkUniqueNumber(int uniqueNumber) async {
  //   return DataBase.userExists(uniqueNumber);
  // }

  void _saveToFirestore(BuildContext context) async {
    int uniqueNumber = await _uniqueNumber;
    String gameType =  _gameType;
    saveUser(context, _username, uniqueNumber, gameType, 1);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Welcome to StepIT!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                const Text(
                  'Enter a username to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter username',
                    ),
                  ),
                ),
                FutureBuilder<int>(
                  future: _uniqueNumber,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  const Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      );
                    } else {
                      connectionState = true;
                      return Text('Unique number: ${snapshot.data.toString().padLeft(6, '0')}');
                    }
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: connectionState
                      ? () {
                          _saveToFirestore(context);
                          startStepsTracking();
                          //loadUser(context).then((_) => startStepsTracking());
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      : null,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Set the desired text color here
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
