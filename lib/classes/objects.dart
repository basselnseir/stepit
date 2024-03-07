import "dart:collection";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:intl/intl.dart';




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

