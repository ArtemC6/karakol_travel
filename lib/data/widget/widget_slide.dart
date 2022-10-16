import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karakol_travel/screen/hotel/hotel_screen.dart';
import '../../data/model/RestaurantModel.dart';
import '../../screen/restaurant/restaurant_screen.dart';
import '../const/const.dart';

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: RatingBarIndicator(
                                    unratedColor: Colors.white30,
                                    rating: listCompany[index].rating,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    // itemCount: 5,
                                    itemSize: 13,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, right: 4, top: 4),
                                  child: Text(
                                    "${listCompany[index].price.toString()} сом",
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          letterSpacing: .9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 4),
                              child: Text(
                                listCompany[index].name,
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
