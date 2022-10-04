import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../data/const.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({Key? key}) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhoto();
}

class _AddPhoto extends State<AddPhoto> {
  UploadTask? task;
  File? file;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  String _companyName = '';
  TextEditingController storyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'Выберите картинку';
    _companyName = storyNameController.text;

    Future selectFile() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result == null) return;
      final path = result.files.single.path!;

      setState(() => file = File(path));
    }

    Future uploadHotel() async {
      if (file == null) return;

      final fileName = basename(file!.path);
      final destination = 'files/$fileName';

      task = FirebaseApi.uploadFile(destination, file!);
      setState(() {});

      if (task == null) return;

      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      final docUser =
          await FirebaseFirestore.instance.collection('Hotel').doc();

      final json = {
        'id': docUser.id,
        'photo': urlDownload,
        'name': _companyName,
      };

      docUser.set(json);

      setState(() {
        _companyName = '';
        _companyName = storyNameController.text;
      });
    }

    Future uploadFood() async {
      if (file == null) return;

      final fileName = basename(file!.path);
      final destination = 'files/$fileName';

      task = FirebaseApi.uploadFile(destination, file!);
      setState(() {});

      if (task == null) return;

      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      final docUser =
          await FirebaseFirestore.instance.collection('Restaurant').doc();

      final json = {
        'id': docUser.id,
        'photo': urlDownload,
        'name': _companyName,
      };

      docUser.set(json);

      setState(() {
        _companyName = '';
        _companyName = storyNameController.text;
      });
    }

    Future uploadNature() async {
      if (file == null) return;

      final fileName = basename(file!.path);
      final destination = 'files/$fileName';

      task = FirebaseApi.uploadFile(destination, file!);
      setState(() {});

      if (task == null) return;

      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      final docUser =
          await FirebaseFirestore.instance.collection('Nature').doc();

      final json = {
        'id': docUser.id,
        'photo': urlDownload,
        'name': _companyName,
      };

      docUser.set(json);

      setState(() {
        _companyName = '';
        _companyName = storyNameController.text;
      });
    }

    Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
          stream: task.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snap = snapshot.data!;
              final progress = snap.bytesTransferred / snap.totalBytes;
              final percentage = (progress * 100).toStringAsFixed(2);

              return Text(
                '$percentage %',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            } else {
              return Container();
            }
          },
        );

    Widget addStory() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: TextField(
                controller: storyNameController,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  helperStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black45),
                  hintText: 'Введите имя истории',
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    uploadHotel();
                  },
                  child: Text('Загрузить hotel')),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    uploadFood();
                  },
                  child: Text('Загрузить food')),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    uploadNature();
                  },
                  child: Text('Загрузить Nature')),
            ),

            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: Text('Выбрать картинку')),
            ),

            Text(fileName),
            task != null ? buildUploadStatus(task!) : Container(),
            // arrayListStory,
          ],
        ),
      );
    }

    return (Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addStory(),
        ],
      ),
    ));
  }
}
