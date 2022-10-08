import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'model/CommentModel.dart';
import 'model/StartingDataModel.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destinaiton, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destinaiton);
      return ref.putFile(file);
    } on FirebaseException catch (_) {
      return null;
    }
  }
}

const black_93 = Color(0xFF161616);
const black_86 = Color(0xFF222327);

class FadeRouteAnimation extends PageRouteBuilder {
  final Widget page;

  FadeRouteAnimation(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}

const List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];

List<CommentModel> listComment = [
  CommentModel(
      name: '',
      dateTime: DateTime.now(),
      id: '',
      photo_profile:
          'https://cdn.vox-cdn.com/thumbor/n-V0QecZDxHqqs13ISr10aFtd6E=/0x0:1363x2048/1200x0/filters:focal(0x0:1363x2048):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/19424454/jesse_brawner_creditMarcCartwright.jpeg',
      rating: 4.5,
      comment:
          'good dfdsf dsf dsdsfdsfdsfasasdfadsf dsf dsf dsfdsffffffffff fdsssss'),
  CommentModel(
      name: '',
      id: '',
      dateTime: DateTime.now(),
      photo_profile:
          'https://lmg-labmanager.s3.amazonaws.com/assets/articleNo/23259/iImg/43114/owensjeffrey.jpg',
      rating: 4.1,
      comment: 'good fdaadsffffffdsf dsf dsf dsfdsffffffffff fdsssss'),
  CommentModel(
      name: '',
      dateTime: DateTime.now(),
      id: '',
      photo_profile:
          'https://kcballet.files.wordpress.com/2012/08/skyler-taylor.jpg',
      rating: 3.7,
      comment: 'good dfdsf dsf dsf dsf dsf dsfdsffffffffff fdsssss'),
  CommentModel(
      name: '',
      dateTime: DateTime.now(),
      id: '',
      photo_profile: 'https://starnote.ru/media/c/starnote/'
          'v2/blog/gallery/2013/10/15/6bfd5ae16f/sjurrealizm-ot-deniela-redkliffa-foto-aktera-dlja-flaunt_8.jpg',
      rating: 5.0,
      comment: 'good dfdsf dsf dsf dsf dsf dsfdsffffffffff fdsssss'),
];

List<StartingDataModel> listMenu = [
  StartingDataModel(
      name: 'Breakfast',
      image_uri:
          'https://proprikol.ru/wp-content/uploads/2020/06/kartinki-zavtrak-39.jpg'),
  StartingDataModel(
      name: 'Lunch',
      image_uri:
          'https://podacha-blud.com/uploads/posts/2022-06/1654220582_10-podacha-blud-com-p-krasivii-obed-foto-11.jpg'),
  StartingDataModel(
      name: 'Dinner',
      image_uri:
          'https://get.pxhere.com/photo/food-meal-meat-chicken-dinner-vege'
          'table-dish-fried-potato-cooking-cooked-vegetables-roasted-lunch-'
          'pan-baked-salad-potatoes-healthy-pork-plate-tomato-cuisine-grilled-onion-produce-'
          'ingredient-garden-salad-tableware-recipe-kitchen-utensil-whole-food-leaf-vegetable-cutlery-root'
          '-vegetable-dishware-local-food-natural-foods-chicken-meat-vegan-nutrition-pear-fork-veget'
          'arian-food-kitchen-knife-bowl-side-dish-garnish-staple-food-Food-group-superfood-I'
          'ceburg-lettuce-herb-greek-food-greek-salad-brunch-cruciferous-vegetables-knife-cucu'
          'mber-pakistani-cuisine-1634384.jpg'),
  StartingDataModel(
      name: 'Coffee',
      image_uri:
          'https://u.9111s.ru/uploads/202109/02/7cf39d5512b533c63838f1ff218c235a.jpg'),
  StartingDataModel(
      name: 'Healthy Eating',
      image_uri:
          'https://pic.rutubelist.ru/video/e3/71/e3718791b86f28adab510b41770da490.jpg'),
  StartingDataModel(
      name: 'Beverages',
      image_uri: 'https://i.artfile.ru/2560x1706_1119894_[www.ArtFile.ru].jpg'),
];

int getRandomElement(int length) {
  int randomIndex = 0;
  if(length == 1) {
    randomIndex = 0;
  } else {
    randomIndex = Random().nextInt(length);
  }
  return randomIndex;
}
