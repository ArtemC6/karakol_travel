import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/RestaurantModel.dart';
import 'package:karakol_travel/data/model/StartingDataModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  List<StartingDataModel> listMenu = [
    StartingDataModel(
        name: 'Breakfast',
        image_uri:
            'https://proprikol.ru/wp-content/uploads/2020/06/kartinki-zavtrak-39.jpg'),
    StartingDataModel(
        name: 'Lunch',
        image_uri:
            'https://podacha-blud.com/uploads/posts/2022-06/1654220582_10-podacha-blud-com-p-krasivii-obed-foto-11.jpg'),
    StartingDataModel(
        name: 'Dinner',
        image_uri:
            'https://get.pxhere.com/photo/food-meal-meat-chicken-dinner-vege'
            'table-dish-fried-potato-cooking-cooked-vegetables-roasted-lunch-'
            'pan-baked-salad-potatoes-healthy-pork-plate-tomato-cuisine-grilled-onion-produce-'
            'ingredient-garden-salad-tableware-recipe-kitchen-utensil-whole-food-leaf-vegetable-cutlery-root'
            '-vegetable-dishware-local-food-natural-foods-chicken-meat-vegan-nutrition-pear-fork-veget'
            'arian-food-kitchen-knife-bowl-side-dish-garnish-staple-food-Food-group-superfood-I'
            'ceburg-lettuce-herb-greek-food-greek-salad-brunch-cruciferous-vegetables-knife-cucu'
            'mber-pakistani-cuisine-1634384.jpg'),
    StartingDataModel(
        name: 'Coffee',
        image_uri:
            'https://u.9111s.ru/uploads/202109/02/7cf39d5512b533c63838f1ff218c235a.jpg'),
    StartingDataModel(
        name: 'Healthy Eating',
        image_uri:
            'https://pic.rutubelist.ru/video/e3/71/e3718791b86f28adab510b41770da490.jpg'),
    StartingDataModel(
        name: 'Beverages',
        image_uri:
            'https://i.artfile.ru/2560x1706_1119894_[www.ArtFile.ru].jpg'),
  ];

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
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        )
        .toList();

    void showMenu({required BuildContext context}) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: black_86,
            body: SizedBox(
              // height: MediaQuery.of(context).size.height / 2.2,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: listMenu.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 250),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2000),
                        verticalOffset: 100,
                        curve: Curves.ease,
                        child: FadeInAnimation(
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 2000),
                          child: Container(
                            color: black_86,
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 8, right: 8),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 6,
                            child: Card(
                              color: black_86,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.white10,
                                  )),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: listMenu[index].image_uri,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: black_86,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black26),
                                    child: Text(
                                      '${listMenu[index].name}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ));
      }));
    }

    Widget restaurant_screen() {
      return Scaffold(
        backgroundColor: black_86,
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
                  color: black_86,
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
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
                              color: Colors.white.withOpacity(0.10),
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
                              color: Colors.white.withOpacity(0.10),
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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              'Free',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              '9 AM - 7 PM',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showMenu(context: context);
                          },
                          child: Text(
                            'Menu',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 16, top: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reviews',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            Text(
                              'View All',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(
                          // height: MediaQuery.of(context).size.height / 2.2,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: listComment.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 250),
                                  child: SlideAnimation(
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    verticalOffset: 100,
                                    curve: Curves.ease,
                                    child: FadeInAnimation(
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 14),
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child: SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 0.8,
                                                    value: progress.progress,
                                                  ),
                                                ),
                                              ),
                                              imageUrl: listComment[index]
                                                  .photo_profile,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
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
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            RatingBarIndicator(
                                                              unratedColor:
                                                                  Colors
                                                                      .white30,
                                                              rating:
                                                                  listComment[
                                                                          index]
                                                                      .rating,
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              // itemCount: 5,
                                                              itemSize: 18,
                                                              direction: Axis
                                                                  .horizontal,
                                                            ),
                                                            Text(
                                                              ' ${listComment[index].dateTime.day.toString()} '
                                                              '${months[listComment[index].dateTime.month - 1]} '
                                                              ' ${listComment[index].dateTime.year.toString()}  ',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white
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
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.7,
                                                    child: Text(
                                                      softWrap: true,
                                                      textAlign:
                                                          TextAlign.start,
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
                            ),
                          ),
                        ),
                      ],
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
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          size: 44,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
