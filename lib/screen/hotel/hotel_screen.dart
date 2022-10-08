import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../data/model/HotelModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:telegram/telegram.dart';
import '../../data/model/OperatorModel.dart';
import 'dart:io';

import '../restaurant/menu_screen.dart';

class HotelScreen extends StatefulWidget {
  var id;

  HotelScreen({Key? key, @required this.id}) : super(key: key);

  @override
  _HotelScreen createState() => _HotelScreen(id);
}

class _HotelScreen extends State<HotelScreen> {
  var id;

  _HotelScreen(this.id);

  bool isVisible = false, isOperatorExist = false;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  List<HotelModel> listHotel = [], listHotelSimilar = [];
  List<String> imgList = [], imaListMenu = [];
  List<OperatorModel> listOperator = [];
  String _phoneInfo = '';

  void readFirebase() async {
    listHotel = [];
    listHotelSimilar = [];
    await FirebaseFirestore.instance
        .collection('Hotel')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data['id'] == id) {
          setState(() {
            imgList = new List<String>.from(document['images']);
            imaListMenu = new List<String>.from(document['menu']);
            listHotel.add(HotelModel(
                name: data['name'],
                category: data['category'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          });
        }

        if (data['id'] != id) {
          if (data['category'] == listHotel[0].category) {
            listHotelSimilar.add(HotelModel(
                name: data['name'],
                category: data['category'],
                id: data['id'],
                location: data['location'],
                rating: data['rating'],
                price: data['price'],
                photo_main: data['photo']));
          }
        }
      });
    });

    setState(() {
      isVisible = true;
    });

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      _phoneInfo = 'Android $release, $manufacturer $model';
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      _phoneInfo = '$systemName $version, $name $model';
    }
  }

  readFirebaseOperator() async {
    listOperator = [];
    await FirebaseFirestore.instance
        .collection('Operator')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        if (data['dataEnd'] == '') {
          setState(() {
            listOperator.add(OperatorModel(
                name: data['name'],
                telegram: data['telegram'],
                whitsApp: data['whistApp'],
                phone: data['phone'],
                uid: data['uid'],
                dataStart: data['dataStart'],
                dataEnd: Timestamp.now(),
                id: data['id']));
            isOperatorExist = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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

    Widget dialNumber(BuildContext context, List<OperatorModel> list) {
      if (list.length >= 1) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {},
                      child: Text('Connect with us ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                letterSpacing: .8),
                          )))),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.green, width: 0.5)))),
                  onPressed: () async {
                    final docCall = await FirebaseFirestore.instance
                        .collection('Call')
                        .doc();
                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'call',
                    };
                    docCall.set(json).then((value) {
                      FlutterPhoneDirectCaller.callNumber(
                          list[randomIndex].phone);
                      Navigator.pop(context);
                    });
                  },
                  icon: Image.asset(
                    'images/karakol/ic_phone.png',
                    height: 65,
                    width: 65,
                  ),
                  label: Text(
                    'Call the phone               ',
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
              Container(
                // alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10),
                width: size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.green, width: 0.5)))),
                  onPressed: () async {
                    final docCall = await FirebaseFirestore.instance
                        .collection('Call')
                        .doc();
                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'whatsApp',
                    };
                    docCall.set(json);
                    Navigator.pop(context);

                    bool whatsapp =
                        await FlutterLaunch.hasApp(name: "whatsapp");
                    if (whatsapp) {
                      await FlutterLaunch.launchWhatsapp(
                          phone: list[randomIndex].whitsApp, message: "Hello");
                    }
                  },
                  icon: Image.asset(
                    'images/karakol/ic_whatsapp.png',
                    height: 60,
                    width: 60,
                  ),
                  label: Text(
                    'Contact via Whatsapp',
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.blueAccent, width: 0.5)))),
                  onPressed: () async {
                    final docCall = await FirebaseFirestore.instance
                        .collection('Call')
                        .doc();
                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'telegram',
                    };
                    docCall.set(json).then((value) {
                      Telegram.send(
                        username: list[randomIndex].telegram,
                        message: 'Hello',
                      );
                      Navigator.pop(context);
                    });
                  },
                  icon: Image.asset(
                    'images/karakol/ic_telegram.png',
                    height: 65,
                    width: 65,
                  ),
                  label: Text(
                    'Contact via Telegram',
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
            ],
          ),
        ));
      }

      return Container(
          width: size.width,
          height: 60,
          margin: EdgeInsets.all(40),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side:
                            BorderSide(color: Colors.blueAccent, width: 0.7)))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Попрубуйте позже',
              style: TextStyle(fontSize: 20),
            ),
          ));
    }

    Widget restaurant_screen() {
      return Scaffold(
        backgroundColor: black_86,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: size.height / 3.2,
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
                  height: size.height / 2,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              listHotel[0].name,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    letterSpacing: .9),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: size.width / 2,
                                  child: Text(
                                    '${listHotel[0].location}',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.9),
                                          letterSpacing: .8),
                                    ),
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
                            margin: const EdgeInsets.only(
                                left: 10, right: 6, top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4, top: 10, right: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await readFirebaseOperator();
                                showCupertinoModalBottomSheet(
                                  topRadius: Radius.circular(30),
                                  duration: Duration(milliseconds: 700),
                                  backgroundColor: black_86,
                                  context: context,
                                  builder: (context) =>
                                      dialNumber(context, listOperator),
                                );
                              },
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    letterSpacing: .8),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 2),
                                  child: Text(
                                    '${listHotel[0].price.toString()} сом',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: .8),
                                    ),
                                  ))
                            ],
                          ),
                          Padding(padding: const EdgeInsets.only(left: 14)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'Rating',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        letterSpacing: .8),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${listHotel[0].rating.toString()} ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        RatingBarIndicator(
                                          unratedColor: Colors.white30,
                                          rating: listHotel[0].rating,
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
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (imaListMenu.length != 0) {
                            Navigator.push(
                                context,
                                FadeRouteAnimation(MenuScreen(
                                  listMenu: imaListMenu,
                                )));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: const Icon(
                                  Icons.menu_book,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                              Text(
                                'Catalog',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: .8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 24, top: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white10),
                            child: Text(
                              'Reviews',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    letterSpacing: .8),
                              ),
                            ),
                          ),
                          Text(
                            'View All',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueAccent,
                                  letterSpacing: .8),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(milliseconds: 300),
                                child: SlideAnimation(
                                  duration: const Duration(milliseconds: 1500),
                                  horizontalOffset: 100,
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
                                                              top: 4,
                                                              bottom: 4),
                                                      child: Row(
                                                        children: [
                                                          RatingBarIndicator(
                                                            unratedColor:
                                                                Colors.white30,
                                                            rating: listComment[
                                                                    index]
                                                                .rating,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            // itemCount: 5,
                                                            itemSize: 18,
                                                            direction:
                                                                Axis.horizontal,
                                                          ),
                                                          Text(
                                                            ' ${listComment[index].dateTime.day.toString()} '
                                                            '${months[listComment[index].dateTime.month - 1]} '
                                                            ' ${listComment[index].dateTime.year.toString()}  ',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      .8),
                                                            ),
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.7,
                                                  child: Text(
                                                    softWrap: true,
                                                    textAlign: TextAlign.start,
                                                    '${listComment[index].comment}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: .8),
                                                    ),
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
                if (listHotelSimilar.length != 0)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 14),
                    child: Text(
                      'Похожие отели',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: .8),
                      ),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: AnimationLimiter(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: listHotelSimilar.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2000),
                              horizontalOffset: 140,
                              curve: Curves.ease,
                              child: FadeInAnimation(
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 2000),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        FadeRouteAnimation(HotelScreen(
                                          id: listHotelSimilar[index].id,
                                        )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    margin: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Center(
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
                                            imageUrl: listHotelSimilar[index]
                                                .photo_main,
                                            fit: BoxFit.cover,
                                            /* height: size.height / 4.5,
                                                    width: size.width*/
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: RatingBarIndicator(
                                                unratedColor: Colors.white30,
                                                rating: listHotelSimilar[index]
                                                    .rating,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                // itemCount: 5,
                                                itemSize: 13,
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, right: 4, top: 4),
                                              child: Text(
                                                "${listHotelSimilar[index].price.toString()} сом",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      letterSpacing: .9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4, top: 4),
                                          child: Text(
                                            listHotelSimilar[index].name,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: .9),
                                            ),
                                          ),
                                        ),
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
              ],
            ),
          ),
        ),
      );
    }

    if (isVisible) {
      if (listHotel.length != 0) {
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
