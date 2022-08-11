import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagepicker/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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

  late File _video;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initpref();
  }

  initpref() async {
    Model.prefs = await SharedPreferences.getInstance();

    imagepath = Model.prefs!.getString("image") ?? '';
    setState(() {});
  }

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
            height: 200,
            width: 400,
            child: imagepath.isEmpty
                ? Image.asset('assets/images.png')
                : Image.file(File(imagepath)),
          ),
          Container(height: 400,width: 500,child:
          _videoPlayerController.value.isInitialized ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),):Container(),),

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
                          await Model.prefs!.setString('image', imagepath);
                          setState(() {

                          });
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
                      ),
                      ListTile(
                          leading: Icon(Icons.videocam_rounded),
                          title: Text("Video"),
                          onTap: () async {
                            final XFile? video = await _picker.pickVideo(
                                source: ImageSource.gallery);

                            _video = File(video!.path);
                            _videoPlayerController = VideoPlayerController.file(
                                _video)
                              ..initialize().then((value) =>
                                  (value) {
                                setState(() {});
                              });
                            _videoPlayerController.play();
                          }

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
