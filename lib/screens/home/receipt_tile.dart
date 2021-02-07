import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/receipt.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class ReceiptTile extends StatefulWidget {
  final Receipt receipt;
  ReceiptTile({this.receipt});

  @override
  _ReceiptTileState createState() => _ReceiptTileState();
}

class _ReceiptTileState extends State<ReceiptTile> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            isThreeLine: true,
            title: Text(widget.receipt.storeName),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.receipt.total),
                  Text(widget.receipt.date),
                ]),
            trailing: Text(widget.receipt.tags),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                textColor: const Color(0xFF6200EE),
                onPressed: () {
                  getImage();
                },
                child: const Text('Add receipt'),
              ),
              FlatButton(
                textColor: const Color(0xFF6200EE),
                onPressed: () {
                  uploadPic(context);
                },
                child: const Text('Set receipt'),
              ),
            ],
          ),
          Container(
            child: (_image != null)
                ? Image.file(_image, fit: BoxFit.fill)
                : Image.network(
                    "https://customercare.igloosoftware.com/.api2/api/v1/communities/10068556/previews/thumbnails/4fc20722-5368-e911-80d5-b82a72db46f2?width=680&height=680&crop=False",
                    fit: BoxFit.cover,
                  ),
          ),
        ]),
      ),
    );
  }
}
