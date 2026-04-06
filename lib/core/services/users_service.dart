import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService {
    final _db = FirebaseFirestore.instance;

    Future<Map<String, dynamic>?> getUser(String uid) async{
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    }
}