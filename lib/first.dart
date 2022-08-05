import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  final ImagePicker _picker = ImagePicker();
  String imagepath = "";
  List<XFile>? imageFileList = [];
  bool Status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Column(
        children: [
          Status
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      width: 400,
                      child: imageFileList!.isEmpty
                          ? Image.asset('assets/images.png')
                          : GridView.builder(
                              itemCount: imageFileList!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                  File(imageFileList![index].path),
                                  fit: BoxFit.cover,
                                );
                              }),
                    ),
                  ),
                )
              : Container(
                  height: 400,
                  width: 400,
                  child: imagepath.isEmpty
                      ? Image.asset('assets/images.png')
                      : Image.file(File(imagepath)),
                ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("Select Picture"),
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                        onTap: () async {
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera);
                          Status = false;
                          if (photo != null) {
                            imagepath = photo.path;
                            setState(() {});
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text("Gallery"),
                        onTap: () async {
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.gallery);
                          Status = false;
                          if (photo != null) {
                            imagepath = photo.path;
                            setState(() {});
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text("Multiple Photos"),
                        onTap: () async {
                          final List<XFile>? selectedImages =
                              await _picker.pickMultiImage();
                          imageFileList = [];
                          if (selectedImages!.isNotEmpty) {
                            imageFileList!.addAll(selectedImages);
                            Status = true;
                          }
                          print("Image List Length:" +
                              imageFileList!.length.toString());
                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: Text(
              "Choose File",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                elevation: MaterialStateProperty.all(5)),
          )
        ],
      ),
    );
  }
}
