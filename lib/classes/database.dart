import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:stepit/classes/objects.dart';


class DataBase {
  // a static method to add a user to firestore
 /* static Future<void> addUser(User user) async {
    FirebaseFirestore.instance.collection('users').doc(user.uniqueNumber.toString().padLeft(6, '0')).set(user.toMap());
    // Save uniqueNumber to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('uniqueNumber', user.uniqueNumber);
    prefs.setString('gameType', user.gameType);

  }

  // a static method that checks if a user with the given uniqueNumber exists
  static Future<bool> userExists(int uniqueNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueNumber', isEqualTo: uniqueNumber)
        .get();
    return result.docs.isNotEmpty;
  }

  // a static method that loads the user from firestore to the user global variable
  static Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uniqueNumber = prefs.getInt('uniqueNumber') ?? 0;
    // String gameType = prefs.getString('gameType') ?? 'Challenge';
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueNumber', isEqualTo: uniqueNumber)
        .get();
    user = User.fromMap(result.docs.first.data());
    print('!!!!! loadUser() executed, user: $user !!!!!');
  }
*/
/*static Future<void> loadGames(String url) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection('Challenges').doc(url);
  DocumentSnapshot docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    return docSnapshot;
  } else {
    //print('Document does not exist');
    return null;
  }
}*/

/* static Future<void> loadGame(DocumentSnapshot docSnapshot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await FirebaseFirestore.instance
        .collection('Challenges')
        .where(url)
        .get();
    user = User.fromMap(result.docs.first.data());
  }*/

  // a static method thatr returns the number of users in the database
  static Future<int> getNumberOfUsers() async {
    final result = await FirebaseFirestore.instance.collection('users').get();
    return result.docs.length;
  }

  // a static method that returns the user id
  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uniqueNumber = prefs.getInt('uniqueNumber') ?? 0;
    return uniqueNumber;
  }
  

}