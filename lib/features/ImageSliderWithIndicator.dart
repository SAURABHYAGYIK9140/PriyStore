import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../utill/app_constants.dart';

class ImageSliderWithIndicator extends StatefulWidget {
  final List<String>? imageList ;

  ImageSliderWithIndicator(this.imageList);

  @override
  _ImageSliderWithIndicatorState createState() => _ImageSliderWithIndicatorState();
}

class _ImageSliderWithIndicatorState extends State<ImageSliderWithIndicator> {


  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  List<Builder>? _buildImageWidgets() {
    return widget.imageList?.map((imageUrl) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(

              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(            AppConstants.baseUrl + "/storage/app/public/product/" +
                  imageUrl, fit: BoxFit.cover),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        CarouselSlider(
          items: _buildImageWidgets(),
          carouselController: _controller,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            height: 160,
            aspectRatio: 16 / 9,
            viewportFraction: 0.92,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageList!.map((url) {
            int? index = widget.imageList?.indexOf(url);
            return GestureDetector(
              onTap: () => _controller.animateToPage(index!),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
