import 'dart:ui';

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

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
