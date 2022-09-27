class HotelModel {
  String id = "";
  String name = "";
  String location = "";
  double price = 0.0;
  double rating = 0.0;
  String image_uri = "";

  HotelModel(
      {required this.name,
      required this.id,
      required this.location,
      required this.rating,
      required this.image_uri,
      required this.price});
}
