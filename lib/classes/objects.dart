import "dart:collection";
import "dart:ffi";
import 'package:intl/intl.dart';

class User {
  String username;
  int uniqueNumber;
  DateTime borntimestamp = DateTime.now();
  LinkedList<DailySteps> dailyStepsList = LinkedList<DailySteps>();

  User(this.username, this.uniqueNumber); //constructor

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uniqueNumber': uniqueNumber,
      'borntimestamp': borntimestamp,
      'dailyStepsList': dailyStepsList,
    };
  }

  // a static method to create a user from a map
  User.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        uniqueNumber = map['uniqueNumber'],
        borntimestamp = map['borntimestamp'],
        dailyStepsList = map['dailyStepsList'];

  // comparing two users
  @override
  bool operator ==(Object other) {
    return (other is User) && other.uniqueNumber == uniqueNumber;
  }

  // hashCode for the user
  @override
  int get hashCode => uniqueNumber.hashCode;
}

final class DailySteps extends LinkedListEntry<DailySteps>{
  LinkedList<FreqSteps> freqStepsList = LinkedList<FreqSteps>();
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DailySteps(); //constructor
}

final class FreqSteps extends LinkedListEntry<FreqSteps>{
  int steps;
  DateTime timestamp = DateTime.now();

  FreqSteps(this.steps); //constructor
}