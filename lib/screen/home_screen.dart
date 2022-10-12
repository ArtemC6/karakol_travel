import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/StartingDataModel.dart';
import '../data/cons/const.dart';
import '../data/widget/widget_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isVisible = false, isVisibleNature = false;
  List<StartingDataModel> listStartingDataTop = [],
      listStartingDataHotel = [],
      listStartingDataFood = [];
  List<String> listStartingDataNature = [];

  List<String> listWelcomeImage = [], listWelcomeName = [];
  List<String> listHotelImage = [], listHotelName = [];
  List<String> listFoodImage = [], listFoodName = [];

  void readFirebase() async {
    FirebaseFirestore.instance
        .collection('Starting_photos_top')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        listWelcomeImage = List<String>.from(document['images_welcome']);
        listWelcomeName = List<String>.from(document['name_welcome']);
        setState(() {
          for (int i = 0; i < listWelcomeImage.length; i++) {
            listStartingDataTop.add(StartingDataModel(
                name: listWelcomeName[i], image_uri: listWelcomeImage[i]));
          }
        });
      });
    });

    FirebaseFirestore.instance
        .collection('Starting_photos_hotel')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        listHotelImage = List<String>.from(document['images_hotel']);
        listHotelName = List<String>.from(document['name_hotel']);
        setState(() {
          for (int i = 0; i < listHotelImage.length; i++) {
            listStartingDataHotel.add(StartingDataModel(
                name: listHotelName[i], image_uri: listHotelImage[i]));
          }
        });
      });
    });

    FirebaseFirestore.instance
        .collection('Starting_photos_food')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        listFoodImage = List<String>.from(document['images_food']);
        listFoodName = List<String>.from(document['name_food']);
        setState(() {
          for (int i = 0; i < listFoodImage.length; i++) {
            listStartingDataFood.add(StartingDataModel(
                name: listFoodName[i], image_uri: listFoodImage[i]));
          }
        });
      });
    });

    await FirebaseFirestore.instance
        .collection('Starting_photos_nature')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        setState(() {
          listStartingDataNature = List<String>.from(document['images']);
        });
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  void getPositionScroll() {
    _scrollController.addListener(() {
      int offset = _scrollController.offset.toInt();
      if (offset >= 150 && offset <= 170 && isVisible) {
        setState(() {
          isVisibleNature = true;
        });
      }
    });
  }

  @override
  void initState() {
    getPositionScroll();
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Widget home_screen() {
      return Scaffold(
        backgroundColor: black_86,
        body: NestedScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 220,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                backgroundColor: black_86,
                actionsIconTheme: const IconThemeData(opacity: 0.0),
                title: const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  background: slideHomeTop(listStartingDataTop),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            backgroundColor: black_86,
            color: Colors.blueAccent,
            onRefresh: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 14,
                  ),
                  sampleProductOnTap('Hotel'),
                  slideHomeMulti(listStartingDataHotel, 'Hotel'),
                  sampleProductOnTap('Food'),
                  slideHomeMulti(listStartingDataFood, 'Food'),
                  sampleProductOnTap('Nature'),
                  if (isVisibleNature) showNatureCard(listStartingDataNature),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!isVisible) {
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
    return home_screen();
  }
}
