import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HotelSelectionScreen()));
        } else if (nameProduct == 'Food') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HotelSelectionScreen()));
        } else if (nameProduct == 'Nature') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HotelSelectionScreen()));
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 22, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white10),
              child: Text(
                nameProduct,
                // style: GoogleFonts.ans(
                //     fontFamily: 'googleFontBold',
                //
                // fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //     fontSize: 17,
                // ),
                style: TextStyle(
                  fontFamily: 'googleFontBold',
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'View all',
                      style: TextStyle(fontSize: 14, color: Colors.blueAccent)),
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

    // return SizedBox(
    //   height: MediaQuery.of(context).size.height / 3.5,
    //   child: AnimationLimiter(
    //     child: ListView.builder(
    //         physics: BouncingScrollPhysics(),
    //         padding: const EdgeInsets.only(right: 20),
    //         scrollDirection: Axis.horizontal,
    //         itemCount: list.length,
    //         shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           return AnimationConfiguration.staggeredList(
    //             position: index,
    //             delay: const Duration(milliseconds: 400),
    //             child: SlideAnimation(
    //               duration: const Duration(milliseconds: 2000),
    //               horizontalOffset: 140,
    //               curve: Curves.ease,
    //               child: FadeInAnimation(
    //                 curve: Curves.easeOut,
    //                 duration: const Duration(milliseconds: 2000),
    //                 child: InkWell(
    //                   splashColor: Colors.transparent,
    //                   highlightColor: Colors.transparent,
    //                   onTap: () {
    //
    //                   },
    //                   child: Container(
    //                     width: MediaQuery.of(context).size.width * 0.35,
    //                     margin: const EdgeInsets.only(left: 16),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: <Widget>[
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           );
    //         }),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 50,
          bottom: MediaQuery.of(context).size.height / 50,
          right: MediaQuery.of(context).size.width / 50),
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
                Navigator.push(context, FadeRouteAnimation(NatureScreen()));
              },
              child: SizedBox(
                height: masonryCardHeights[index % 2],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
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
            );
          }),
    );
  }
}
