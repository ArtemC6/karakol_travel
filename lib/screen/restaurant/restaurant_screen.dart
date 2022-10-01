import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/model/HotelModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantScreen extends StatefulWidget {
  var id;

  RestaurantScreen({Key? key, @required this.id}) : super(key: key);

  @override
  _RestaurantScreen createState() => _RestaurantScreen(id);
}

class _RestaurantScreen extends State<RestaurantScreen> {
  var id;

  _RestaurantScreen(this.id);

  bool isVisible = false;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  List<RestaurantModel> listRestaurant = [];

  List<String> imgList = [
    // 'images/karakol/hotel/ic_caragat_4.jpg',
    // 'images/karakol/hotel/ic_caragat_room_4.jpg',
    // 'images/karakol/hotel/ic_caragat_room_2.jpg',
    // 'images/karakol/hotel/ic_caragat_room_5.jpg',
  ];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        if (data['id'] == id) {
          setState(() {
            imgList = new List<String>.from(document['images']);
            listRestaurant.add(RestaurantModel(
                name: data['name'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          });
        }
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    readFirebase();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map(
          (item) => CachedNetworkImage(
            imageUrl: item,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.7,
                value: progress.progress,
              ),
            ),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        )
        .toList();

    Widget restaurant_screen() {
      return Scaffold(
        backgroundColor: black_93,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 3.2,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                titleSpacing: 0,
                backgroundColor: innerBoxIsScrolled ? black_86 : black_86,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                title: SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                  color: black_93,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Stack(
                    children: <Widget>[
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: const Duration(milliseconds: 400),
                          child: Container(
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2000),
                              horizontalOffset: 160,
                              curve: Curves.ease,
                              child: FadeInAnimation(
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 2000),
                                child: Stack(
                                  children: [
                                    CarouselSlider(
                                      items: imageSliders,
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        disableCenter: false,
                                        viewportFraction: 1,
                                        aspectRatio: 1.5,
                                        onPageChanged: (index, reason) {
                                          setState(
                                            () {
                                              _current = index;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: imgList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return Container(
                                            width: 10.0,
                                            height: 10.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 4.0),

                                            // decoration: BoxDecoration(
                                            //     border: Border.all(
                                            //       color: Colors.red,
                                            //     ),
                                            //     borderRadius: BorderRadius.all(Radius.circular(20))
                                            // ),

                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 0.8,
                                                    color: Colors.white),
                                                color: (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.white)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 1
                                                            : 0.0)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      listRestaurant[0].name,
                      style: TextStyle(
                          fontSize: 17, color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 15,
                        ),
                        Text(
                          '  ${listRestaurant[0].location}',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.white.withOpacity(1),
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                '${listRestaurant[0].price.toString()} сом',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: const EdgeInsets.only(left: 20)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                'Rating',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(1)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${listRestaurant[0].rating.toString()}  ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RatingBarIndicator(
                                        // unratedColor: Colors.black,
                                        rating: listRestaurant[0].rating,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        // itemCount: 5,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: black_86,
                                // color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Low Cost',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (isVisible) {
      if (listRestaurant.length != 0) {
        return restaurant_screen();
      }
    }
    return Scaffold(
      backgroundColor: black_86,
      body: Center(
          child: CircularProgressIndicator(
        strokeWidth: 1.5,
      )),
    );
  }
}
