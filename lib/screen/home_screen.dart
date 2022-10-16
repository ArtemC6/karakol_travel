import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/data/model/StartingDataModel.dart';
import '../data/const/const.dart';
import '../data/widget/widget_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import '../generated/locale_keys.g.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isVisible = false, isVisibleNature = false;
  List<StartingDataModel> listStartingDataTop = [],
      listStartingDataHotel = [],
      listStartingDataCafe = [];
  List<String> listStartingDataNature = [];
  List<String> listWelcomeImage = [], listWelcomeName = [];
  List<String> listHotelImage = [], listHotelName = [], listHotelId = [];
  List<String> listCafeImage = [], listCafeName = [], listCafeId = [];

  void readFirebase() async {
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        if (Platform.localeName.substring(0, 2) == 'ru') {
          context.setLocale(const Locale('ru'));
        } else {
          context.setLocale(const Locale('en'));
        }
      });
    });

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
                name_comapny: listWelcomeName[i],
                image_uri: listWelcomeImage[i],
                id_comapny: ''));
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
        listHotelId = List<String>.from(document['id_hotel']);
        setState(() {
          for (int i = 0; i < listHotelImage.length; i++) {
            listStartingDataHotel.add(StartingDataModel(
                name_comapny: listHotelName[i],
                image_uri: listHotelImage[i],
                id_comapny: listHotelId[i]));
          }
        });
      });
    });

    FirebaseFirestore.instance
        .collection('Starting_photos_cafe')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        listCafeImage = List<String>.from(document['images_cafe']);
        listCafeName = List<String>.from(document['name_cafe']);
        listCafeId = List<String>.from(document['id_company']);
        setState(() {
          for (int i = 0; i < listCafeImage.length; i++) {
            listStartingDataCafe.add(StartingDataModel(
                name_comapny: listCafeName[i],
                image_uri: listCafeImage[i],
                id_comapny: listCafeId[i]));
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
                  background:
                      slideHomeTop(listStartingDataTop, listStartingDataNature),
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  sampleProductOnTap(LocaleKeys.hotel_lc.tr(),
                      LocaleKeys.view_all_lc.tr(), '0', listStartingDataNature),
                  slideHomeMulti(listStartingDataHotel, 'Hotel'),
                  sampleProductOnTap(LocaleKeys.cafe_lc.tr(),
                      LocaleKeys.view_all_lc.tr(), '1', listStartingDataNature),
                  slideHomeMulti(listStartingDataCafe, 'Food'),
                  sampleProductOnTap(LocaleKeys.nature_lc.tr(),
                      LocaleKeys.view_all_lc.tr(), '2', listStartingDataNature),
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
