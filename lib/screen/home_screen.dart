import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/addPhoto.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import '../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/model/RestaurantModel.dart';
import '../data/model/HotelModel.dart';
import '../data/model/RelaxationModel.dart';
import '../data/model/StartingPhotoModel.dart';
import '../data/model/widget.dart';
import 'hotel/hotel_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'myTest.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isVisible = false;
  String uri = '';
  List<StartingPhotoModel> listStartingDataTop = [],
      listStartingDataHotel = [],
      listStartingDataFood = [],
      listStartingDataRelaxation = [];

  List<RelaxationModel> listRelaxation = [
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_mountains_2.jpg',
        name: 'Pilaf',
        price: '800 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_like_2.jpg',
        name: 'Pilaf',
        price: '800 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_like_alakyl_2.jpg',
        name: 'Legs',
        price: '500 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_summer_mountains.jpg',
        name: 'Manti',
        price: '150 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_story.jpg',
        name: 'Manti',
        price: '150 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_skiing.jpg',
        name: 'Lagman',
        price: '200 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_winter_mountains.jpg',
        name: 'Manti',
        price: '150 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_story_2.jpg',
        name: 'Lagman',
        price: '200 сом'),
    RelaxationModel(
        id: '',
        image_uri: 'images/karakol/relaxation/ic_like_leto.jpg',
        name: 'Manti',
        price: '150 сом'),
  ];

  int _current = 0;

  void readFirebase() async {
    FirebaseFirestore.instance
        .collection('Starting_photos_top')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listStartingDataTop.add(StartingPhotoModel(
              name: data['name_1'], image_uri: data['image_1']));
          listStartingDataTop.add(StartingPhotoModel(
              name: data['name_2'], image_uri: data['image_2']));
          listStartingDataTop.add(StartingPhotoModel(
              name: data['name_3'], image_uri: data['image_3']));
        });
      });
    });

    FirebaseFirestore.instance
        .collection('Starting_photos_hotel')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listStartingDataHotel.add(StartingPhotoModel(
              name: data['name_1'], image_uri: data['image_1']));

          listStartingDataHotel.add(StartingPhotoModel(
              name: data['name_2'], image_uri: data['image_2']));

          listStartingDataHotel.add(StartingPhotoModel(
              name: data['name_3'], image_uri: data['image_3']));

          listStartingDataHotel.add(StartingPhotoModel(
              name: data['name_4'], image_uri: data['image_4']));

          listStartingDataHotel.add(StartingPhotoModel(
              name: data['name_5'], image_uri: data['image_5']));
        });
      });
    });

    await FirebaseFirestore.instance
        .collection('Starting_photos_food')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listStartingDataFood.add(StartingPhotoModel(
              name: data['name_1'], image_uri: data['image_1']));
          listStartingDataFood.add(StartingPhotoModel(
              name: data['name_2'], image_uri: data['image_2']));
          listStartingDataFood.add(StartingPhotoModel(
              name: data['name_3'], image_uri: data['image_3']));
          listStartingDataFood.add(StartingPhotoModel(
              name: data['name_4'], image_uri: data['image_4']));
          listStartingDataFood.add(StartingPhotoModel(
              name: data['name_5'], image_uri: data['image_5']));
        });
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
    var size = MediaQuery.of(context).size;
    List<Widget> imageSliders = listStartingDataTop
        .map(
          (item) => InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPhoto()));
            },
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  fadeOutDuration: const Duration(seconds: 0),
                  fadeInDuration: const Duration(seconds: 0),
                  alignment: Alignment.center,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 0.7,
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: item.image_uri,
                  fit: BoxFit.cover,
                  width: size.width,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20, left: 20),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'googlesansebold',
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    Widget home_screen() {
      return Scaffold(
        backgroundColor: black_86,
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 3.8,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                // pinned: true,
                titleSpacing: 0,
                backgroundColor: black_86,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                title: const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: Duration(milliseconds: 500),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 2200),
                            horizontalOffset: 160,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: Duration(milliseconds: 2200),
                              child: CarouselSlider(
                                items: imageSliders,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  disableCenter: false,
                                  viewportFraction: 1,
                                  // aspectRatio: 1.6,
                                  onPageChanged: (index, reason) {
                                    setState(
                                      () {
                                        _current = index;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            color: black_86,
            onRefresh: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  sampleProductOnTap('Hotel'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: AnimationLimiter(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: listStartingDataHotel.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                duration: const Duration(milliseconds: 2000),
                                horizontalOffset: 140,
                                curve: Curves.ease,
                                child: FadeInAnimation(
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 2000),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          FadeRouteAnimation(
                                              HotelSelectionScreen()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 0.7,
                                                            value: progress
                                                                .progress,
                                                          ),
                                                        ),
                                                imageUrl:
                                                    listStartingDataHotel[index]
                                                        .image_uri,
                                                fit: BoxFit.cover,
                                                height: size.height / 4.8,
                                                width: size.width),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, right: 4, top: 10),
                                            child: Text(
                                              listStartingDataHotel[index].name,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  sampleProductOnTap('Food'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: AnimationLimiter(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: listStartingDataFood.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                duration: const Duration(milliseconds: 2000),
                                horizontalOffset: 140,
                                curve: Curves.ease,
                                child: FadeInAnimation(
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 2000),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          FadeRouteAnimation(
                                              RestaurantSelectionScreen()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 0.7,
                                                            value: progress
                                                                .progress,
                                                          ),
                                                        ),
                                                imageUrl:
                                                    listStartingDataFood[index]
                                                        .image_uri,
                                                fit: BoxFit.cover,
                                                height: size.height / 4.8,
                                                width: size.width),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, right: 4, top: 10),
                                            child: Text(
                                              listStartingDataFood[index].name,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  sampleProductOnTap('Nature'),
                  showNatureCard(listRelaxation),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!isVisible) {
      return Scaffold(
        backgroundColor: black_86,
        body: Center(
            child: CircularProgressIndicator(
          strokeWidth: 1.5,
        )),
      );
    }
    return home_screen();
  }
}
