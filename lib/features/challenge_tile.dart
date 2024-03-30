import 'package:flutter/material.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/classes/game.dart';

class ChallengePage extends StatelessWidget {
  final Game game;

  ChallengePage({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  game.description,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Game_01_steps(),
            ],),
          ),
        ),
      ),
    );
  }
}