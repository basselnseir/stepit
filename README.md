# stepit

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development Environment

Best use VSCode for developing.
1)  Clone the repository.
2)  Open it in VSCode.
3)  Press CTRL+Shift+P, and then click "Flutter: Select Device", and select the device to run the app on.
4)  In the left bar, click on "Run and Debug", and then press the "play" button above to run the app.

## Firestore

In order to store data this project uses Firestore. Here is the structure of our DB:
1) "games" collection: includes the list of all the challenges as its documents.
2) "images" collection: includes all the URLs of the pictures taken within the app.
3) "users" collection: includes the list of the users, for every one there are several sub-collections like: gameType, joinedTime, level and his steps history.

## Important Project Classes:

// location: lib/classes/game.dart
1) Game: Includes all data per game. Like: id; title; description; level; type;
    (1.1) method loadGames, it loades the games of the user from the firebase, if it is a new day it loads new 3 games for the user (3 new games that the user has not completed yet).
    it saves them in the GameProvider class that we use to update all the other wrapped pages about the games.

// location: lib/classes/user.dart
2) User: Includes all data per user. Like: username; uniqueNumber; gameType; level; joinedTime.
    (1.1) method saveUser, it saves the user detailes to the firebase, and saves the user ID to the sharedPrefernce on the phone itself.
    (1.2) method loadUser, it loads the user ID from the sharedPrefernce (the ID that is saved on the phone) to the software. it saves the user ID in the UserProvider class that we use to update all the other wrapped pages in order to use it.

3) PipModeNotifier: This class is responsible for entering PIP mode throghout the application.

// location: lib/background/steps_tracking_wm.dart
4) StepsTracker: This class is responsible for counting and tracking the user's steps. It uses the StepCounterProvider class and the imported workmanager package in order to track the steps periodically (every 15 minutes) and save it to the firebase.

// location: lib/features/step_count
5) StepCounterProvider: This class is the main channel to read the steps from the pedometer sensor that is on the phone. Every new day, it resets the reading from 0, because the pedometer sensor does not reset only when the phone is turned off, thus the reading of the pedometer gives us the number of steps we have done so far since last time we turned on the phone. Using this class, it gives us the actual number of steps for every day itself. This class is used in the StepsTracker and every challenge that uses steps.