import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_notification/notification.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String result;
  var list;
  var image;
  ImagePicker imagePicker;

  var mainHeight, mainWidth;

 captureImageWithCamera() async{
    
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if(!mounted) return;

    setState(() {
      cropImage(pickedFile.path);
    });

  }

  //Crop Image

  cropImage(filePath) async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: filePath,
    );

    if(!mounted) return;
    
    setState(() {
      image = cropped ?? image;
      imageToTextConversion();
    });
  }

  //Apply Ocr

  imageToTextConversion() async{
    final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(image);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    if(!mounted) return;

    setState(() {
      for(TextBlock block in visionText.blocks){

        final String txt = block.text;

        for(TextLine line in block.lines){

          for(TextElement element in line.elements){
            result += element.text + " ";
          }
        }
        result += "\n\n";
      }
    }

  );
}

  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    mainHeight = MediaQuery.of(context).size.height;
    mainWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Page', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: image == null 
              ? Container(
                height: 300,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: captureImageWithCamera,
                      child: Container(
                        height: 60,
                        width: 200,
                        child: Center(child: Text('Capture Image')),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.orange),
                      ),
                    ),
                  ],
                ),
              )
              : Container(
                  child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: (){
                Get.to(() => NotificationPage(value: result));
              },
              child: Container(
                height: 60,
                width: 200,
                child: Center(child: Text('Convert to text')),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}