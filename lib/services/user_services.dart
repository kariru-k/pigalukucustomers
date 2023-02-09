import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{
  String collection = 'users';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //Create new User
  Future<void> createUserData(Map<String, dynamic>values) async{
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  //Update user data
  Future<void>updateUserData(Map<String, dynamic>values) async {
    String? id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  //Get data by user Id

  Future<DocumentSnapshot>getUserById(String id) async {

    var result = await _firestore.collection(collection).doc(id).get();

    return result;
    }
  }
