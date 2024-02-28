import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/database.dart';
import 'package:stepit/features/globals.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    DataBase.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final double screenWidth = MediaQuery.of(context).size.width;
        const double tileWidth = 210.0; // Assuming each tile has a width of 200.0
        const double padding = 8.0; // Assuming padding around each tile is 8.0
        final double targetOffset = tileWidth + 2 * padding + tileWidth / 2 - screenWidth / 2;

        _scrollController.animateTo(
          targetOffset,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 1000),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('StepIT'),
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
                style: TextStyle(fontSize: 30,),
              ),
            ),
            const SizedBox(height: 70),
            Container(
              height: 200,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      child: Card(
                        child: Center(child: Text('Tile ${index + 1}')),
                      ),
                    ),
                  );
                },
              ),
            ),
              
            Text(
              'ID: $user.uniqueNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'Level: 1',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}