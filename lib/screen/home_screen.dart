import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:karakol_travel/dashboards/model/FoodModel.dart';
import 'package:karakol_travel/dashboards/model/RelaxationModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../dashboards/model/HotelModel.dart';
import '../dashboards/utils/DbColors.dart';
import '../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'hotel/hotel_selection_screen.dart';
import 'myTest.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isVisible = false;

  List<HotelModel> listHotel = [
    HotelModel(
        id: '',
        location: '',
        rating: 0.0,
        image_uri: 'images/karakol/hotel/ic_ski_paradise.png',
        name: 'SkiParadise',
        price: 5000),
    HotelModel(
        id: '',
        rating: 0.0,
        location: '',
        image_uri: 'images/karakol/hotel/ic_madanur.jpg',
        name: 'Madanur',
        price: 3000),
    HotelModel(
        rating: 0.0,
        id: '',
        location: '',
        image_uri: 'images/karakol/hotel/ic_kapris.jpg',
        name: 'Kapriz',
        price: 7000),
    HotelModel(
        rating: 0.0,
        id: '',
        location: '',
        image_uri: 'images/karakol/hotel/ic_caragat_4.jpg',
        name: 'Caragat',
        price: 4000),
  ];

  List<FoodModel> listFood = [
    FoodModel(
        id: '',
        image_uri: 'images/karakol/food/ic_pilaf.jpg',
        name: 'Pilaf',
        price: '800 сом'),
    FoodModel(
        id: '',
        image_uri: 'images/karakol/food/ic_dish_2.jpg',
        name: 'Legs',
        price: '500 сом'),
    FoodModel(
        id: '',
        image_uri: 'images/karakol/food/ic_dish.jpeg',
        name: 'Lagman',
        price: '200 сом'),
    FoodModel(
        id: '',
        image_uri: 'images/karakol/food/ic_manti.jpg',
        name: 'Manti',
        price: '150 сом'),
  ];

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

  List<double> masonryCardHeights = [150, 200, 270];
  int _current = 0;

  List<String> imgList = [
    'images/karakol/hotel/ic_ski_paradise.png',
    'images/karakol/food/ic_dish_3.jpg',
    'images/karakol/relaxation/ic_sources.jpg'
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 400), () {
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
                if (imgList.indexOf(item) == 0)
                  Container(
                    // color: Colors.black38,
                    padding: EdgeInsets.only(bottom: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Hotel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'googlesansebold',
                      ),
                    ),
                  ),
                if (imgList.indexOf(item) == 1)
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Food',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'googlesansebold'),
                    ),
                  ),
                if (imgList.indexOf(item) == 2)
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Relaxation',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'googlesansebold'),
                    ),
                  ),
              ],
            ),
          ),
        )
        .toList();

    Widget buildImageCard(int index) => Container(
          height: masonryCardHeights[index % 2],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              listRelaxation[index].image_uri,
              fit: BoxFit.cover,
            ),
          ),
        );

    return Scaffold(
      backgroundColor: black_86,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 3.5,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              // pinned: true,

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
                color: black_86,
                height: MediaQuery.of(context).size.height / 2,
                child: Stack(
                  children: <Widget>[
                    if (isVisible)
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: Duration(milliseconds: 500),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 2100),
                            horizontalOffset: 180,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: Duration(milliseconds: 2500),
                              child: Container(
                                child: Column(
                                  children: [
                                    CarouselSlider(
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
        body: RefreshIndicator(
          color: black_86,
          onRefresh: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (isVisible)
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HotelSelectionScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 20, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Housing',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontFamily: 'googlesansebold',
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'View all',
                                    style: primaryTextStyle(
                                        size: 14,
                                        color: Colors.white.withOpacity(0.7))),
                                WidgetSpan(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                if (isVisible)
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: AnimationLimiter(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: listHotel.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: Duration(milliseconds: 400),
                              child: SlideAnimation(
                                duration: Duration(milliseconds: 2000),
                                horizontalOffset: 140,
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
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HotelSelectionScreen()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      margin: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                                listHotel[index].image_uri,
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.8,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, right: 4, top: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  listHotel[index].name,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white
                                                          .withOpacity(0.7)),
                                                ),
                                                // style: primaryTextStyle(
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
                if (isVisible)
                  Container(
                    padding: EdgeInsets.only(
                        top: 4, bottom: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Food',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontFamily: 'googlesansebold',
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'View all',
                                  style: primaryTextStyle(
                                      size: 14,
                                      color: Colors.white.withOpacity(0.7))),
                              WidgetSpan(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                if (isVisible)
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: AnimationLimiter(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: listFood.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: Duration(milliseconds: 400),
                              child: SlideAnimation(
                                duration: Duration(milliseconds: 2000),
                                horizontalOffset: 140,
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
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyWidget()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      margin: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                                listFood[index].image_uri,
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.8,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, right: 4, top: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  listFood[index].name,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white
                                                          .withOpacity(0.7)),
                                                ),
                                                // style: primaryTextStyle(
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
                if (isVisible)
                  Container(
                    padding: EdgeInsets.only(
                        top: 4, bottom: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Nature',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontFamily: 'googlesansebold',
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'View all',
                                  style: primaryTextStyle(
                                      size: 14,
                                      color: Colors.white.withOpacity(0.7))),
                              WidgetSpan(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                if (isVisible)
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        bottom: MediaQuery.of(context).size.height / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: MasonryGridView.count(
                        itemCount: listRelaxation.length,
                        mainAxisSpacing: 22,
                        crossAxisSpacing: 22,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        itemBuilder: (BuildContext context, int index) =>
                            buildImageCard(index)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeStatusColor(Color color) async {
    setStatusBarColor(color);
  }
}

class Db3Slider extends StatelessWidget {
  final String img, heading, subheading;

  Db3Slider(
      {Key? key,
      required this.img,
      required this.heading,
      required this.subheading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(img, fit: BoxFit.cover)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(heading,
                    style: primaryTextStyle(color: db3_white, size: 24),
                    maxLines: 2),
                SizedBox(height: 4),
                Text(subheading,
                    style: primaryTextStyle(color: db3_white), maxLines: 2),
                SizedBox(height: 8),
              ],
            ),
          ),
        )
      ],
    );
  }
}
