import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:karakol_travel/screen/home_screen.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_screen.dart';
import '../../data/const.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/model/HotelModel.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  List<RestaurantModel> listRestaurant = [];
  List<RestaurantModel> listRestaurantRevers = [];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listRestaurantRevers.add(RestaurantModel(
              name: data['name'],
              id: data['id'],
              location: data['location'],
              rating: data['rating'],
              price: data['price'],
              photo_main: data['photo']));
        });
      });
    });

    setState(() {
      listRestaurant = listRestaurantRevers.reversed.toList();

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

  Widget hotelBest() {
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
              itemCount: listRestaurant.length,
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
                      duration: Duration(milliseconds: 2000),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(RestaurantScreen(
                                id: listRestaurant[index].id,
                              )));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: black_86,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                                    imageUrl: listRestaurant[index].photo_main,
                                    fit: BoxFit.cover,
                                    height: 230,
                                    width: MediaQuery.of(context).size.width),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 4, top: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            listRestaurant[index].name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white
                                                    .withOpacity(0.9)),
                                          ),
                                          Text(
                                            '${listRestaurant[index].price.toDouble().toString()} сом',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white
                                                    .withOpacity(1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            size: 15,
                                          ),
                                          Text(
                                            '  ${listRestaurant[index].location}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withOpacity(0.7)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            children: [
                                              RatingBarIndicator(
                                                unratedColor: Colors.white30,

                                                rating: listRestaurant[index]
                                                    .rating,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                // itemCount: 5,
                                                itemSize: 15,
                                                direction: Axis.horizontal,
                                              ),
                                              Text(
                                                '  ${listRestaurant[index].rating.toString()} Ratings',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.7)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: const Text(
                                            'Book now',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
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
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color: black_86,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    const Tab(
                      text: 'Best',
                    ),
                    const Tab(
                      text: 'Medium',
                    ),
                    const Tab(
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
                    hotelBest(),
                    hotelBest(),
                    hotelBest(),
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
