// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'id';

  late String _number;
  late String _id;

  String get number => _number;
  String get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    var data = snapshot.data() as Map;
    _number = data[NUMBER];
    _id = data[ID];

  }

}