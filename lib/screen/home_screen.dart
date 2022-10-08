import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/Nature/nature_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import '../data/const.dart';
import '../data/model/StartingPhotoModel.dart';
import '../data/model/widget.dart';
import 'hotel/hotel_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = false, isVisibleNature = false;
  List<StartingPhotoModel> listStartingDataTop = [],
      listStartingDataHotel = [],
      listStartingDataFood = [];
  List<String> listStartingDataNature = [];

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

    FirebaseFirestore.instance
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

    await FirebaseFirestore.instance
        .collection('Starting_photos_nature')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listStartingDataNature = new List<String>.from(document['images']);
        });
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  void getPositionScroll() {
    _scrollController.addListener(() {
      int offset = _scrollController.offset.toInt();
      print(offset);
      if (offset >= 150 && offset <= 180 && isVisible) {
        setState(() {
          isVisibleNature = true;
        });
      }
    });
  }

  @override
  void initState() {
    getPositionScroll();
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget home_screen() {
      return Scaffold(
        backgroundColor: black_86,
        body: NestedScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 3.5,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                backgroundColor: black_86,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                title: const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        child: AnimationLimiter(
                          child: AnimationConfiguration.staggeredList(
                            position: 1,
                            delay: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2200),
                              horizontalOffset: 160,
                              curve: Curves.ease,
                              child: FadeInAnimation(
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 1800),
                                child: CarouselSlider.builder(
                                    keepPage: true,
                                    enableAutoSlider: true,
                                    unlimitedMode: true,
                                    slideBuilder: (index) {
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          if (index == 0) {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    HotelSelectionScreen()));
                                          } else if (index == 1) {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    RestaurantSelectionScreen()));
                                          } else if (index == 2) {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    NatureScreen()));
                                          }
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CachedNetworkImage(
                                              fadeOutDuration:
                                                  const Duration(seconds: 0),
                                              fadeInDuration:
                                                  const Duration(seconds: 0),
                                              alignment: Alignment.center,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 0.8,
                                                    value: progress.progress,
                                                  ),
                                                ),
                                              ),
                                              imageUrl:
                                                  listStartingDataTop[index]
                                                      .image_uri,
                                              // fit: BoxFit.fill,
                                              fit: BoxFit.cover,
                                              width: size.width,
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Text(
                                                  listStartingDataTop[index]
                                                      .name,
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.black12,
                                                    fontFamily:
                                                        'googleFontBold',
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    slideTransform: CubeTransform(),
                                    itemCount: listStartingDataTop.length),
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
                  const SizedBox(
                    height: 14,
                  ),
                  sampleProductOnTap('Hotel'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.6,
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
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 0.8,
                                                              value: progress
                                                                  .progress,
                                                            ),
                                                          ),
                                                        ),
                                                imageUrl:
                                                    listStartingDataHotel[index]
                                                        .image_uri,
                                                fit: BoxFit.cover,
                                                height: size.height / 4.5,
                                                width: size.width),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, right: 4, top: 10),
                                            child: Text(
                                              // lato
                                              // rubik
                                              // alegreyaSans
                                              // sourceCodePro
                                              listStartingDataHotel[index].name,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: .9),
                                              ),
                                            ),
                                          ),
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
                    height: MediaQuery.of(context).size.height / 3.7,
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
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 0.8,
                                                              value: progress
                                                                  .progress,
                                                            ),
                                                          ),
                                                        ),
                                                imageUrl:
                                                    listStartingDataFood[index]
                                                        .image_uri,
                                                fit: BoxFit.cover,
                                                height: size.height / 4.5,
                                                width: size.width),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, right: 4, top: 10),
                                            child: Text(
                                              listStartingDataFood[index].name,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: .9),
                                              ),
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
                  if (isVisibleNature) showNatureCard(listStartingDataNature),
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
          child: LoadingAnimationWidget.fourRotatingDots(
            size: 44,
            color: Colors.blueAccent,
          ),
        ),
      );
    }
    return home_screen();
  }
}
