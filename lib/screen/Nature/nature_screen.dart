import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../data/const/const.dart';

class NatureScreen extends StatefulWidget {
  List<String> listImage = [];

  NatureScreen({Key? key, required this.listImage}) : super(key: key);

  @override
  State<NatureScreen> createState() => _NatureScreen(listImage);
}

class _NatureScreen extends State<NatureScreen> {
  List<String> listStartingDataNature = [];

  _NatureScreen(this.listStartingDataNature);

  late FixedExtentScrollController controller;
  bool isVisible = false;

  void listenScroll() {
    setState(() {});
  }

  void readFirebase() async {
    setState(() {
      isVisible = true;
    });
  }

  @override
  void initState() {
    controller = FixedExtentScrollController();
    Future.delayed(const Duration(milliseconds: 1750), () {
      controller.animateToItem(controller.selectedItem + 1,
          duration: const Duration(milliseconds: 1300),
          // curve: Curves.decelerate);
          curve: Curves.easeInOut);
    });

    readFirebase();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: AnimationLimiter(
                child: AnimationConfiguration.staggeredList(
                    position: 1,
                    delay: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2000),
                      horizontalOffset: 100,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2500),
                        child: Center(
                          child: ListWheelScrollView.useDelegate(
                            controller: controller,
                            physics: const FixedExtentScrollPhysics(),
                            // perspective: 0.003,
                            diameterRatio: 2.2,
                            squeeze: 1.0,
                            itemExtent: 250,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: listStartingDataNature.length,
                                builder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Card(
                                      shadowColor: Colors.white30,
                                      color: black_86,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: const BorderSide(
                                            width: 0.8,
                                            color: Colors.white54,
                                          )),
                                      elevation: 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                            progressIndicatorBuilder: (context,
                                                    url, progress) =>
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
                                            imageUrl:
                                                listStartingDataNature[index],
                                            fit: BoxFit.cover,
                                            height: 240,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    )),
              ),
            )));
  }
}
