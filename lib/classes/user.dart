//import "dart:js";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:flutter/src/widgets/framework.dart";
import 'package:provider/provider.dart';
import "package:shared_preferences/shared_preferences.dart";

class User {
  String username;
  int uniqueNumber;
  String gameType;
  int level;
  Timestamp joinedTime = Timestamp.now();

  // subcollection to save daily steps every 15 minutes.

  User(
      {required this.username,
      required this.uniqueNumber,
      required this.gameType, required this.level});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uniqueNumber': uniqueNumber,
      'gameType': gameType,
      'level' : level,
      'joinedTime': joinedTime,
      // 'dailyStepsList': dailyStepsList,
    };
  }

  // a static method to create a user from a map
  User.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        uniqueNumber = map['uniqueNumber'],
        gameType = map['gameType'],
        level = map['level'],
        joinedTime = map['joinedTime'];
  // dailyStepsList = map['dailyStepsList'];

  // comparing two users
  @override
  bool operator ==(Object other) {
    return (other is User) && other.uniqueNumber == uniqueNumber;
  }

  // hashCode for the user
  @override
  int get hashCode => uniqueNumber.hashCode;

  @override
  String toString() {
    return 'User{username: $username, uniqueNumber: $uniqueNumber, gameType: $gameType, joinedTime: $joinedTime}';
  }
}

// User provider
class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

void saveUser(BuildContext context, String username, int uniqueNumber, String gameType, int level) async {
  User user = User(username: username, uniqueNumber: uniqueNumber, gameType: gameType, level: level);

  // Save to Firebase
  await FirebaseFirestore.instance.collection('users').doc(uniqueNumber.toString().padLeft(6, '0')).set(user.toMap());

  // Save to shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setInt('uniqueNumber', user.uniqueNumber);
  await prefs.setString('gameType', user.gameType);
  await prefs.setInt('level', user.level);

  // Update user provider
  Provider.of<UserProvider>(context, listen: false).setUser(user);

  // return user;
}

Future<User?> loadUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  int? uniqueNumber = prefs.getInt('uniqueNumber');
  String? gameType = prefs.getString('gameType');
  int? level = prefs.getInt('level');

  if (username != null && uniqueNumber != null && gameType != null && level != null) {
    User user = User(username: username, uniqueNumber: uniqueNumber, gameType: gameType, level: level);
    Provider.of<UserProvider>(context, listen: false).setUser(user);
    return user;
  } else {
    return null;
  }
}