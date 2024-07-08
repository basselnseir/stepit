
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/challenges/game_02_speed.dart';
import 'package:stepit/challenges/game_03_time.dart';
import 'package:stepit/challenges/game_04_km.dart';
import 'package:stepit/challenges/tmp_game_01.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/challenge_tile.dart';
import 'package:stepit/features/picture_challenge.dart';
import 'package:stepit/pages/status.dart';


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

  Card challegeButton(int button_index, user, gameProvider, context){
    Game game = gameProvider.games[button_index];
    return Card(
        margin: const EdgeInsets.all(8.0), // Add some margin if you want
        color: Color.fromARGB(255, 103, 187, 136),
        child: InkWell(
          onTap: () {
            if (user!.gameType == 'Influence') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakePictureScreen(
                    imagePaths: [], // Pass the imagePaths here
                    title: game.title,
                    description: game.description,
                    userID: user!.uniqueNumber.toString(),
                    gameID: game.id,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_04_km(title: game.title,
                                        description: game.description),
                ),
              );
            }
          },
          child: Container(
            height: 220, // Adjust the height as needed
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      gameProvider.games[button_index].title,
                      style: const TextStyle(
                        fontSize: 20.0, // Adjust the font size as needed
                        fontFamily: 'Roboto', // Change to your preferred font
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                    SizedBox(height: 10), // Add some space between the title and the description
                    Text(
                      gameProvider.games[button_index].description, // Replace with your description
                      style: const TextStyle(
                        fontSize: 16.0, // Adjust the font size as needed
                        fontFamily: 'Roboto', // Change to your preferred font
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            Game.getGameIcon(gameProvider.games[button_index].title), // Replace with your image path
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {

    final pipModeNotifier = Provider.of<PipModeNotifier>(context, listen: false);

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
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            // Call your method to enter PiP mode here
            pipModeNotifier.inPipMode = true; // Assuming this is how you trigger PiP mode
            return pipModeNotifier.enablePip(context); // Prevents the app from exiting or going back
          }, child: FutureBuilder<User?>(
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
        ),
      );
    }

    if (gameProvider.games.isEmpty && user != null) {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            // Call your method to enter PiP mode here
            pipModeNotifier.inPipMode = true; // Assuming this is how you trigger PiP mode
            return pipModeNotifier.enablePip(context); // Prevents the app from exiting or going back
          }, child: FutureBuilder(
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
        ),
      );
    }

    if (user == null || gameProvider.games.isEmpty) {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            // Call your method to enter PiP mode here
            pipModeNotifier.inPipMode = true; // Assuming this is how you trigger PiP mode
            return pipModeNotifier.enablePip(context); // Prevents the app from exiting or going back
          }, child: const Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    } else {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            // Call your method to enter PiP mode here
            pipModeNotifier.inPipMode = true; // Assuming this is how you trigger PiP mode
            return pipModeNotifier.enablePip(context); // Prevents the app from exiting or going back
          }, child:  Scaffold(
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
            title: const Text('Choose a Challenge'),
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
                    title: const Text('Temp Game_01'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChallengePageTemp()),
                        
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Speed Challenge'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Game_02_speed()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('KM Challenge'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Game_04_km(title: "3 km Challenge",
                                                      description: "Your challenge is to walk for 3 kilometers in a row.")),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('One Hour Challenge'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Game_03_time()),
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
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                
                const SizedBox(height: 10),
                Flexible(flex: 10000, child: Expanded( child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      challegeButton(0, user, gameProvider, context),
                      const SizedBox(height: 20),
                      challegeButton(1, user, gameProvider, context),
                      const SizedBox(height: 20),
                      challegeButton(2, user, gameProvider, context),
                    ],
                  ),
                ),
                ),
                ),
                const SizedBox(height: 10),
                Flexible(flex: 0,
                child: Text(
                  'ID: ${user.uniqueNumber.toString().padLeft(6, '0')}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}



// 'ID: ${snapshot.data!.uniqueNumber.toString().padLeft(6, '0')}'