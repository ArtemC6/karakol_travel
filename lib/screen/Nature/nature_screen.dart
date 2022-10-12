import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/cons/const.dart';

class NatureScreen extends StatefulWidget {
  const NatureScreen({Key? key}) : super(key: key);

  @override
  State<NatureScreen> createState() => _NatureScreen();
}

class _NatureScreen extends State<NatureScreen> {
  bool _isPlaying = false;
  bool isVisible = false;
  List<String> listStartingDataNature = [];
  final pageController = PageController(viewportFraction: 0.8);
  double page = 0.0;

  void listenScroll() {
    setState(() {
      page = pageController.page!;
    });
  }

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Starting_photos_nature')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          listStartingDataNature = new List<String>.from(document['images']);
        });
      });
    });

    setState(() {
      isVisible = true;
    });
  }

  @override
  void initState() {
    pageController.addListener(listenScroll);
    readFirebase();
    super.initState();
  }

  @override
  void dispose() {
    pageController.removeListener(listenScroll);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> imageSliders = listStartingDataTop
    //     .map(
    //       (item) => InkWell(
    //         splashColor: Colors.transparent,
    //         highlightColor: Colors.transparent,
    //         onTap: () {
    //           // Navigator.push(
    //           //     context, MaterialPageRoute(builder: (context) => AddPhoto()));
    //         },
    //         child: Stack(
    //           children: <Widget>[
    //             CachedNetworkImage(
    //               fadeOutDuration: const Duration(seconds: 0),
    //               fadeInDuration: const Duration(seconds: 0),
    //               alignment: Alignment.center,
    //               progressIndicatorBuilder: (context, url, progress) => Center(
    //                 child: SizedBox(
    //                   height: 30,
    //                   width: 30,
    //                   child: CircularProgressIndicator(
    //                     color: Colors.white,
    //                     strokeWidth: 0.8,
    //                     value: progress.progress,
    //                   ),
    //                 ),
    //               ),
    //               imageUrl: item.image_uri,
    //               fit: BoxFit.cover,
    //               width: size.width,
    //             ),
    //             Container(
    //               padding: const EdgeInsets.only(bottom: 20, left: 20),
    //               alignment: Alignment.bottomLeft,
    //               child: Text(
    //                 item.name,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 20.0,
    //                   fontWeight: FontWeight.bold,
    //                   fontFamily: 'googlesansebold',
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     )
    //     .toList();

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
    return Scaffold(
        backgroundColor: black_86,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: PageView.builder(
                controller: pageController,
                itemCount: listStartingDataNature.length,
                itemBuilder: (context, index) {
                  final percent = (page - index).abs().clamp(0.0, 1.0);
                  final factor = pageController.position.userScrollDirection ==
                          ScrollDirection.forward
                      ? 1.0
                      : -1.0;
                  final opacity = percent.clamp(0.0, 0.7);
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(vector.radians(45 * factor * percent)),
                    child: Opacity(
                      opacity: (1 - opacity),
                      child: Card(
                        child: CachedNetworkImage(
                          imageUrl: listStartingDataNature[index],
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
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
                          // width: MediaQuery.of(context).size.width,
                        ),

                        // child: Image.network(
                        //   listStartingDataNature[index],
                        //   // index.isOdd
                        //   //     ? "assets/second.jpg"
                        //   //     : "assets/first.jpg",
                        //
                        //   fit: BoxFit.fill,
                        //   height: 230,
                        //   width: double.infinity,
                        // ),
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
// class ListView7 extends StatefulWidget {
//   const ListView7({Key? key}) : super(key: key);
//
//   @override
//   _ListView7State createState() => _ListView7State();
// }
//
// class _ListView7State extends State<ListView7> {
//
//
//
// }
