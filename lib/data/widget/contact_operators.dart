import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:telegram/telegram.dart';
import '../../data/model/OperatorModel.dart';
import 'dart:io';
import '../../data/model/RestaurantModel.dart';
import '../../generated/locale_keys.g.dart';
import '../const/const.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactsOperator extends StatefulWidget {
  List<RestaurantModel> listCompany = [];

  ContactsOperator({Key? key, required this.listCompany}) : super(key: key);

  @override
  State<ContactsOperator> createState() => _ContactsOperatorState(listCompany);
}

class _ContactsOperatorState extends State<ContactsOperator> {
  List<RestaurantModel> listCompany;

  _ContactsOperatorState(this.listCompany);

  List<OperatorModel> listOperator = [];
  String _phoneInfo = '';

  readFirebaseOperator() async {
    listOperator = [];
    await FirebaseFirestore.instance
        .collection('Operator')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        if (data['dataEnd'] == '') {
          setState(() {
            listOperator.add(OperatorModel(
                name: data['name'],
                telegram: data['telegram'],
                whitsApp: data['whistApp'],
                phone: data['phone'],
                uid: data['uid'],
                dataStart: data['dataStart'],
                dataEnd: Timestamp.now(),
                id: data['id']));
          });
        }
      });
    });
  }

  Future<void> getNamePhone() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      _phoneInfo = 'Android $release, $manufacturer $model';
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      _phoneInfo = '$systemName $version, $name $model';
    }
  }

  @override
  void initState() {
    getNamePhone();
    readFirebaseOperator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dialNumber(List<OperatorModel> list) {
      if (list.isNotEmpty) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(LocaleKeys.connect_with_us_lc.tr(),
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                letterSpacing: .8),
                          )))),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Colors.green, width: 0.5)))),
                  onPressed: () async {
                    final docCall =
                        FirebaseFirestore.instance.collection('Call').doc();

                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'company': listCompany[0].name,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'call',
                    };
                    docCall.set(json).then((value) {
                      FlutterPhoneDirectCaller.callNumber(
                          list[randomIndex].phone);
                      Navigator.pop(context);
                    });
                  },
                  icon: Image.asset(
                    'assets/images/icon/ic_phone.png',
                    height: 65,
                    width: 65,
                  ),
                  label: Text(
                    '${LocaleKeys.contact_phone_lc.tr()}           ',
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
              Container(
                // alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Colors.green, width: 0.5)))),
                  onPressed: () async {
                    final docCall =
                        FirebaseFirestore.instance.collection('Call').doc();
                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'company': listCompany[0].name,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'whatsApp',
                    };
                    docCall.set(json);
                    Navigator.pop(context);

                    // bool whatsapp =
                    //     await FlutterLaunch.hasApp(name: "whatsapp");
                    // if (whatsapp) {
                    await FlutterLaunch.launchWhatsapp(
                        phone: list[randomIndex].whitsApp,
                        message:
                            '${LocaleKeys.company_question_lc.tr()} \"${listCompany[0].name}\"');
                    // }
                  },
                  icon: Image.asset(
                    'assets/images/icon/ic_whatsapp.png',
                    height: 60,
                    width: 60,
                  ),
                  label: Text(
                    LocaleKeys.contact_whatsApp_lc.tr(),
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: TextButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Colors.blueAccent, width: 0.5)))),
                  onPressed: () async {
                    final docCall =
                        FirebaseFirestore.instance.collection('Call').doc();
                    int randomIndex = getRandomElement(listOperator.length);
                    final json = {
                      'id': docCall.id,
                      'company': listCompany[0].name,
                      'uid': list[randomIndex].uid,
                      'deviceInfo': _phoneInfo,
                      'currentData': DateTime.now(),
                      'action': 'telegram',
                    };
                    docCall.set(json).then((value) {
                      Telegram.send(
                        username: list[randomIndex].telegram,
                        message:
                            '${LocaleKeys.company_question_lc.tr()} \"${listCompany[0].name}\"',
                      );
                      Navigator.pop(context);
                    });
                  },
                  icon: Image.asset(
                    'assets/images/icon/ic_telegram.png',
                    height: 65,
                    width: 65,
                  ),
                  label: Text(
                    LocaleKeys.contact_telegram_lc.tr(),
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: .8)),
                  ),
                ),
              ),
            ],
          ),
        ));
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        margin: const EdgeInsets.all(40),
        child: Card(
          shadowColor: Colors.white30,
          color: black_86,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white10,
              )),
          elevation: 22,
          child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              color: Colors.blueAccent, width: 0.7)))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(LocaleKeys.try_later_lc.tr(),
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 18, color: Colors.white, letterSpacing: .8),
                  ))),
        ),
      );
    }

    return dialNumber(listOperator);
  }
}
