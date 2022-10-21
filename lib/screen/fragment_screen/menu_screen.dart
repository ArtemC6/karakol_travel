import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zoomable_photo_gallery/zoomable_photo_gallery.dart';
import '../../data/const/const.dart';
import 'package:zoomable_photo_gallery/zoomable_photo_gallery_widget.dart';

class MenuScreen extends StatefulWidget {
  List<String> listMenu;

  MenuScreen({Key? key, required this.listMenu}) : super(key: key);

  @override
  _MenuScreen createState() => _MenuScreen(listMenu);
}

class _MenuScreen extends State<MenuScreen> {
  List<String> listMenu;

  _MenuScreen(this.listMenu);

  int currentPageIndex = 0;
  ZoomablePhotoController controller = ZoomablePhotoController();

  @override
  Widget build(BuildContext context) {
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
                              child: ZoomablePhotoGallery(
                                controller: controller,
                                initIndex: 0,
                                backColor: black_86,
                                maxZoom: 5,
                                minZoom: 0.5,
                                // location: IndicatorLocation.BOTTOM_CENTER,
                                changePage: (int index) {
                                  setState(() {
                                    currentPageIndex = index;
                                  });
                                },

                                indicator: List.generate(
                                  listMenu.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.only(
                                        left: 2.5, right: 2.5, bottom: 14),
                                    width: 8.5,
                                    height: 8.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.8, color: Colors.white),
                                      shape: BoxShape.circle,
                                      color: index == currentPageIndex
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                  ),
                                ).toList(),

                                imageList: List.generate(
                                    listMenu.length,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: CachedNetworkImage(
                                            imageUrl: listMenu[index],
                                            imageBuilder:
                                                ((context, imageProvider) {
                                              return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10,
                                                          bottom: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.6,
                                                          color:
                                                              Colors.white54),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                      color: black_86),
                                                  child: Image(
                                                      image: imageProvider));
                                            }),
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
                                          ),
                                        )),
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
                                    controller.jumpToPage(index);
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
                                          side: BorderSide(
                                            width: index == currentPageIndex
                                                ? 0.7
                                                : 1,
                                            color: index == currentPageIndex
                                                ? Colors.white
                                                : Colors.white38,
                                          ),
                                        ),
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
