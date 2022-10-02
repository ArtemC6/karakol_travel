import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/home_screen.dart';
import '../../data/const.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/model/HotelModel.dart';
import 'hotel_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/addPhoto.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelSelectionScreen extends StatefulWidget {
  const HotelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HotelSelectionScreen> createState() => _HotelSelectionScreenState();
}

class _HotelSelectionScreenState extends State<HotelSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isVisible = false;

  List<HotelModel> listHotel = [];
  List<HotelModel> listHotelRevers = [];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Hotel')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          if (data['name'] == 'Karagat') {
            listHotelRevers.add(HotelModel(
                name: data['name'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          } else {
            listHotelRevers.add(HotelModel(
                name: data['name'],
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
      listHotel = listHotelRevers.reversed.toList();
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
          child: CircularProgressIndicator(
        strokeWidth: 1.5,
      ));
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
              itemCount: listHotel.length,
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
                              FadeRouteAnimation(HotelScreen(
                                id: listHotel[index].id,
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
                                    imageUrl: listHotel[index].photo_main,
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
                                            listHotel[index].name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white
                                                    .withOpacity(0.9)),
                                          ),
                                          Text(
                                            '${listHotel[index].price.toDouble().toString()} сом',
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
                                            '  ${listHotel[index].location}',
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
                                                rating: listHotel[index].rating,
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
                                                '  ${listHotel[index].rating.toString()} Ratings',
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
                                          child: Text(
                                            'Book now',
                                            style: TextStyle(
                                              color: Colors.lightBlue
                                                  .withOpacity(0.8),
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
