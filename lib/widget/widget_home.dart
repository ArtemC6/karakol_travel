import 'package:flutter/material.dart';
import 'package:karakol_travel/screen/hotel/hotel_screen.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screen/Nature/nature_screen.dart';
import '../../screen/hotel/hotel_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../../screen/restaurant/restaurant_screen.dart';
import '../data/const/const.dart';
import '../model/StartingDataModel.dart';

class slideHomeTop extends StatelessWidget {
  List<StartingDataModel> listStartingDataTop = [];
  List<String> listNature = [];

  slideHomeTop(this.listStartingDataTop, this.listNature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
              position: 1,
              delay: const Duration(milliseconds: 250),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 3200),
                horizontalOffset: 250,
                curve: Curves.ease,
                child: FadeInAnimation(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 3500),
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
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(
                                      const HotelSelectionScreen()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(
                                      const RestaurantSelectionScreen()));
                            } else if (index == 2) {
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(NatureScreen(
                                    listImage: listNature,
                                  )));
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

class sampleProductOnTap extends StatefulWidget {
  late String nameProduct, view, position;
  List<String> listNature = [];

  sampleProductOnTap(
      this.nameProduct, this.view, this.position, this.listNature,
      {super.key});

  @override
  State<sampleProductOnTap> createState() =>
      _sampleProductOnTapState(nameProduct, view, position);
}

class _sampleProductOnTapState extends State<sampleProductOnTap> {
  late String nameProduct, view, position;
  List<String> listNature = [];

  _sampleProductOnTapState(String nameProduct, String view, String position);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimationLimiter(
        child: AnimationConfiguration.staggeredList(
          position: 1,
          delay: const Duration(milliseconds: 250),
          child: SlideAnimation(
            duration: const Duration(milliseconds: 2200),
            horizontalOffset: 120,
            curve: Curves.ease,
            child: FadeInAnimation(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 1700),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (widget.position == '0') {
                      Navigator.push(context,
                          FadeRouteAnimation(const HotelSelectionScreen()));
                    } else if (widget.position == '1') {
                      Navigator.push(
                          context,
                          FadeRouteAnimation(
                              const RestaurantSelectionScreen()));
                    } else if (widget.position == '2') {
                      Navigator.push(
                          context,
                          FadeRouteAnimation(NatureScreen(
                            listImage: widget.listNature,
                          )));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 14, bottom: 22, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.white38),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white12),
                          child: Row(
                            children: [
                              if (widget.position == '0')
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                ),
                              if (widget.position == '1')
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.fastfood_rounded,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                ),
                              if (widget.position == '2')
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.nature_people_outlined,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                ),
                              RichText(
                                text: TextSpan(
                                  text: widget.nameProduct,
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        letterSpacing: .9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.view,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 10.5,
                                      letterSpacing: .6),
                                ),
                              ),
                              const WidgetSpan(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.blueAccent,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
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
                delay: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 2200),
                  horizontalOffset: 200,
                  curve: Curves.ease,
                  child: FadeInAnimation(
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 2500),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (isProduct == 'Hotel') {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(HotelScreen(
                                id: listStartingData[index].id_comapny,
                              )));
                        } else {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(RestaurantScreen(
                                id: listStartingData[index].id_comapny,
                              )));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.32,
                        margin: const EdgeInsets.only(left: 6),
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
                                    height: 166,
                                    width: MediaQuery.of(context).size.width),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 4, top: 3),
                              child: RichText(
                                text: TextSpan(
                                  text: listStartingData[index].name_comapny,
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        letterSpacing: .9),
                                  ),
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
          position: 2,
          delay: const Duration(milliseconds: 400),
          child: SlideAnimation(
            horizontalOffset: 120,
            duration: const Duration(milliseconds: 3000),
            verticalOffset: 260,
            curve: Curves.ease,
            child: FadeInAnimation(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 3500),
              child: MasonryGridView.count(
                  itemCount: list.length,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (list.isNotEmpty) {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(NatureScreen(
                                listImage: list,
                              )));
                        }
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
