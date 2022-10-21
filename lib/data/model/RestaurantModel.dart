class RestaurantModel {
  String id = "";
  String name = "";
  String welcome_message = "";
  String location = "";
  double rating = 0.0;
  int position = 0;
  String photo_main = "";
  String location_lat = "";
  String location_lng = "";

  RestaurantModel({
    required this.name,
    required this.id,
    required this.location,
    required this.position,
    required this.rating,
    required this.photo_main,
    required this.welcome_message,
    required this.location_lat,
    required this.location_lng,
  });
}
