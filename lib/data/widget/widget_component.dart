import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karakol_travel/data/model/CommentModel.dart';
import 'package:karakol_travel/screen/map/map_screen.dart';
import '../../generated/locale_keys.g.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import '../../data/model/RestaurantModel.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../screen/fragment_screen/comment_screen.dart';
import '../../screen/fragment_screen/menu_screen.dart';
import '../../screen/restaurant/restaurant_screen.dart';
import '../const/const.dart';
import 'contact_operators.dart';
import 'package:easy_localization/easy_localization.dart';

class companyComponent_1 extends StatefulWidget {
  List<RestaurantModel> listCompany = [];

  companyComponent_1(this.listCompany, {super.key});

  @override
  State<companyComponent_1> createState() => _companyComponent_1State();
}

class _companyComponent_1State extends State<companyComponent_1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(1.5),
                child: RichText(
                  text: TextSpan(
                    text: widget.listCompany[0].name,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: .9),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: RichText(
                        text: TextSpan(
                          text: widget.listCompany[0].location,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 11.5,
                                color: Colors.white,
                                letterSpacing: .8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {

                  Navigator.push(
                      context,
                      FadeRouteAnimation(
                          MapScreen(id: widget.listCompany[0].id,)));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 4, top: 10, right: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(99)),
                    child: const AvatarGlow(
                      glowColor: Colors.blueAccent,
                      endRadius: 28,
                      duration: Duration(milliseconds: 2200),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  showCupertinoModalBottomSheet(
                      topRadius: const Radius.circular(30),
                      duration: const Duration(milliseconds: 700),
                      backgroundColor: black_86,
                      context: context,
                      builder: (context) => ContactsOperator(
                            listCompany: widget.listCompany,
                          ));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 4, top: 10, right: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(99)),
                    child: const AvatarGlow(
                      glowColor: Colors.blueAccent,
                      endRadius: 25,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: Icon(
                        Icons.phone,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class companyComponent_2 extends StatelessWidget {
  List<RestaurantModel> listCompany = [];
  List<String> listMenu = [];
  String isCompany;

  companyComponent_2(this.listCompany, this.listMenu, this.isCompany,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: RichText(
                      text: TextSpan(
                        text: LocaleKeys.rating_lc.tr(),
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 13.5,
                              color: Colors.white,
                              letterSpacing: .8),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: listCompany[0].rating.toString(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.white,
                                  letterSpacing: .8)),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      RatingBarIndicator(
                        unratedColor: Colors.white30,
                        rating: listCompany[0].rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 15,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (listMenu.isNotEmpty) {
                Navigator.push(
                    context,
                    FadeRouteAnimation(MenuScreen(
                      listMenu: listMenu,
                    )));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      isCompany == 'Restaurant'
                          ? Icons.restaurant_menu
                          : Icons.menu_book,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: isCompany == 'Restaurant'
                          ? LocaleKeys.is_menu_lc.tr()
                          : LocaleKeys.is_catalog_lc.tr(),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: .8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class companyComponentGallery extends StatelessWidget {
  List<String> listMenu = [];
  List<String> listImages = [];

  companyComponentGallery(this.listMenu, this.listImages, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 14, bottom: 20, top: 20, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.white30),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white10),
                child: RichText(
                  text: TextSpan(
                    text: LocaleKeys.gallery_lc.tr(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          letterSpacing: .8),
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRouteAnimation(MenuScreen(
                        listMenu: listImages,
                      )));
                },
                child: RichText(
                  text: TextSpan(
                    text: LocaleKeys.view_all_lc.tr(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.blueAccent,
                          letterSpacing: .8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 340,
          child: AnimationLimiter(
            child: GridView.count(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.all(1),
              crossAxisCount: 3,
              children: List.generate(
                listImages.length,
                (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 2200),
                    columnCount: 3,
                    child: ScaleAnimation(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.linear,
                      child: FadeInAnimation(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (listImages.isNotEmpty) {
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(MenuScreen(
                                    listMenu: listImages,
                                  )));
                            }
                          },
                          child: Card(
                            shadowColor: Colors.white30,
                            color: black_86,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: Colors.white24,
                                )),
                            elevation: 14,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: listImages[index],
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
                                fit: BoxFit.cover,
                                // height: MediaQuery.of(context).size.height,
                                // width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class companyComponentComment extends StatefulWidget {
  List<CommentModel> listComment = [];
  String id = '';

  companyComponentComment(this.listComment, this.id, {super.key});

  @override
  State<companyComponentComment> createState() =>
      _companyComponentCommentState(listComment, id);
}

class _companyComponentCommentState extends State<companyComponentComment> {
  List<CommentModel> listComment = [];
  String id = '';

  _companyComponentCommentState(this.listComment, this.id);

  bool isVisible = false, isOperatorExist = false;
  double ratingValue = 4.0;
  String _commentCount = '';
  String idDevise = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void getIdDevise() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      idDevise = androidInfo.androidId!;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      idDevise = iosInfo.identifierForVendor!;
    }
  }

  @override
  void initState() {
    getIdDevise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? floor;
    String? position;
    showAlertDialogComment(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                backgroundColor: black_86,
                actions: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 12, left: 12),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                            ],
                            controller: _nameController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 0.8),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1.2),
                              ),
                              hintMaxLines: 1,
                              hintText: LocaleKeys.your_name_lc.tr(),
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(.8),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _commentCount = value;
                              });
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            maxLines: 4,
                            controller: _commentController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 0.8),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1.2),
                              ),
                              // hintMaxLines: 1,

                              hintText: LocaleKeys.your_feedback_lc.tr(),
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(.8),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(8),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  '${_commentCount.length} ${LocaleKeys.maximum_characters_lc.tr()}(100)',
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.white,
                                      letterSpacing: .8)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 38,
                                width: 110,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text: LocaleKeys.choose_gender_lc
                                                  .tr(),
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: [
                                      LocaleKeys.man_lc.tr(),
                                      LocaleKeys.woman_lc.tr()
                                    ]
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: RichText(
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text: item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: floor,
                                    onChanged: (value) {
                                      setState(() {
                                        floor = value as String;
                                        if (floor == 'Man' ||
                                            floor == 'Мужчина') {
                                          position = '0';
                                        }
                                        if (floor == 'Woman' ||
                                            floor == 'Девушка') {
                                          position = '1';
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 12,
                                    iconEnabledColor: Colors.blueAccent,
                                    iconDisabledColor: Colors.grey,
                                    buttonHeight: 50,
                                    buttonWidth: 50,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    buttonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                      ),
                                      color: black_86,
                                    ),
                                    buttonElevation: 2,
                                    itemHeight: 40,
                                    itemPadding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    dropdownMaxHeight: 200,
                                    dropdownWidth: 90,

                                    dropdownPadding: null,
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: black_86,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    scrollbarThickness: 6,
                                    alignment: Alignment.center,
                                    // scrollbarAlwaysShow: true,
                                    // offset: const Offset(0, 0),
                                  ),
                                ),
                              ),
                              SmoothStarRating(
                                color: Colors.amber,
                                borderColor: Colors.white30,
                                rating: 4,
                                isReadOnly: false,
                                size: 21,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: true,
                                spacing: 1.0,
                                onRated: (value) {
                                  setState(() {
                                    ratingValue = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.white30),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white10),
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: LocaleKeys.close_lc.tr(),
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.white,
                                            letterSpacing: .8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  if (_nameController.text.length >= 3 &&
                                      _commentController.text.length >= 3 &&
                                      ratingValue >= 1 &&
                                      position != null) {
                                    final docComment = FirebaseFirestore
                                        .instance
                                        .collection('Comment')
                                        .doc();

                                    final json = {
                                      'id': docComment.id,
                                      if (position == '0')
                                        'photo':
                                            'https://firebasestorage.googleapis.com/v0/b/karakol-travel.appspot.com/o/files%2FIMG_20221010_152851_079.jpg?alt=media&token=248db8f7-74a9-43e1-83d9-5b7d07dff0b7',
                                      if (position == '1')
                                        'photo':
                                            'https://firebasestorage.googleapis.com/v0/b/karakol-travel.appspot.com/o/files%2FIMG_20221010_152853_716.jpg?alt=media&token=dec5b47e-2ba6-43a1-9423-bf2b9ca8e947',
                                      'id_company': id,
                                      'id_devise': idDevise,
                                      'date': DateTime.now(),
                                      'name': _nameController.text.toString(),
                                      'comment':
                                          _commentController.text.toString(),
                                      'rating': ratingValue
                                    };

                                    docComment.set(json).then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          FadeRouteAnimation(RestaurantScreen(
                                            id: id,
                                          )));
                                    });
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(right: 4, left: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white10),
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: LocaleKeys.publish_lc.tr(),
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.white,
                                            letterSpacing: .8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 24, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.white30),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white10),
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: LocaleKeys.reviews_lc.tr(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          letterSpacing: .8),
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRouteAnimation(CommentScreen(
                        id: id,
                      )));
                },
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: LocaleKeys.view_all_lc.tr(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.blueAccent,
                          letterSpacing: .8),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 323,
            child: AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: listComment.length >= 20 ? 20 : listComment.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (listComment[index].id_devise == idDevise) {
                    return Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 300),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 1500),
                            horizontalOffset: 100,
                            curve: Curves.ease,
                            child: FadeInAnimation(
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 2000),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
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
                                      imageUrl:
                                          listComment[index].photo_profile,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text: listComment[index].name,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    letterSpacing: .8),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                child: Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      unratedColor:
                                                          Colors.white30,
                                                      rating: widget
                                                          .listComment[index]
                                                          .rating,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      // itemCount: 5,
                                                      itemSize: 18,
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                    RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text:
                                                            '    ${getDataTimeDate(listComment[index].dateTime).day.toString()}'
                                                            ' ${months[getDataTimeDate(listComment[index].dateTime).month - 1]}'
                                                            ' ${getDataTimeDate(listComment[index].dateTime).year.toString()}  ',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      .8),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: RichText(
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: widget
                                                    .listComment[index].comment,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      letterSpacing: .8),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) async {
                          final docUser = FirebaseFirestore.instance
                              .collection('Comment')
                              .doc(listComment[index].id);
                          docUser.delete();
                          setState(() => listComment.removeAt(index));
                        });
                  }

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      horizontalOffset: 100,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2000),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
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
                                imageUrl: listComment[index].photo_profile,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                        text: listComment[index].name,
                                        style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              letterSpacing: .8),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            children: [
                                              RatingBarIndicator(
                                                unratedColor: Colors.white30,
                                                rating: widget
                                                    .listComment[index].rating,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                // itemCount: 5,
                                                itemSize: 18,
                                                direction: Axis.horizontal,
                                              ),
                                              RichText(
                                                maxLines: 1,
                                                text: TextSpan(
                                                  text:
                                                      '    ${getDataTimeDate(listComment[index].dateTime).day.toString()}'
                                                      ' ${months[getDataTimeDate(listComment[index].dateTime).month - 1]}'
                                                      ' ${getDataTimeDate(listComment[index].dateTime).year.toString()}  ',
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        letterSpacing: .8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 2),
                                      width: MediaQuery.of(context).size.width /
                                          1.7,
                                      child: RichText(
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              widget.listComment[index].comment,
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                letterSpacing: .8),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  showAlertDialogComment(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white10),
                  child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: LocaleKeys.leave_feedback_lc.tr(),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 11.5,
                            color: Colors.white,
                            letterSpacing: .8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
