import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stepit/classes/user.dart";

class Game {
  String id;
  String title;
  String description;
  int level;
  String type;
  /*
  TODO:
        Add a field for the date the game was picked.
        Add a field for checking if the player entered the game.
        Add a field for checking if the player has finished the game.
 */

  //constructor
  Game(
      {required this.id,
      required this.title,
      required this.description,
      required this.level,
      required this.type});

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

  static String getGameIcon(String title) {
    String icon = "";
    switch (title) {
      case '5000 Steps':
        icon = "footsteps.png";
      case 'Fast 15 min':
        icon = "15.png";
      case '2000 in an hour':
        icon = "one-hour.png";
      case '1 km':
        icon = "number-3.png";
      case '7500 Steps':
        icon = "footsteps.png";
      case 'Fast 30 min':
        icon = "15.png";
      case '4000 in an hour':
        icon = "one-hour.png";
      case '1.5 km':
        icon = "number-3.png";
      case '10000 Steps':
        icon = "footsteps.png";
      case 'Fast 45 min':
        icon = "15.png";
      case '6000 in an hour':
        icon = "one-hour.png";
      case '2 km':
        icon = "number-3.png";

      case 'Sidewalk Defects':
        icon = "sidewalk.png";
      case 'Risks For Pedestrians':
        icon = "students.png";
      case 'Conflicts':
        icon = "bike.png";
      case 'Missing Lightning':
        icon = "street-light.png";
      case 'Blocking Pedestrians':
        icon = "park.png";
      case 'Playgrounds':
        icon = "playground.png";
      case 'Widening The Sidewalk':
        icon = "widening.png";
      case 'Relaxing Spots':
        icon = "relax.png";
      case 'Shadow':
        icon = "shadow.png";
      case 'Beautiful Trees':
        icon = "beautifultree.png";
      case 'Cleanliness':
        icon = "dust.png";
      case 'Add Vegetation':
        icon = "shovels.png";

      // case 'Crosswalks':
      //   icon = "crosswalk.png";
      // case 'Faucets':
      //   icon = "faucet.png";
      // case 'Public Buildings':
      //   icon = "skyline.png";
      // case 'Blocked Bus Stops':
      //   icon = "bus-stop.png";

      default:
        throw Exception('Invalid title');
    }
    // return Image.asset('lib\\images\\$icon', // Replace with your image path
    //   width: 100.0,
    //   height: 100.0,
    //   fit: BoxFit.fill,);
    return 'lib/images/$icon'; // Replace with your image path
  }
}

class GameProvider extends ChangeNotifier {
  List<Game> _games = [];

  List<Game> get games => _games;

  void setGames(List<Game> games) {
    _games = games;
    notifyListeners();
  }

  Future<void> loadGames(User user, BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('games')
        .where('type', isEqualTo: user.gameType)
        .where('level', isEqualTo: user.level.toString())
        .get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    List<Game>? games = [];
    games = docs.map((doc) => Game.fromDocument(doc)).cast<Game>().toList();

    // Get today's games
    List<Game> todaysGames = await getTodaysGames(games, user);

    // Save today's games to the user's collection
    //await saveTodaysGames(todaysGames, user);

    Provider.of<GameProvider>(context, listen: false).setGames(todaysGames);
    notifyListeners();
  }

  Future<List<Game>> getTodaysGames(List<Game> allGames, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString('date');
    String today = DateTime.now().toIso8601String().split('T')[0];

    if (storedDate != today) {
      CollectionReference userGames = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uniqueNumber.toString().padLeft(6, '0'))
          .collection('userGames');

      // Fetch the user's completed games
      QuerySnapshot completedGamesSnapshot =
          await userGames.where('Completed', isEqualTo: true).get();
      List<String> completedGameIds =
          completedGamesSnapshot.docs.map((doc) => doc.id).toList();

      // Filter the games that have not been completed
      List<Game> filteredGames = allGames
          .where((game) => !completedGameIds.contains(game.id))
          .toList();

      // Shuffle and select the filtered games
      filteredGames.shuffle();
      List<Game> games = filteredGames.take(3).toList();
      List<String> gameIds = games.map((game) => game.id).toList();

      await prefs.setString('date', today);
      await prefs.setStringList('gameIds', gameIds);
      await saveTodaysGames(games, user);
      return games;
    } else {
      List<String> storedGameIds = prefs.getStringList('gameIds') ?? [];
      return allGames.where((game) => storedGameIds.contains(game.id)).toList();
    }
  }
}

Future<void> saveTodaysGames(List<Game> games, User user) async {
  String today = DateTime.now().toIso8601String().split('T')[0];
  CollectionReference userGames = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uniqueNumber.toString().padLeft(6, '0'))
      .collection('userGames');

  for (var game in games) {
    await userGames
        .doc(game.id)
        .set(game.toMap()..addAll({'Date': today, 'Completed': false}));
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


  /*Future<void> loadGames(String playerType, int level, BuildContext context) async {
   // DocumentReference docRef;
    // docRef = FirebaseFirestore.instance.collection('Games').doc(playerType);
   /* String collectionKey;
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
    }*/

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
}*/
