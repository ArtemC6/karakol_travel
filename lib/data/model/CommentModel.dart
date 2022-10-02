class CommentModel {
  String id = "";
  String name = "";
  late DateTime dateTime;
  String comment = "";
  double rating = 0.0;
  String photo_profile = "";

  CommentModel(
      {required this.name,
      required this.id,
      required this.dateTime,
      required this.photo_profile,
      required this.rating,
      required this.comment});
}
