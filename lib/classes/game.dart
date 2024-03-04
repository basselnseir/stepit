import "dart:collection";
import "dart:ffi";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import 'package:intl/intl.dart';

class Game {
  String title;
  String description;

  //constructor
  Game({required this.title, required this.description});

  // a method to convert a game to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  // a static method to create a game from a map
  Game.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'];

  // comparing two games
  @override
  bool operator ==(Object other) {
    return (other is Game) && other.title == title;
  }

  // hashCode for the game
  @override
  int get hashCode => title.hashCode;

  @override
  String toString() {
    return 'Game{title: $title, description: $description}';
  }
}

class Challenge extends Game {
  int level;

  // constructor
  Challenge(
      {required super.title, required super.description, required this.level});

  // a method to convert a challenge to a map
  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'level': level,
    };
  }

  // a static method to create a challenge from a map
  @override
  Challenge.fromMap(super.map)
      : level = map['level'],
        super.fromMap();

  // comparing two challenges
  @override
  bool operator ==(Object other) {
    return (other is Challenge) && other.title == title && other.level == level;
  }
}

class Influence extends Game {
  String world;

  // constructor
  Influence(
      {required super.title, required super.description, required this.world});

  // a method to convert a influence game to a map
  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'world': world,
    };
  }

  // a static method to create a influence game from a map
  @override
  Influence.fromMap(super.map)
      : world = map['world'],
        super.fromMap();

  // comparing two influence games
  @override
  bool operator ==(Object other) {
    return (other is Influence) && other.title == title && other.world == world;
  }
}

class GameProvider extends ChangeNotifier {
  List<Game> _games = [];

  List<Game> get games => _games;

  void setGames(List<Game> games) {
    _games = games;
    notifyListeners();
  }

  Future<void> loadGames(String playerType) async {
    DocumentReference docRef;
    if (playerType == 'Challenge') {
      docRef =  FirebaseFirestore.instance.collection('Challenges').doc('AV6AQgJ6FsHrkBLBV2PI');
    } else if (playerType == 'Influence') {
      docRef =  FirebaseFirestore.instance.collection('Challenges').doc('ug9QUS1APtqoK6DosPWY');
    } else {
      throw Exception('Invalid player type');
    }
   
    DocumentSnapshot docSnapshot = await docRef.get();
    // List<Game> games = [];
    Object? games = docSnapshot.data();
    /*for (var doc in querySnapshot) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> values = data.values.toList();
      Map<String, dynamic> gameMap = values[0] as Map<String, dynamic>;

      String title = gameMap['title'];
      String description = gameMap['description'];
      int level = 0;
      String world = 'Safe and accessible';

      if (playerType == 'Challenge') {
        level = gameMap['level'];
        games.add(Challenge(title: title, description: description, level: level));
      } else {
        world ='Safe and accessible';
        games.add(Influence(title: title, description: description, world: world));
      }
    }*/

    //this.games = games as List<Game>;
    notifyListeners();
  }
}
