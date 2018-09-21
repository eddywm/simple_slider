import 'package:flutter/material.dart';
import 'package:simple_slider/simple_slider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  final _imageUrls = [
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_7973.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8427.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8296.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8691.jpg"
  ];


  @override
  Widget build(BuildContext context) {
    var title = "Image Slider Widget";
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          child: ImageSliderWidget(
            imageUrls: _imageUrls,
            imageBorderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
