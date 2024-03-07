import "dart:collection";
import "dart:ffi";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import 'package:intl/intl.dart';
import "package:provider/provider.dart";

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
  Challenge.fromMap(super.map, int playerLevel)
      : level = playerLevel,
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
  Influence.fromMap(super.map, String playerWorld)
      : world = playerWorld,
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

  Future<void> loadGames(String playerType, int level, BuildContext context) async {
    DocumentReference docRef;
    docRef = FirebaseFirestore.instance.collection('Games').doc(playerType);
    String collectionKey;
    if (playerType == 'Challenge') {
      switch (level) {
        case 1:
          collectionKey = 'Level_1';
          break;
        case 2:
          collectionKey = 'Level_2';
          break;
        case 3:
          collectionKey = 'Level_3';
          break;
        default:
          throw Exception('Invalid level');
      }
    } else if (playerType == 'Influence') {
      switch (level) {
        case 1:
          collectionKey = 'Safe and Accessible';
          break;
        case 2:
          collectionKey = 'Pleasant and Green';
          break;
        case 3:
          collectionKey = 'Urban and Lively';
          break;
        default:
          throw Exception('Invalid level');
      }
    } else {
      throw Exception('Invalid player type');
    }

    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
    List<Game> games = [];


    if (data != null) {
      if (playerType == 'Challenge') {
          data[collectionKey].forEach((element) {
          games.add(Challenge.fromMap(element, level));
          });
        
      } else if (playerType == 'Influence') {
          data[collectionKey].forEach((element) {
          games.add(Influence.fromMap(element, collectionKey));
          });
     
      }
    }

    Provider.of<GameProvider>(context, listen: false).setGames(games);
    notifyListeners();
  }
}
