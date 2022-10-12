import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/services.dart';
import '../../data/cons/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewingScreen extends StatefulWidget {
  List<String> listMenu;

  PhotoViewingScreen({Key? key, required this.listMenu}) : super(key: key);

  @override
  _PhotoViewingScreen createState() => _PhotoViewingScreen(listMenu);
}

class _PhotoViewingScreen extends State<PhotoViewingScreen> {
  List<String> listMenu;

  _PhotoViewingScreen(this.listMenu);

  final CarouselController _controllerMenu = CarouselController();
  int _currentMenu = 0;

  @override
  Widget build(BuildContext context) {
    print(listMenu.length);
    List<Widget> imageSlidersMenu = listMenu
        .map(
          (item) => InteractiveViewer(
            constrained: true,
            scaleEnabled: true,
            panEnabled: true,
            // alignPanAxis: true,
            child: Card(
              margin: EdgeInsets.all(10),
              shadowColor: Colors.white38,
              color: black_86,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(
                    width: 0.8,
                    color: Colors.white30,
                  )),
              elevation: 6,
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
                fit: BoxFit.contain,
                // height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: black_93,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  color: black_86,
                  child: Stack(
                    children: <Widget>[
                      AnimationLimiter(
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: const Duration(milliseconds: 400),
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
                                    items: imageSlidersMenu,
                                    carouselController: _controllerMenu,
                                    options: CarouselOptions(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      // autoPlay: true,
                                      disableCenter: false,
                                      viewportFraction: 1,
                                      onPageChanged: (index, reason) {
                                        setState(
                                          () {
                                            _currentMenu = index;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          listMenu.asMap().entries.map((entry) {
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
                                                      _currentMenu == entry.key
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
                    ],
                  ),
                ),
              ),
              Expanded(
                // height: MediaQuery.of(context).size.height / 6,
                flex: 2,
                child: AnimationLimiter(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: listMenu.length,
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
                                  setState(() {
                                    _currentMenu = index;
                                    _controllerMenu.jumpToPage(_currentMenu);
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  margin: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                        shadowColor: Colors.white30,
                                        color: black_86,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                              width: 0.8,
                                              color: Colors.white24,
                                            )),
                                        elevation: 16,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                            value: progress
                                                                .progress,
                                                          ),
                                                        ),
                                                      ),
                                              imageUrl: listMenu[index],
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width),
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
}
