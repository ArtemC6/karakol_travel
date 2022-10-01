class RestaurantModel {
  String id = "";
  String name = "";
  String location = "";
  int price = 0;
  double rating = 0.0;
  String photo_main = "";


  RestaurantModel(
      {required this.name,
      required this.id,
      required this.location,
      required this.rating,
      required this.photo_main,
      required this.price});
}
