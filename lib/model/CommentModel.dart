import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id = "";
  String id_company = "";
  String id_devise = "";
  String name = "";
  late Timestamp dateTime;
  String comment = "";
  double rating = 0.0;
  String photo_profile = "";

  CommentModel(
      {required this.name,
      required this.id,
      required this.dateTime,
      required this.id_company,
      required this.id_devise,
      required this.photo_profile,
      required this.rating,
      required this.comment});
}
