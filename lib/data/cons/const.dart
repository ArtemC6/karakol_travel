import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screen/fragment_screen/comment_screen.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destinaiton, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destinaiton);
      return ref.putFile(file);
    } on FirebaseException catch (_) {
      return null;
    }
  }
}

const black_93 = Color(0xFF161616);
const black_86 = Color(0xFF222327);

class FadeRouteAnimation extends PageRouteBuilder {
  final Widget page;

  FadeRouteAnimation(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}

const List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];

const List<String> items = [
  'For 1 day',
  'For 3 day',
  'For 7 day',
  'For 30 day',
  'For 90 day',
];

const List<double> masonryCardHeights = [150, 230, 280];

DateTime getDataTimeDate(Timestamp startDate) {
  DateTime dateTimeStart = startDate.toDate();
  return dateTimeStart;
}

int getRandomElement(int length) {
  int randomIndex = 0;
  if (length == 1) {
    randomIndex = 0;
  } else {
    randomIndex = Random().nextInt(length);
  }
  return randomIndex;
}

void transitionSelection(
    BuildContext context, String selectedValue, String id) {
  if (selectedValue == 'For 1 day') {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  id: id,
                  time: 1,
                  selectData: selectedValue,
                )));
  } else if (selectedValue == 'For 3 day') {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  id: id,
                  time: 3,
                  selectData: selectedValue,
                )));
  } else if (selectedValue == 'For 7 day') {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  id: id,
                  time: 7,
                  selectData: selectedValue,
                )));
  } else if (selectedValue == 'For 30 day') {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  id: id,
                  time: 30,
                  selectData: selectedValue,
                )));
  } else if (selectedValue == 'For 90 day') {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  id: id,
                  time: 90,
                  selectData: selectedValue,
                )));
  }
}
