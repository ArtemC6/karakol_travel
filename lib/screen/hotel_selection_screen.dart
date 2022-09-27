import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dashboards/model/HotelModel.dart';
import '../dashboards/utils/flutter_rating_bar.dart';
import '../data/const.dart';

class HotelSelectionScreen extends StatefulWidget {
  const HotelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HotelSelectionScreen> createState() => _HotelSelectionScreenState();
}

class _HotelSelectionScreenState extends State<HotelSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<HotelModel> listHotel = [
    HotelModel(
        rating: 5.0,
        location: 'Karakol, Ski Paradise, Gorodok Na Gornolyijnoy Baze ',
        id: '',
        image_uri: 'images/karakol/hotel/ic_ski_paradise.png',
        name: 'SkiParadise',
        price: 5000),
    HotelModel(
        rating: 4.6,
        location: 'Toktogul street 201',
        id: '',
        image_uri: 'images/karakol/hotel/ic_madanur.jpg',
        name: 'Madanur',
        price: 3000),
    HotelModel(
        id: '',
        rating: 4.4,
        location: 'Issyk-Kul region, Ak-Suu district',
        image_uri: 'images/karakol/hotel/ic_kapris.jpg',
        name: 'Kapriz',
        price: 7000),
    HotelModel(
        rating: 4.0,
        location: 'Abdrakhmanov house 89A',
        id: '',
        image_uri: 'images/karakol/hotel/ic_caragat.jpg',
        name: 'Caragat',
        price: 4000),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget hotelBest() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 100),
                scrollDirection: Axis.vertical,
                itemCount: listHotel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: black_86,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(listHotel[index].image_uri,
                              fit: BoxFit.cover,
                              height: 230,
                              width: MediaQuery.of(context).size.width),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 4, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      listHotel[index].name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                    Text(
                                      '${listHotel[index].price.toString()} сом',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red.withOpacity(1)),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 6, bottom: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 15,
                                    ),
                                    Text(
                                      listHotel[index].location,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    RatingBar(
                                      initialRating: listHotel[index].rating,
                                      minRating: 1,
                                      itemSize: 16,
                                      direction: Axis.horizontal,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Color(0xFFFBC02D),
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Text(
                                      listHotel[index].rating.toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                              ),

                              // style: primaryTextStyle(
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          //Top Trends
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black_93,
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 45,
              decoration: BoxDecoration(
                color: black_93,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  color: black_86,
                ),

                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Best',
                  ),
                  Tab(
                    text: 'Medium',
                  ),
                  Tab(
                    text: 'Lower',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  hotelBest(),
                  hotelBest(),
                  hotelBest(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
