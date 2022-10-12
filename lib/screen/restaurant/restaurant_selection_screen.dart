import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:karakol_travel/screen/home_screen.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_screen.dart';
import '../../data/cons/const.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';

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
            setState(() {
              listRestaurantBest.add(RestaurantModel(
                  name: data['name'],
                  category: data['category'],
                  id: data['id'],
                  location: data['location'],
                  rating: data['rating'],
                  price: data['price'],
                  photo_main: data['photo']));
            });
          } else if (data['category'] == 'Medium') {
            listRestaurantMedium.add(RestaurantModel(
                name: data['name'],
                category: data['category'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          } else if (data['category'] == 'Lower') {
            listRestaurantLower.add(RestaurantModel(
                name: data['name'],
                category: data['category'],
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
    });
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
                                        height: 230,
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
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                              Text(
                                                '${list[index].price.toDouble().toString()} сом',
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white70,
                                                size: 15,
                                              ),
                                              Text(
                                                '  ${list[index].location}',
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
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
                                                    '  ${list[index].rating.toString()} Ratings',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 12,
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
                                                'Book now',
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13,
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
                    border: Border.all(width: 0.5, color: Colors.white30),
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color: black_86,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(
                      text: 'Best',
                    ),
                    Tab(
                      text: 'Medium',
                    ),
                    Tab(
                      text: 'Lower',
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
