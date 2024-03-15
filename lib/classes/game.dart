import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";

class Game {
  String id;
  String title;
  String description;
  int level;
  String type;
  

  //constructor
  Game({required this.id, required this.title, required this.description, required this.level, required this.type});

  // a method to convert a game to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'type': type,
    };
  }

  // a static method to create a game from a map
  Game.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'], 
        level = map['level'],
        type = map['type'];


  static int stringLevelToInt(String level) {
    switch (level) {
      case '1':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      default:
        throw Exception('Invalid level');
    }
  }

  // comparing two games
  @override
  bool operator ==(Object other) {
    return (other is Game) && other.id == id;
  }

  // hashCode for the game
  @override
  int get hashCode => title.hashCode;

  @override
  String toString() {
    return 'Game{id: $id, title: $title, description: $description, level: $level, type: $type}';
  }
  
  static fromDocument(DocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      level: stringLevelToInt(data['level']),
      type: data['type'],
    );
  }
}

/* class Challenge extends Game {
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
*/
class GameProvider extends ChangeNotifier {
  List<Game> _games = [];

  List<Game> get games => _games;

  void setGames(List<Game> games) {
    _games = games;
    notifyListeners();
  }

  Future<void> loadGames(String playerType, int level, BuildContext context) async {
   // DocumentReference docRef;
    // docRef = FirebaseFirestore.instance.collection('Games').doc(playerType);
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

   // DocumentSnapshot docSnapshot = await docRef.get();
    //Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?; 
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('games')
    .where('type', isEqualTo: playerType).where('level', isEqualTo: level.toString())
    .get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    List<Game>? games = [];
    games = docs.map((doc) => Game.fromDocument(doc)).cast<Game>().toList();


   /* if (data != null) {
      if (playerType == 'Challenge') {
          data[collectionKey].forEach((element) {
          games.add(Challenge.fromMap(element, level));
          });
        
      } else if (playerType == 'Influence') {
          data[collectionKey].forEach((element) {
          games.add(Influence.fromMap(element, collectionKey));
          });
     
      }
    }*/
    // games.shuffle(Random());
    Provider.of<GameProvider>(context, listen: false).setGames(games);
    notifyListeners();
  }
}
