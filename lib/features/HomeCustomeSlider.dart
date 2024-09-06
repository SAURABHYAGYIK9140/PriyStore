import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/BrandAndCategoryProductScreen2.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/NewProductList.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import '../utill/app_constants.dart';
import 'PhonpePayment.dart';
import 'category/domain/models/category_model.dart';
import 'category/screens/HomeCategory_screen.dart';

class Homecustomeslider extends StatefulWidget {
  final bool showimage;

  Homecustomeslider(this.showimage);

  @override
  _CustomeSliderState createState() => _CustomeSliderState();
}

class _CustomeSliderState extends State<Homecustomeslider> {
  static List<String> imageList = [];
  static String img1 = "";
  static String img2 = "";
  static bool isDataLoaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (!isDataLoaded) {
      loadHomeBanners();
    }
  }

  Future<void> loadHomeBanners() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.baseUrl + '/api/v1/banners/get-home-top-banners'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<String> photos = List<String>.from(data['photos']);
        String homeDhakadSingle = data['home_dhakad_single'];
        String homePrintSingle = data['home_print_single'];

        setState(() {
          imageList = photos;
          img1 = homeDhakadSingle;
          img2 = homePrintSingle;
          isDataLoaded = true;
        });
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Failed to load banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Column(
      children: [
        Column(
          children: [

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child: CarouselSlider(
            //     options: CarouselOptions(
            //       height: 160,
            //       aspectRatio: 16 / 9,
            //       viewportFraction: 0.92,
            //       initialPage: 0,
            //       enableInfiniteScroll: true,
            //       reverse: false,
            //       autoPlay: true,
            //       autoPlayInterval: Duration(seconds: 3),
            //       autoPlayAnimationDuration: Duration(milliseconds: 800),
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //       enlargeCenterPage: true,
            //       enlargeFactor: 0.3,
            //       scrollDirection: Axis.horizontal,
            //       onPageChanged: (index, reason) {
            //         setState(() {
            //           _currentIndex = index;
            //         });
            //       },
            //     ),
            //     items: imageList.isEmpty ? _buildPlaceholderWidgets() : _buildImageWidgets(),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: imageList.asMap().entries.map((entry) {
            //     return GestureDetector(
            //       onTap: () => CarouselSlider(
            //         items: _buildImageWidgets(),
            //         options: CarouselOptions(
            //           initialPage: entry.key,
            //         ),
            //       ),
            //       child: Container(
            //         width: 8.0,
            //         height: 8.0,
            //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: (Theme.of(context).brightness == Brightness.dark
            //               ? Colors.white
            //               : Colors.black)
            //               .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            viiews()
          ],
        ),
      ],
    );
  }

  Widget viiews() {

    if (img1.isNotEmpty && widget.showimage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                CategoryModel catname = AppConstants.dhakadcategoryModel;
                print("dhakadcategoryModelDD"+catname.images.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductScreen2(
                      isBrand: false,
                      catname: catname,
                      id: "28",
                      name: "Dhakad Trend",
                    ),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => PhonePePayment(),
                //   ),
                // );
              },
              child: Container(
                height: 120,
                margin: EdgeInsets.only(left: 5.0, right: 5),
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
                  child: Image.network(
                    img1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomecategoryScreen(isHomePage: false)),
                );
              },
              child: Container(
                height: 120,
                margin: EdgeInsets.only(left: 5.0, right: 5),
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
                  child: Image.network(
                    img2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<Widget> _buildPlaceholderWidgets() {
    return List.generate(
      3,
          (index) => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  List<Widget> _buildImageWidgets() {
    return imageList.map((imageUrl) {
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
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          );
        },
      );
    }).toList();
  }
}
