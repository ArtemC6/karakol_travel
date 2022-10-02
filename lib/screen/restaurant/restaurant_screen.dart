import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/model/CommentModel.dart';
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
  List<String> imgList = [];

  List<CommentModel> listComment = [
    CommentModel(
        name: '',
        dateTime: DateTime.now(),
        id: '',
        photo_profile:
            'https://cdn.vox-cdn.com/thumbor/n-V0QecZDxHqqs13ISr10aFtd6E=/0x0:1363x2048/1200x0/filters:focal(0x0:1363x2048):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/19424454/jesse_brawner_creditMarcCartwright.jpeg',
        rating: 4.5,
        comment:
            'good dfdsf dsf dsdsfdsfdsfasasdfadsf dsf dsf dsfdsffffffffff fdsssss'),
    CommentModel(
        name: '',
        id: '',
        dateTime: DateTime.now(),
        photo_profile:
            'https://lmg-labmanager.s3.amazonaws.com/assets/articleNo/23259/iImg/43114/owensjeffrey.jpg',
        rating: 4.1,
        comment: 'good fdaadsffffffdsf dsf dsf dsfdsffffffffff fdsssss'),
    CommentModel(
        name: '',
        dateTime: DateTime.now(),
        id: '',
        photo_profile:
            'https://kcballet.files.wordpress.com/2012/08/skyler-taylor.jpg',
        rating: 3.7,
        comment: 'good dfdsf dsf dsf dsf dsf dsfdsffffffffff fdsssss'),
    CommentModel(
        name: '',
        dateTime: DateTime.now(),
        id: '',
        photo_profile: 'https://starnote.ru/media/c/starnote/'
            'v2/blog/gallery/2013/10/15/6bfd5ae16f/sjurrealizm-ot-deniela-redkliffa-foto-aktera-dlja-flaunt_8.jpg',
        rating: 5.0,
        comment: 'good dfdsf dsf dsf dsf dsf dsfdsffffffffff fdsssss'),
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
                // actionsIconTheme: IconThemeData(opacity: 0.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Text(
                              listRestaurant[0].name,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white.withOpacity(0.9)),
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.7,

                                  child: Text(
                                    ' ${listRestaurant[0].location}',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.white,
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
                              child: const Text(
                                'Rating',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
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
                                        unratedColor: Colors.white30,
                                        rating: listRestaurant[0].rating,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
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
                    height: 30,
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
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
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
                                const Icon(
                                  Icons.wine_bar_rounded,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Bar',
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
                                const Icon(
                                  Icons.car_repair_outlined,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Parking',
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
                                const Icon(
                                  Icons.wifi,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Free WiFi',
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: AnimationLimiter(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(right: 20),
                        scrollDirection: Axis.vertical,
                        itemCount: listComment.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2000),
                              verticalOffset: 100,
                              curve: Curves.ease,
                              child: FadeInAnimation(
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 2000),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Center(
                                            child: SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 0.8,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                          imageUrl:
                                              listComment[index].photo_profile,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      RatingBarIndicator(
                                                        unratedColor:
                                                            Colors.white30,
                                                        rating:
                                                            listComment[index]
                                                                .rating,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        // itemCount: 5,
                                                        itemSize: 20,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                      Text(
                                                        ' ${listComment[index].dateTime.day.toString()} '
                                                        '${months[listComment[index].dateTime.month - 1]} '
                                                        ' ${listComment[index].dateTime.year.toString()}  ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                              child: Text(
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                '${listComment[index].comment}',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.white30,
                          );
                        },
                      ),
                    ),
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
      body: const Center(
          child: CircularProgressIndicator(
        strokeWidth: 1.5,
      )),
    );
  }
}
