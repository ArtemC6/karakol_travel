// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:karakol_travel/data/model/CommentModel.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:karakol_travel/screen/fragment_screen/menu_screen.dart';
// import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../data/const/const.dart';
// import '../../data/model/OperatorModel.dart';
// import '../../data/model/RestaurantModel.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// // import 'package:latlong2/latlong/Circle.dart';
// // import 'package:latlong2/latlong/Distance.dart';
// // import 'package:latlong2/latlong/LatLng.dart';
// // import 'package:latlong2/latlong/LengthUnit.dart';
// // import 'package:latlong2/latlong/Path.dart';
// // import 'package:latlong2/latlong/calculator/Haversine.dart';
// // import 'package:latlong2/latlong/calculator/Vincenty.dart';
// // import 'package:latlong2/latlong/interfaces.dart';
// import 'package:latlong2/spline.dart';
// // import 'package:latlong2/spline/CatmullRomSpline.dart';
//
// class MapScreen extends StatefulWidget {
//   var id;
//
//   MapScreen({Key? key, @required this.id}) : super(key: key);
//
//   @override
//   _MapScreen createState() => _MapScreen(id);
// }
//
// class _MapScreen extends State<MapScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String id;
//
//   _MapScreen(this.id);
//
//   bool isVisible = false, isOperatorExist = false;
//   final CarouselController _controller = CarouselController();
//   int _current = 0;
//   List<RestaurantModel> listRestaurant = [], listRestaurantSimilar = [];
//   List<String> imgList = [], imaListMenu = [];
//   List<OperatorModel> listOperator = [];
//   List<CommentModel> listComment = [];
//
//   void readFirebase() async {
//     listRestaurant = [];
//     listRestaurantSimilar = [];
//
//     await FirebaseFirestore.instance
//         .collection('Restaurant')
//         .doc(id)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         Map<String, dynamic> data =
//             documentSnapshot.data() as Map<String, dynamic>;
//         if (data['id'] == id) {
//           setState(() {
//             imgList = List<String>.from(data['images']);
//             imaListMenu = List<String>.from(data['menu']);
//             listRestaurant.add(RestaurantModel(
//                 welcome_message: data['welcome_message'],
//                 position: data['position'],
//                 name: data['name'],
//                 id: data['id'],
//                 location: data['location'],
//                 rating: data['rating'],
//                 photo_main: data['photo']));
//           });
//         }
//       }
//     });
//
//     FirebaseFirestore.instance
//         .collection('Restaurant')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((document) async {
//         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//         if (listRestaurant.isNotEmpty) {
//           if (data['id'] != id) {
//             print(data['name']);
//
//             setState(() {
//               listRestaurantSimilar.add(RestaurantModel(
//                   welcome_message: data['welcome_message'],
//                   position: data['position'],
//                   name: data['name'],
//                   id: data['id'],
//                   location: data['location'],
//                   rating: data['rating'],
//                   photo_main: data['photo']));
//             });
//           }
//         }
//       });
//     });
//
//     await FirebaseFirestore.instance
//         .collection('Comment')
//         .limit(20)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((document) async {
//         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//         if (data['id_company'] == id) {
//           final Timestamp timestampStart = data['date'] as Timestamp;
//           final DateTime dateTimeStart = timestampStart.toDate();
//
//           var timeStart = DateTime(
//             dateTimeStart.year,
//             dateTimeStart.month,
//             dateTimeStart.day,
//           );
//
//           DateTime currentDate = DateTime.now();
//           var currentTimeDay = DateTime(
//             currentDate.year,
//             currentDate.month,
//             currentDate.day - 7,
//           );
//
//           DateTime start = currentTimeDay;
//           DateTime end = timeStart;
//
//           start = start.subtract(const Duration(seconds: 1));
//           end = end.add(const Duration(days: 1));
//           end = end.subtract(const Duration(seconds: 1));
//
//           if (timeStart.isAfter(start) && timeStart.isBefore(end)) {
//             setState(() {
//               listComment.add(CommentModel(
//                 name: data['name'],
//                 id_devise: data['id_devise'],
//                 id: data['id'],
//                 rating: data['rating'],
//                 dateTime: data['date'],
//                 id_company: data['id_company'],
//                 photo_profile: data['photo'],
//                 comment: data['comment'],
//               ));
//             });
//           }
//         }
//       });
//     });
//
//     setState(() {
//       isVisible = true;
//     });
//   }
//
//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     readFirebase();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> imageSliders = imgList
//         .map(
//           (item) => InkWell(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             onTap: () {
//               if (imgList.isNotEmpty) {
//                 Navigator.push(
//                     context,
//                     FadeRouteAnimation(MenuScreen(
//                       listMenu: imgList,
//                     )));
//               }
//             },
//             child: CachedNetworkImage(
//               imageUrl: item,
//               progressIndicatorBuilder: (context, url, progress) => Center(
//                 child: SizedBox(
//                   height: 30,
//                   width: 30,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 0.8,
//                     value: progress.progress,
//                   ),
//                 ),
//               ),
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//         )
//         .toList();
//
//     // ignore: non_constant_identifier_names
//     Widget restaurant_screen() {
//       return Scaffold(
//           backgroundColor: black_86,
//           body: FlutterMap(
//             options: MapOptions(
//               center: LatLng(42.49005609257469, 42.49005609257469),
//               // zoom: 13.0,
//             ),
//             layers: [
//               TileLayerOptions(
//                 urlTemplate:
//                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 subdomains: ['a', 'b', 'c'],
//                 //
//               ),
//               // MarkerLayerOptions(
//               //   markers: [
//               //     Marker(
//               //       width: 80.0,
//               //       height: 80.0,
//               //       point: LatLng(51.5, -0.09),
//               //       builder: (ctx) =>
//               //           Container(
//               //             child: FlutterLogo(),
//               //           ),
//               //     ),
//               //   ],
//               // ),
//             ],
//           ));
//     }
//
//     if (isVisible) {
//       if (listRestaurant.isNotEmpty) {
//         return restaurant_screen();
//       }
//     }
//     return Scaffold(
//         backgroundColor: black_86,
//         body: Center(
//           child: LoadingAnimationWidget.fourRotatingDots(
//             size: 44,
//             color: Colors.blueAccent,
//           ),
//         ));
//   }
// }
