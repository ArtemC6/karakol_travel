import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:karakol_travel/data/model/CommentModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:karakol_travel/screen/fragment_screen/menu_screen.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/const/const.dart';
import '../../data/model/OperatorModel.dart';
import '../../data/model/RestaurantModel.dart';
import '../../data/widget/widget_component.dart';
import '../../data/widget/widget_slide.dart';
import '../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantScreen extends StatefulWidget {
  String id;

  RestaurantScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RestaurantScreen createState() => _RestaurantScreen(id);
}

class _RestaurantScreen extends State<RestaurantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String id;

  _RestaurantScreen(this.id);

  bool isVisible = false, isOperatorExist = false;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  List<RestaurantModel> listRestaurant = [], listRestaurantSimilar = [];
  List<String> imgList = [], imaListMenu = [];
  List<OperatorModel> listOperator = [];
  List<CommentModel> listComment = [];

  void readFirebase() async {
    listRestaurant = [];
    listRestaurantSimilar = [];

    await FirebaseFirestore.instance
        .collection('Restaurant')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (data['id'] == id) {
          setState(() {
            imgList = List<String>.from(data['images']);
            imaListMenu = List<String>.from(data['menu']);
            listRestaurant.add(RestaurantModel(
                welcome_message: data['welcome_message'],
                position: data['position'],
                name: data['name'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                photo_main: data['photo']));
          });
        }
      }
    });

    FirebaseFirestore.instance
        .collection('Restaurant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (listRestaurant.isNotEmpty) {
          if (data['id'] != id) {
            print(data['name']);

            setState(() {
              listRestaurantSimilar.add(RestaurantModel(
                  welcome_message: data['welcome_message'],
                  position: data['position'],
                  name: data['name'],
                  id: data['id'],
                  location: data['location'],
                  rating: data['rating'],
                  photo_main: data['photo']));
            });
          }
        }
      });
    });

    await FirebaseFirestore.instance
        .collection('Comment')
        .limit(20)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data['id_company'] == id) {
          final Timestamp timestampStart = data['date'] as Timestamp;
          final DateTime dateTimeStart = timestampStart.toDate();

          var timeStart = DateTime(
            dateTimeStart.year,
            dateTimeStart.month,
            dateTimeStart.day,
          );

          DateTime currentDate = DateTime.now();
          var currentTimeDay = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day - 7,
          );

          DateTime start = currentTimeDay;
          DateTime end = timeStart;

          start = start.subtract(const Duration(seconds: 1));
          end = end.add(const Duration(days: 1));
          end = end.subtract(const Duration(seconds: 1));

          if (timeStart.isAfter(start) && timeStart.isBefore(end)) {
            setState(() {
              listComment.add(CommentModel(
                name: data['name'],
                id_devise: data['id_devise'],
                id: data['id'],
                rating: data['rating'],
                dateTime: data['date'],
                id_company: data['id_company'],
                photo_profile: data['photo'],
                comment: data['comment'],
              ));
            });
          }
        }
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map(
          (item) => InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (imgList.isNotEmpty) {
                Navigator.push(
                    context,
                    FadeRouteAnimation(MenuScreen(
                      listMenu: imgList,
                    )));
              }
            },
            child: CachedNetworkImage(
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
          ),
        )
        .toList();

    // ignore: non_constant_identifier_names
    Widget restaurant_screen() {
      return Scaffold(
        backgroundColor: black_86,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 210,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                titleSpacing: 0,
                backgroundColor: innerBoxIsScrolled ? black_86 : black_86,
                title: const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                  color: black_86,
                  child: Stack(
                    children: <Widget>[
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 2000),
                            horizontalOffset: 160,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 2000),
                              child: Stack(
                                // fit: StackFit.loose,
                                children: [
                                  CarouselSlider(
                                    items: imageSliders,
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      disableCenter: false,
                                      viewportFraction: 1,
                                      aspectRatio: 1.7,
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
                                    padding: const EdgeInsets.only(bottom: 12),
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          imgList.asMap().entries.map((entry) {
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
                    ],
                  ),
                )),
              ),
            ];
          },
          body: RefreshIndicator(
            // edgeOffset: 64,

            backgroundColor: black_86,
            color: Colors.blueAccent,
            onRefresh: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantScreen(id: id)));
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  companyComponent_1(listRestaurant),
                  companyComponent_2(listRestaurant, imaListMenu, 'Restaurant'),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 34, left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          height: 45,
                          decoration: BoxDecoration(
                            // border:
                            //     Border.all(width: 0.5, color: Colors.white24),
                            color: black_86,
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: TabBar(
                            indicatorColor: Colors.red,
                            controller: _tabController,
                            indicator: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              color: Colors.white10,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.blueAccent,
                            tabs: [
                              Tab(
                                child: RichText(
                                  text: TextSpan(
                                    text: LocaleKeys.reviews_lc.tr(),
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          letterSpacing: .8),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: RichText(
                                  text: TextSpan(
                                    text: LocaleKeys.gallery_lc.tr(),
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          letterSpacing: .8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // tab bar view here
                        SizedBox(
                          height: 434,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              companyComponentComment(listComment, id),
                              companyComponentGallery(imaListMenu, imgList),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (listRestaurantSimilar.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 20, left: 14, top: 16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 0.5, color: Colors.white30),
                              color: Colors.white10),
                          child: RichText(
                            text: TextSpan(
                              text: LocaleKeys.is_similar_restaurant_lc.tr(),
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    letterSpacing: .8),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRouteAnimation(
                                    const RestaurantSelectionScreen()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 14, right: 20),
                            padding: const EdgeInsets.all(8),
                            child: RichText(
                              text: TextSpan(
                                text: LocaleKeys.see_all_lc.tr(),
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.blueAccent,
                                      letterSpacing: .8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (listRestaurantSimilar.isNotEmpty)
                    companyComponentSimilar(
                        listRestaurantSimilar, 'Restaurant'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (isVisible) {
      if (listRestaurant.isNotEmpty) {
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
        ));
  }
}
