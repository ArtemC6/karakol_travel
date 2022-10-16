import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:karakol_travel/generated/locale_keys.g.dart';
import 'package:karakol_travel/screen/home_screen.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/const/const.dart';

class RestaurantSelectionScreen extends StatefulWidget {
  const RestaurantSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantSelectionScreen> createState() =>
      _RestaurantSelectionScreen();
}

class _RestaurantSelectionScreen extends State<RestaurantSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isVisible = false;
  List<RestaurantModel> listRestaurantBest = [],
      listRestaurantBestPosition = [],
      listRestaurantMediumPosition = [],
      listRestaurantLowerPosition = [],
      listRestaurantMedium = [],
      listRestaurantLower = [];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          if (data['category'] == 'Best') {
            listRestaurantBestPosition.add(RestaurantModel(
                position: data['position'],
                name: data['name'],
                category: data['category'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          } else if (data['category'] == 'Medium') {
            listRestaurantMediumPosition.add(RestaurantModel(
                name: data['name'],
                category: data['category'],
                position: data['position'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          } else if (data['category'] == 'Lower') {
            listRestaurantLowerPosition.add(RestaurantModel(
                name: data['name'],
                category: data['category'],
                position: data['position'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          }
        });
      });
    });

    setState(() {
      isVisible = true;
      sortingElement();
    });
  }

  void sortingElement() {
    for (int i = 0; i < 200; i++) {
      listRestaurantBestPosition.forEach((element) {
        getElementBest(element, 0);
        getElementBest(element, 1);
        getElementBest(element, 2);
        getElementBest(element, 3);
        getElementBest(element, 4);
        getElementBest(element, 5);
        getElementBest(element, 6);
        getElementBest(element, 7);
        getElementBest(element, 8);
        getElementBest(element, 9);
        getElementBest(element, 10);
        getElementBest(element, 11);
        getElementBest(element, 12);
        getElementBest(element, 13);
        getElementBest(element, 14);
        getElementBest(element, 15);
        getElementBest(element, 16);
        getElementBest(element, 17);
        getElementBest(element, 18);
        getElementBest(element, 19);
        getElementBest(element, 20);
      });

      listRestaurantMediumPosition.forEach((element) {
        getElementMedium(element, 0);
        getElementMedium(element, 1);
        getElementMedium(element, 2);
        getElementMedium(element, 3);
        getElementMedium(element, 4);
        getElementMedium(element, 5);
        getElementMedium(element, 6);
        getElementMedium(element, 7);
        getElementMedium(element, 8);
        getElementMedium(element, 9);
        getElementMedium(element, 10);
        getElementMedium(element, 11);
        getElementMedium(element, 12);
        getElementMedium(element, 13);
        getElementMedium(element, 14);
        getElementMedium(element, 15);
        getElementMedium(element, 16);
        getElementMedium(element, 17);
        getElementMedium(element, 18);
        getElementMedium(element, 19);
        getElementMedium(element, 20);
      });

      listRestaurantLowerPosition.forEach((element) {
        getElementLower(element, 0);
        getElementLower(element, 1);
        getElementLower(element, 2);
        getElementLower(element, 3);
        getElementLower(element, 4);
        getElementLower(element, 5);
        getElementLower(element, 6);
        getElementLower(element, 7);
        getElementLower(element, 8);
        getElementLower(element, 9);
        getElementLower(element, 10);
        getElementLower(element, 11);
        getElementLower(element, 12);
        getElementLower(element, 13);
        getElementLower(element, 14);
        getElementLower(element, 15);
        getElementLower(element, 16);
        getElementLower(element, 17);
        getElementLower(element, 18);
        getElementLower(element, 19);
        getElementLower(element, 20);
      });
    }
  }

  void getElementBest(RestaurantModel element, int index) {
    if (element.position == index && listRestaurantBest.length == index) {
      listRestaurantBest.add(element);
    }
  }

  void getElementMedium(RestaurantModel element, int index) {
    if (element.position == index && listRestaurantMedium.length == index) {
      listRestaurantMedium.add(element);
    }
  }

  void getElementLower(RestaurantModel element, int index) {
    if (element.position == index && listRestaurantLower.length == index) {
      listRestaurantLower.add(element);
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    readFirebase();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget restaurant(List<RestaurantModel> list) {
    if (!isVisible) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          size: 44,
          color: Colors.blueAccent,
        ),
      );
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: AnimationLimiter(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 150, top: 10),
              scrollDirection: Axis.vertical,
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 350),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2000),
                    verticalOffset: 120,
                    curve: Curves.ease,
                    child: FadeInAnimation(
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 2000),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRouteAnimation(RestaurantScreen(
                                  id: list[index].id,
                                )));
                          },
                          child: Card(
                            shadowColor: Colors.white30,
                            color: black_86,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  width: 0.8,
                                  color: Colors.white24,
                                )),
                            elevation: 7,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: black_86,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
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
                                        imageUrl: list[index].photo_main,
                                        fit: BoxFit.cover,
                                        height: 240,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                list[index].name,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                              Text(
                                                '${list[index].price.toDouble().toString()} ${LocaleKeys.som_lc.tr()}',
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white70,
                                                size: 14,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                list[index].location,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 11.5,
                                                      color: Colors.white70,
                                                      letterSpacing: .7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, bottom: 4),
                                              child: Row(
                                                children: [
                                                  RatingBarIndicator(
                                                    unratedColor:
                                                        Colors.white30,
                                                    rating: list[index].rating,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  Text(
                                                    '  ${list[index].rating.toString()} ${LocaleKeys.rating_lc.tr()}',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 11.5,
                                                              color: Colors
                                                                  .white70,
                                                              letterSpacing:
                                                                  .9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Text(
                                                LocaleKeys.book_now_lc.tr(),
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 11.5,
                                                      color: Colors.blueAccent,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, FadeRouteAnimation(HomeScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: black_93,
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                height: 45,
                decoration: BoxDecoration(
                  color: black_93,
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.white38),
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color: black_86,
                  ),
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(LocaleKeys.restaurant_best_lc.tr(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: .9))),
                      // text: LocaleKeys.restaurant_best_lc.tr(),
                    ),
                    Tab(
                      child: Text(LocaleKeys.restaurant_medium_lc.tr(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: .9))),
                      // text: ,
                    ),
                    Tab(
                      child: Text(LocaleKeys.restaurant_lower_lc.tr(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: .9))),
                      // text: LocaleKeys.restaurant_lower_lc.tr(),
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    restaurant(listRestaurantBest),
                    restaurant(listRestaurantMedium),
                    restaurant(listRestaurantLower),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
