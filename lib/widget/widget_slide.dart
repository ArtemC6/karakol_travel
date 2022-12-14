import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karakol_travel/screen/hotel/hotel_screen.dart';
import '../../screen/restaurant/restaurant_screen.dart';
import '../data/const/const.dart';
import '../model/RestaurantModel.dart';

class companyComponentSimilar extends StatelessWidget {
  List<RestaurantModel> listCompany = [];
  String isCompany;

  companyComponentSimilar(this.listCompany, this.isCompany, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AnimationLimiter(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 10, left: 10),
            scrollDirection: Axis.horizontal,
            itemCount: listCompany.length,
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
                        if (isCompany == 'Restaurant') {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(RestaurantScreen(
                                id: listCompany[index].id,
                              )));
                        } else {
                          Navigator.push(
                              context,
                              FadeRouteAnimation(HotelScreen(
                                id: listCompany[index].id,
                              )));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
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
                                    width: 0.5,
                                    color: Colors.white24,
                                  )),
                              elevation: 14,
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
                                    imageUrl: listCompany[index].photo_main,
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width,
                                    height: 100),
                                // width: size.width),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.34,
                                  padding:
                                      const EdgeInsets.only(left: 2, top: 4),
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text:
                                          '${listCompany[index].name} (${listCompany[index].rating}) ',
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            letterSpacing: .6),
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16.5,
                                ),
                              ],
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
