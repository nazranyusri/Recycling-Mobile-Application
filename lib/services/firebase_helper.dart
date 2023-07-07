import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<bool> isEmailAlreadyRegistered(String email) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }
}
