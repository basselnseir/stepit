
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/pip_mode_notifier.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/pages/status.dart';


class HomePage extends StatefulWidget {
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

    GameProvider? gameProvider = Provider.of<GameProvider>(context);

    if (gameProvider.games.isEmpty && user != null) {
      FutureBuilder(
        future: gameProvider.loadGames(user.gameType, user.level, context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text("data");
          }
        },
      );
    }

    if (user == null || gameProvider.games.isEmpty) {
      return const CircularProgressIndicator();
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
            margin:
                const EdgeInsets.only(top: 50.0), // Start the drawer 50 pixels lower
            width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width

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
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the game page
                    },
                    child: Text(gameProvider.games[0].title),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the game page
                    },
                    child: Text(gameProvider.games[1].title),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the game page
                    },
                    child: Text(gameProvider.games[3].title),
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