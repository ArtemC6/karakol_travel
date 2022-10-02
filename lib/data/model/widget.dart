import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:karakol_travel/data/model/RelaxationModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screen/hotel/hotel_selection_screen.dart';

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
            const EdgeInsets.only(top: 10, bottom: 20, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              nameProduct,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'View all',
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                  const WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white70,
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
    );
  }
}

class showNatureCard extends StatelessWidget {
  List<String> list;

  showNatureCard(this.list);

  @override
  Widget build(BuildContext context) {
    List<double> masonryCardHeights = [150, 200, 270];

    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 30,
          bottom: MediaQuery.of(context).size.height / 30,
          right: MediaQuery.of(context).size.width / 30),
      child: MasonryGridView.count(
          itemCount: list.length,
          mainAxisSpacing: 22,
          crossAxisSpacing: 22,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: masonryCardHeights[index % 2],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) => Center(
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
            );
          }),
    );
  }
}
