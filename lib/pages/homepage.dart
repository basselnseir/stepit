
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/challenges/game_02_speed.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/challenge_tile.dart';
import 'package:stepit/features/picture_challenge.dart';
import 'package:stepit/pages/status.dart';
import 'package:stepit/features/km_challenge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //DataBase.loadUser();
    //SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);
    pipModeNotifier.floating.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);
    if (lifecycleState == AppLifecycleState.inactive) {
      pipModeNotifier.enablePip(context);
      pipModeNotifier.inPipMode = true;
    }
    if (lifecycleState == AppLifecycleState.resumed && pipModeNotifier.inPipMode) {
      setState(() {
        pipModeNotifier.inPipMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);
  // final pipModeNotifier = Provider.of<PipModeNotifier>(context);


    if (pipModeNotifier.inPipMode){
      return pipModeNotifier.setPipModeImg();
    }
    User? user = Provider.of<UserProvider>(context).user;
    GameProvider? gameProvider = Provider.of<GameProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final double screenWidth = MediaQuery.of(context).size.width;
        const double tileWidth = 210.0;
        const double padding = 8.0;
        final double targetOffset =
            tileWidth + 2 * padding + tileWidth / 2 - screenWidth / 2;

        _scrollController.animateTo(
          targetOffset,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 1000),
        );
      }
    });

    if (user == null) {
      return FutureBuilder<User?>(
        future: loadUser(context),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            user = snapshot.data;
            if (user != null) {
              Provider.of<UserProvider>(context, listen: false).setUser(user!);
            } else {
              return const Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
            }
          }
          return Container();
        },
      );
    }

    if (gameProvider.games.isEmpty && user != null) {
      FutureBuilder(
        future: gameProvider.loadGames(user, context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text("data");
          }
        },
      );
    }

    if (user == null || gameProvider.games.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('StepIt'),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 184, 239, 186),
          child: Container(
            margin: const EdgeInsets.only(top: 50.0),
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: const Text('Status'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatusPage()),
                    );
                  },
                ),

              ListTile(
                  title: const Text('Game_01'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengePage(game: gameProvider.games[0])),
                      
                    );
                  },
                ),
                
                ListTile(
                  title: const Text('Game_02'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Game_02_speed()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Game_03'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>KMChallengePage(title: "3 km Challenge",
                                                    description: "Your challenge is to walk for 3 kilometers in a row.")),
                    );
                  },
                ),
                // ListTile(
                //   title: Text('PiP mode'),
                //   onTap: () async {
                //     enablePip(context);
                //     inPipMode = true;
                //   },
                // ),
                // Add more ListTiles for more pages
              ],
            ),
          ),
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
              Column(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(8.0), // Add some margin if you want
                    color: const Color.fromARGB(255, 43, 180, 97),
                    child: ListTile(
                      onTap: () {
                        if (user!.gameType == 'Influence') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakePictureScreen(
                                imagePaths: [], // Pass the imagePaths here
                                title: gameProvider.games[0].title,
                                description: gameProvider.games[0].description,
                                userID: user!.uniqueNumber.toString(),
                                gameID: gameProvider.games[0].id,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KMChallengePage(title: gameProvider.games[0].title,
                                                    description: gameProvider.games[0].description),
                            ),
                          );
                        }
                      },
                      title: Text(
                        gameProvider.games[0].title,
                        style: const TextStyle(
                          fontSize: 20.0, // Adjust the font size as needed
                          fontFamily: 'Roboto', // Change to your preferred font
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      trailing: Game.getGameIcon(gameProvider.games[0].title), // Add your icon here
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.all(8.0), // Add some margin if you want
                    color: const Color.fromARGB(255, 43, 180, 97),
                    child: ListTile(
                      onTap: () {
                        if (user!.gameType == 'Influence') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakePictureScreen(
                                imagePaths: [], // Pass the imagePaths here
                                title: gameProvider.games[1].title,
                                description: gameProvider.games[1].description,
                                userID: user!.uniqueNumber.toString(),
                                gameID: gameProvider.games[1].id,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KMChallengePage(title: gameProvider.games[1].title,
                                                    description: gameProvider.games[1].description),
                            ),
                          );
                        }
                      },
                      title: Text(
                        gameProvider.games[1].title,
                        style: const TextStyle(
                          fontSize: 20.0, // Adjust the font size as needed
                          fontFamily: 'Roboto', // Change to your preferred font
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      trailing: Game.getGameIcon(gameProvider.games[1].title), // Add your icon here
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.all(8.0), // Add some margin if you want
                    color: const Color.fromARGB(255, 43, 180, 97),
                    child: ListTile(
                      onTap: () {
                        if (user!.gameType == 'Influence') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakePictureScreen(
                                imagePaths: [], // Pass the imagePaths here
                                title: gameProvider.games[2].title,
                                description: gameProvider.games[2].description,
                                userID: user!.uniqueNumber.toString(),
                                gameID: gameProvider.games[2].id,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KMChallengePage(title: gameProvider.games[2].title,
                                                    description: gameProvider.games[2].description),
                            ),
                          );
                        }
                      },
                      title: Text(
                        gameProvider.games[2].title,
                        style: const TextStyle(
                          fontSize: 20.0, // Adjust the font size as needed
                          fontFamily: 'Roboto', // Change to your preferred font
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      trailing: Game.getGameIcon(gameProvider.games[2].title), // Add your icon here
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'ID: ${user.uniqueNumber.toString().padLeft(6, '0')}',
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
}



// 'ID: ${snapshot.data!.uniqueNumber.toString().padLeft(6, '0')}'