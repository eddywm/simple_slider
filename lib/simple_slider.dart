import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_slider/dot_indicator.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<String> imageUrls;
  final BorderRadius imageBorderRadius;
  final double imageHeight;
  final void Function(int index) onTap;

  const ImageSliderWidget({
    Key key,
    @required this.imageUrls,
    this.imageBorderRadius = BorderRadius.zero,
    this.imageHeight = 200.0,
    this.onTap,
  }) : super(key: key);

  @override
  ImageSliderWidgetState createState() {
    return new ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<Widget> _pages = [];

  int page = 0;
  PageController _controller;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls.map((url) {
      return _buildImagePageItem(url);
    }).toList();
    _controller = PageController(initialPage: _pages.length * 10000);
    _controller.addListener(() {
      if (_controller.page != _controller.page.roundToDouble()) {
        pauseTimer();
      } else {
        startTimer();
      }
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      height: widget.imageHeight,
      child: Stack(
        children: [
          _buildPagerViewSlider(),
          _buildDotsIndicatorOverlay(),
        ],
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) widget.onTap(page % _pages.length);
        },
        child: PageView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return _pages[index % _pages.length];
          },
          onPageChanged: (int p) {
            setState(() {
              page = p;
            });
          },
        ),
      ),
    );
  }

  void startTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        _controller.animateToPage(
          _controller.page.toInt() + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }

  void pauseTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Positioned _buildDotsIndicatorOverlay() {
    return Positioned(
      bottom: 20.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotsIndicator(
          controller: _controller,
          itemCount: _pages.length,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePageItem(String imgUrl) {
    return ClipRRect(
      borderRadius: widget.imageBorderRadius,
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) => Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
