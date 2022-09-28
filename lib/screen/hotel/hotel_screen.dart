import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../dashboards/model/HotelModel.dart';
import '../../dashboards/utils/flutter_rating_bar.dart';
import '../../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'hotel_selection_screen.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreen createState() => _HotelScreen();
}

class _HotelScreen extends State<HotelScreen> {
  bool isVisible = false;
  final CarouselController _controller = CarouselController();

  int _current = 0;

  List<HotelModel> listHotel = [
    HotelModel(
        rating: 4.0,
        location: 'Abdrakhmanov house 89A',
        id: '',
        image_uri: 'images/karakol/hotel/ic_caragat.jpg',
        name: 'Caragat',
        price: 4000),
  ];

  List<String> imgList = [
    'images/karakol/hotel/ic_caragat_4.jpg',
    'images/karakol/hotel/ic_caragat_room_4.jpg',
    'images/karakol/hotel/ic_caragat_room_2.jpg',
    'images/karakol/hotel/ic_caragat_room_5.jpg',
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  item,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: black_93,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 3.2,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              titleSpacing: 0,
              backgroundColor: innerBoxIsScrolled ? black_86 : black_86,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                // height: 200,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                color: black_93,
                height: MediaQuery.of(context).size.height / 2,
                child: Stack(
                  children: <Widget>[
                    if (isVisible)
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: Duration(milliseconds: 500),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 2500),
                            horizontalOffset: 160,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: Duration(milliseconds: 2500),
                              child: Container(
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
                                      padding: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: imgList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 10.0,
                                              height: 10.0,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black)
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 1
                                                              : 0.4)),
                                            ),
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
          child: Container(
            padding: EdgeInsets.only(top: 4, left: 14, right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(),
                  child: Text(
                    listHotel[0].name,
                    style: TextStyle(
                        fontSize: 17, color: Colors.white.withOpacity(0.9)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.7),
                        size: 15,
                      ),
                      Text(
                        '  ${listHotel[0].location}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.white.withOpacity(1),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: Text(
                              '${listHotel[0].price.toString()} сом',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: 20)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 8),
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
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      '${listHotel[0].rating.toString()}  ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    RatingBarIndicator(
                                      rating: listHotel[0].rating,
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
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
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
}
