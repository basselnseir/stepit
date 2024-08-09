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

1) Game: Includes all data per game. Like: id; title; description; level; type;
2) User: Includes all data per user. Like: username; uniqueNumber; gameType; level; joinedTime.
3) PipModeNotifier: This class is responsible for entering PIP mode throghout the application.