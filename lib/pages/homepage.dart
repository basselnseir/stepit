import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/challenges/game_02_speed.dart';
import 'package:stepit/challenges/game_03_time.dart';
import 'package:stepit/challenges/game_04_km.dart';
import 'package:stepit/challenges/game_05_steps.dart';
import 'package:stepit/challenges/game_06_speed.dart';
import 'package:stepit/challenges/game_07_time.dart';
import 'package:stepit/challenges/game_08_km.dart';
import 'package:stepit/challenges/game_09_steps.dart';
import 'package:stepit/challenges/game_10_speed.dart';
import 'package:stepit/challenges/game_11_time.dart';
import 'package:stepit/challenges/game_12_km.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/picture_challenge.dart';
import 'package:stepit/pages/status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool inPausedState = false;

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
    final pipModeNotifier =
        Provider.of<PipModeNotifier>(context, listen: false);
    pipModeNotifier.floating.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    final pipModeNotifier =
        Provider.of<PipModeNotifier>(context, listen: false);
    if (lifecycleState == AppLifecycleState.inactive) {
      if (inPausedState) {
        inPausedState = false;
        return;
      }
      print('App is in inactive state!!!');
      pipModeNotifier.enablePip(context);
      pipModeNotifier.inPipMode = true;
    }
    if (lifecycleState == AppLifecycleState.resumed &&
        pipModeNotifier.inPipMode) {
      if (inPausedState) {
        inPausedState = false;
      }
      setState(() {
        pipModeNotifier.inPipMode = false;
      });
    }
    if (lifecycleState == AppLifecycleState.paused) {
      print('App is in background!!!');
      inPausedState = true;
    }
  }

  Card challegeButton(int button_index, user, gameProvider, context) {
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
            if (game.id == 'game_01') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_01_steps(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_02') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_02_speed(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_03') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_03_time(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_04') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_04_km(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_05') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_05_steps(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_06') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_06_speed(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_07') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_07_time(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_08') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_08_km(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_09') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_09_steps(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_10') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_10_speed(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_11') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_11_time(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            } else if (game.id == 'game_12') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Game_12_km(gameID: game.id, userID: user.uniqueNumber),
                ),
              );
            }
          }
        },
        child: Container(
          //height: 220,
          height: MediaQuery.of(context).size.height *
              0.25, // Adjust the height as needed
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Flexible(
                  Text(
                    gameProvider.games[button_index].title,
                    style: const TextStyle(
                      fontSize: 20.0, // Adjust the font size as needed
                      fontFamily: 'Roboto', // Change to your preferred font
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                  // ),
                  // SizedBox(
                  //     height:
                  //         10), // Add some space between the title and the description
                  Flexible(
                    child: Text(
                      gameProvider.games[button_index]
                          .description, // Replace with your description
                      style: const TextStyle(
                        fontSize: 16.0, // Adjust the font size as needed
                        fontFamily: 'Roboto', // Change to your preferred font
                      ),
                      overflow: TextOverflow.ellipsis, // Handle overflow
                      maxLines: 10, // Adjust the number of lines as needed
                    ),
                  ),
                  // Expanded(
                  //   child:
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double iconSize = MediaQuery.of(context).size.width *
                              0.2; // Adjust the icon size based on screen width
                          return Image.asset(
                            Game.getGameIcon(gameProvider.games[button_index]
                                .title), // Replace with your image path
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  //  ),
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
    final pipModeNotifier =
        Provider.of<PipModeNotifier>(context, listen: false);

    if (pipModeNotifier.inPipMode) {
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
          pipModeNotifier.inPipMode =
              true; // Assuming this is how you trigger PiP mode
          return pipModeNotifier.enablePip(
              context); // Prevents the app from exiting or going back
        },
        child: FutureBuilder<User?>(
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
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(user!);
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
          pipModeNotifier.inPipMode =
              true; // Assuming this is how you trigger PiP mode
          return pipModeNotifier.enablePip(
              context); // Prevents the app from exiting or going back
        },
        child: FutureBuilder(
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
          pipModeNotifier.inPipMode =
              true; // Assuming this is how you trigger PiP mode
          return pipModeNotifier.enablePip(
              context); // Prevents the app from exiting or going back
        },
        child: const Center(
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
          pipModeNotifier.inPipMode =
              true; // Assuming this is how you trigger PiP mode
          return pipModeNotifier.enablePip(
              context); // Prevents the app from exiting or going back
        },
        child: Scaffold(
          appBar: AppBar(
            // leading: Builder(
            //   builder: (BuildContext context) {
            //     return IconButton(
            //       icon: const Icon(Icons.menu),
            //       onPressed: () => Scaffold.of(context).openDrawer(),
            //     );
            //   },
            // ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('Choose a Challenge'),
          ),
          // drawer: Drawer(
          //   backgroundColor: const Color.fromARGB(255, 184, 239, 186),
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 50.0),
          //     width: MediaQuery.of(context).size.width * 0.8,
          //     color: Colors.white,
          //     child: ListView(
          //       padding: EdgeInsets.zero,
          //       children: <Widget>[
          //         // ListTile(
          //         //   title: const Text('Log'),
          //         //   onTap: () {
          //         //     Navigator.push(
          //         //       context,
          //         //       MaterialPageRoute(builder: (context) => StatusPage()),
          //         //     );
          //         //   },
          //         // ),
          //         // ListTile(
          //         //   title: const Text('Test Challenge'),
          //         //   onTap: () {
          //         //     Navigator.push(
          //         //       context,
          //         //       MaterialPageRoute(
          //         //           builder: (context) => Game_01_steps(gameID: 'game_01', userID: user!.uniqueNumber)),
          //         //     );
          //         //   },
          //         // ),
          //       /*  ListTile(
          //           title: const Text('Game_01'),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => Game_01_steps()),
          //             );
          //           },
          //         ),
          //         ListTile(
          //           title: const Text('Speed Challenge'),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => Game_02_speed()),
          //             );
          //           },
          //         ),
          //         ListTile(
          //           title: const Text('KM Challenge'),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const Game_04_km()),
          //             );
          //           },
          //         ),
          //         ListTile(
          //           title: const Text('One Hour Challenge'),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => Game_03_time()),
          //             );
          //           },
          //         ),*/
          //         // ListTile(
          //         //   title: Text('PiP mode'),
          //         //   onTap: () async {
          //         //     enablePip(context);
          //         //     inPipMode = true;
          //         //   },
          //         // ),
          //         // Add more ListTiles for more pages
          //       ],
          //     ),
          //   ),
          // ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                const SizedBox(height: 10),
                Flexible(
                  flex: 10000,
                  child: Expanded(
                    child: SingleChildScrollView(
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
                Flexible(
                  flex: 0,
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
