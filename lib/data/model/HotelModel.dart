class HotelModel {
  String id = "";
  String name = "";
  String location = "";
  String category = "";
  var price = 0;
  double rating = 0.0;
  String photo_main = "";

  HotelModel(
      {required this.name,
      required this.id,
      required this.location,
      required this.rating,
      required this.category,
      required this.photo_main,
      required this.price});
}
