import "dart:collection";
import "dart:ffi";
import 'package:intl/intl.dart';

class User {
  String username;
  int uniqueNumber;
  DateTime borntimestamp = DateTime.now();
  LinkedList<DailySteps> dailyStepsList = LinkedList<DailySteps>();

  User(this.username, this.uniqueNumber); //constructor
  
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