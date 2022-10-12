import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import '../cons/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screen/Nature/nature_screen.dart';
import '../../screen/hotel/hotel_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../model/StartingDataModel.dart';

class slideHomeTop extends StatelessWidget {
  List<StartingDataModel> listStartingDataTop = [];

  slideHomeTop(this.listStartingDataTop, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
              position: 1,
              delay: const Duration(milliseconds: 550),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2300),
                horizontalOffset: 160,
                curve: Curves.ease,
                child: FadeInAnimation(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 2000),
                  child: CarouselSlider.builder(
                      keepPage: true,
                      enableAutoSlider: true,
                      unlimitedMode: true,
                      slideBuilder: (index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(context,
                                  FadeRouteAnimation(HotelSelectionScreen()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(
                                      const RestaurantSelectionScreen()));
                            } else if (index == 2) {
                              Navigator.push(context,
                                  FadeRouteAnimation(const NatureScreen()));
                            }
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                fadeOutDuration: const Duration(seconds: 0),
                                fadeInDuration: const Duration(seconds: 0),
                                alignment: Alignment.center,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
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
                                imageUrl: listStartingDataTop[index].image_uri,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                        );
                      },
                      slideTransform: const CubeTransform(),
                      itemCount: listStartingDataTop.length),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class sampleProductOnTap extends StatelessWidget {
  late String nameProduct;

  sampleProductOnTap(this.nameProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (nameProduct == 'Hotel') {
          Navigator.push(context, FadeRouteAnimation(HotelSelectionScreen()));
        } else if (nameProduct == 'Food') {
          Navigator.push(
              context, FadeRouteAnimation(const RestaurantSelectionScreen()));
        } else if (nameProduct == 'Nature') {
          Navigator.push(context, FadeRouteAnimation(const NatureScreen()));
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 14, bottom: 22, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.white30),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white10),
              child: Row(
                children: [
                  if (nameProduct == 'Hotel')
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.home_outlined,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  if (nameProduct == 'Food')
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.fastfood_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  if (nameProduct == 'Nature')
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.nature_people_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  Text(
                    nameProduct,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 16, letterSpacing: .9),
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'View all',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 13,
                          letterSpacing: .9),
                    ),
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.blueAccent,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class slideHomeMulti extends StatelessWidget {
  List<StartingDataModel> listStartingData = [];
  String isProduct = '';

  slideHomeMulti(this.listStartingData, this.isProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: AnimationLimiter(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 20),
            scrollDirection: Axis.horizontal,
            itemCount: listStartingData.length,
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
                        if (isProduct == 'Hotel') {
                          Navigator.push(context,
                              FadeRouteAnimation(HotelSelectionScreen()));
                        } else {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(
                                  const RestaurantSelectionScreen()));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              shadowColor: Colors.white30,
                              color: black_86,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    width: 0.8,
                                    color: Colors.white30,
                                  )),
                              elevation: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                    progressIndicatorBuilder: (context, url,
                                            progress) =>
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
                                    imageUrl: listStartingData[index].image_uri,
                                    fit: BoxFit.cover,
                                    height: 174,
                                    width: MediaQuery.of(context).size.width),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 4, top: 4),
                              child: Text(
                                listStartingData[index].name,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white, letterSpacing: .9),
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
    );
  }
}

class showNatureCard extends StatelessWidget {
  List<String> list;

  showNatureCard(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, bottom: 24, right: 6),
      child: AnimationLimiter(
        child: AnimationConfiguration.staggeredList(
          position: 1,
          delay: const Duration(milliseconds: 400),
          child: SlideAnimation(
            duration: const Duration(milliseconds: 3000),
            verticalOffset: 260,
            curve: Curves.ease,
            child: FadeInAnimation(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 3500),
              child: MasonryGridView.count(
                  itemCount: list.length,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context, FadeRouteAnimation(const NatureScreen()));
                      },
                      child: SizedBox(
                        height: masonryCardHeights[index % 3],
                        child: Card(
                          shadowColor: Colors.white30,
                          color: black_86,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                width: 0.8,
                                color: Colors.white30,
                              )),
                          elevation: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
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
                              imageUrl: list[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
