import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorModel {
  String id = "";
  String uid = "";
  String name = "";
  String telegram = "";
  String whitsApp = "";
  String phone = "";
  Timestamp dataStart;
  Timestamp dataEnd;

  OperatorModel({
    required this.name,
    required this.telegram,
    required this.whitsApp,
    required this.phone,
    required this.uid,
    required this.dataStart,
    required this.dataEnd,
    required this.id,
  });
}
