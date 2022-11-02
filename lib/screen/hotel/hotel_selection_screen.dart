import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/generated/locale_keys.g.dart';
import 'package:karakol_travel/screen/home_screen.dart';
import 'package:karakol_travel/screen/hotel/hotel_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/const/const.dart';
import '../../model/RestaurantModel.dart';

class HotelSelectionScreen extends StatefulWidget {
  const HotelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HotelSelectionScreen> createState() => _HotelSelectionScreen();
}

class _HotelSelectionScreen extends State<HotelSelectionScreen> {
  bool isVisible = false;
  List<RestaurantModel> listRestaurantBest = [],
      listRestaurantBestPosition = [];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Hotel')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listRestaurantBestPosition.add(RestaurantModel(
              location_lat: data['location_lat'],
              location_lng: data['location_lng'],
              welcome_message: data['welcome_message'],
              position: data['position'],
              name: data['name'],
              id: data['id'],
              location: data['location'],
              rating: data['rating'],
              photo_main: data['photo']));
        });
      });
    });

    setState(() {
      isVisible = true;
      sortingElement();
    });
  }

  void sortingElement() {
    for (int i = 0; i < 100; i++) {
      for (var element in listRestaurantBestPosition) {
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
      }
    }
  }

  void getElementBest(RestaurantModel element, int index) {
    if (element.position == index && listRestaurantBest.length == index) {
      listRestaurantBest.add(element);
    }
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return AnimationLimiter(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(right: 20, left: 20, bottom: 60, top: 10),
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 450),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 2200),
                  verticalOffset: 120,
                  curve: Curves.ease,
                  child: FadeInAnimation(
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 2200),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(HotelScreen(
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
                                      progressIndicatorBuilder: (context, url,
                                              progress) =>
                                          Center(
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 0.8,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                      imageUrl: list[index].photo_main,
                                      fit: BoxFit.cover,
                                      height: 240,
                                      width: MediaQuery.of(context).size.width),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 4, top: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: list[index].name,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
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
                                            RichText(
                                              text: TextSpan(
                                                text: list[index].location,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 11.5,
                                                      color: Colors.white70,
                                                      letterSpacing: .7),
                                                ),
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
                                                  unratedColor: Colors.white30,
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
                                                RichText(
                                                  text: TextSpan(
                                                    text:
                                                        '  ${list[index].rating.toString()} ${LocaleKeys.rating_lc.tr()}',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 11.0,
                                                              color: Colors
                                                                  .white70,
                                                              letterSpacing:
                                                                  .9),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    LocaleKeys.book_now_lc.tr(),
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 11.0,
                                                      color: Colors.blueAccent,
                                                      letterSpacing: .9),
                                                ),
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
            }));
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
        body: RefreshIndicator(
          backgroundColor: black_86,
          color: Colors.blueAccent,
          onRefresh: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HotelSelectionScreen()));
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 40),
              child: restaurant(listRestaurantBest),
            ),
          ),
        ),
      ),
    );
  }
}
