import "dart:collection";
import "dart:ffi";
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/objects.dart';
import 'package:stepit/features/globals.dart';


class DataBase {
  // a static method to add a user to firestore
  static Future<void> addUser(User user) async {
    FirebaseFirestore.instance.collection('users').add(user.toMap());
    // Save uniqueNumber to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('uniqueNumber', user.uniqueNumber);
  }

  // a static method that checks if a user with the given uniqueNumber exists
  static Future<bool> userExists(int uniqueNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueNumber', isEqualTo: uniqueNumber)
        .get();
    return result.docs.isNotEmpty;
  }

  // a static method that returns the user with the given uniqueNumber
  static Future<User> getUser(int uniqueNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueNumber', isEqualTo: uniqueNumber)
        .get();
    return User.fromMap(result.docs.first.data());
  }

  // a static method that loads the user from firestore to the user global variable
  static Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uniqueNumber = prefs.getInt('uniqueNumber') ?? 0;
    user = getUser(uniqueNumber);
  }
  
}