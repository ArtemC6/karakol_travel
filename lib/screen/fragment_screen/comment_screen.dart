// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karakol_travel/data/model/CommentModel.dart';
import '../../data/cons/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';

class CommentScreen extends StatefulWidget {
  var id, time, selectData;

  CommentScreen(
      {Key? key,
      @required this.id,
      @required this.time,
      @required this.selectData})
      : super(key: key);

  @override
  State<CommentScreen> createState() =>
      _CommentScreenState(id, time, selectData);
}

class _CommentScreenState extends State<CommentScreen> {
  _CommentScreenState(this.id, this.time, this.selectData);

  var id, time = 0;
  String selectData = '';

  bool isVisible = false;
  List<CommentModel> listComment = [];
  String idDevise = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? selectedValue;

  void readFirebase() async {
    listComment = [];
    await FirebaseFirestore.instance
        .collection('Comment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (listComment.length <= 100) {
          if (data['id_company'] == id) {
            print(time);
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
              currentDate.day - time,
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

            if (time == null) {
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
          }
        }
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  void getIdDevise() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      idDevise = androidInfo.androidId!;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      idDevise = iosInfo.identifierForVendor!;
    }
  }

  @override
  void initState() {
    getIdDevise();
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget comment() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: black_86,
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: [
                    const Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        selectData ?? 'Choose time',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    transitionSelection(context, selectedValue!, id);
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.blueAccent,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonWidth: 160,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.blueAccent,
                  ),
                  color: black_86,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: black_86,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
          ],
        ),
        backgroundColor: black_86,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 16),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: listComment.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (listComment[index].id_devise == idDevise) {
                          return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: AnimationConfiguration.staggeredList(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              height: 50,
                                              width: 50,
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
                                                Text(
                                                  listComment[index].name,
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        letterSpacing: .8),
                                                  ),
                                                ),
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
                                                            '    ${getDataTimeDate(listComment[index].dateTime).day.toString()}'
                                                            ' ${months[getDataTimeDate(listComment[index].dateTime).month - 1]}'
                                                            ' ${getDataTimeDate(listComment[index].dateTime).year.toString()}  ',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle: const TextStyle(
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
                                                    listComment[index].comment,
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  .8),
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
                              ),
                              onDismissed: (direction) async {
                                final docUser = FirebaseFirestore.instance
                                    .collection('Comment')
                                    .doc(listComment[index].id);
                                docUser.delete();
                                setState(() => listComment.removeAt(index));
                              });
                        }

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 250),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 1400),
                            horizontalOffset: 100,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 2000),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
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
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listComment[index].name,
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  letterSpacing: .8),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                child: Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      unratedColor:
                                                          Colors.white30,
                                                      rating: listComment[index]
                                                          .rating,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      // itemCount: 5,
                                                      itemSize: 18,
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                    Text(
                                                      '    ${getDataTimeDate(listComment[index].dateTime).day.toString()}'
                                                      ' ${months[getDataTimeDate(listComment[index].dateTime).month - 1]}'
                                                      ' ${getDataTimeDate(listComment[index].dateTime).year.toString()}  ',
                                                      style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
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
                                                const EdgeInsets.only(top: 2),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: Text(
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              listComment[index].comment,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
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
        ),
      );
    }

    if (isVisible) {
      return comment();
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
