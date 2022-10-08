import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:karakol_travel/screen/restaurant/restaurant_selection_screen.dart';
import '../../data/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screen/Nature/nature_screen.dart';
import '../../screen/hotel/hotel_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class sampleProductOnTap extends StatelessWidget {
  late String nameProduct;

  sampleProductOnTap(this.nameProduct);

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
              context, FadeRouteAnimation(RestaurantSelectionScreen()));
        } else if (nameProduct == 'Nature') {
          Navigator.push(context, FadeRouteAnimation(NatureScreen()));
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 18, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white10),
              child: Row(
                children: [
                  if (nameProduct == 'Hotel')
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: const Icon(
                        Icons.home_outlined,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  if (nameProduct == 'Food')
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  if (nameProduct == 'Nature')
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: const Icon(
                        Icons.nature_people_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  Text(
                    nameProduct,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
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
                      textStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 13,
                          letterSpacing: .9),
                    ),
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: const Icon(
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

class showNatureCard extends StatelessWidget {
  List<String> list;

  showNatureCard(this.list);

  @override
  Widget build(BuildContext context) {
    List<double> masonryCardHeights = [150, 250, 300];

    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 50,
          bottom: MediaQuery.of(context).size.height / 50,
          right: MediaQuery.of(context).size.width / 50),
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
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context, FadeRouteAnimation(NatureScreen()));
                      },
                      child: SizedBox(
                        height: masonryCardHeights[index % 2],
                        child: Card(
                          shadowColor: Colors.white30,
                          color: black_86,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                width: 0.8,
                                color: Colors.white10,
                              )),
                          elevation: 12,
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
