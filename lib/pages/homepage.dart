import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/database.dart';
import 'package:stepit/classes/objects.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/features/globals.dart';
import 'package:stepit/classes/game.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //DataBase.loadUser();
    //SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final double screenWidth = MediaQuery.of(context).size.width;
        const double tileWidth =
            210.0; // Assuming each tile has a width of 200.0
        const double padding = 8.0; // Assuming padding around each tile is 8.0
        final double targetOffset =
            tileWidth + 2 * padding + tileWidth / 2 - screenWidth / 2;

        _scrollController.animateTo(
          targetOffset,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 1000),
        );
      }
    });
    User? user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return FutureBuilder<User?>(
        future: loadUser(context),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            user = snapshot.data;
            if (user != null) {
              Provider.of<UserProvider>(context, listen: false).setUser(user!);
              //return Text(
              //  'Username: ${user?.username}, ID: ${user?.uniqueNumber}, Type: ${user?.gameType}');
            } else {
              return const Text('No user data');
            }
          }
          return Container();
        },
      );
    }


  // GameProvider? gameProvider = Provider.of<GameProvider>(context);
    
    FutureBuilder(
      future: FirebaseFirestore.instance.collection('Challenges').doc('AV6AQgJ6FsHrkBLBV2PI').get(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Get the GameProvider from the context
          //gameProvider = Provider.of<GameProvider>(context);
          final gamesData = snapshot.data?.data();
          final games = (gamesData as Map<String, dynamic>).values.toList() as List<Map<String, dynamic>>;
          // Access the games list
          //List<Game> games = gameProvider!.games;
          // Use the games list in a widget
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(gamesData[index].title),
                subtitle: Text(gamesData[index].description),
              );
            },
          );
        }
      },
    );


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('StepIt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Choose one of the following challenges',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 70),
            user.gameType == 'Challenge'
                ? Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the challenge page
                        },
                        child: const Text('Challenge 1'), //Text(games[0].title),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the challenge page
                        },
                        child: const Text('Challenge 2'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the challenge page
                        },
                        child: const Text('Challenge 3'),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                        },
                        child: const Text('Game 1'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                        },
                        child: const Text('Game 2'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the game page
                        },
                        child: const Text('Game 3'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text('ID: ${user.uniqueNumber.toString().padLeft(6, '0')}', 
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  ),
          ],
        ),
      ),
    );
  }
}



// 'ID: ${snapshot.data!.uniqueNumber.toString().padLeft(6, '0')}'