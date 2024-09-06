import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/NewCategoryProducts.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/no_internet_screen_widget.dart';
import '../../../common/basewidget/product_shimmer_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../common/basewidget/title_row_widget.dart';
import '../../../main.dart';
import '../../../utill/images.dart';
import '../../ImageSliderWithIndicator.dart';
import '../../Slider.dart';
import '../../product/screens/BrandAndCategoryProductScreen3.dart';
import '../../product/screens/brand_and_category_product_screen.dart';

class HomesubcatScreen extends StatefulWidget {
  final CategoryModel catname;

  HomesubcatScreen(this.catname);

  @override
  State<HomesubcatScreen> createState() => _NewsubcategoryScreenState();
}

class _NewsubcategoryScreenState extends State<HomesubcatScreen> {
  late CategoryController categoryController;
  int i=0;

  @override
  void initState() {
    super.initState();
    categoryController = Provider.of<CategoryController>(context, listen: false);
    categoryController.getCategoryList(widget.catname.id ?? 0, true);
  }

  @override
  void dispose() {
    super.dispose();
    Future.microtask(() {
      categoryController.clearCategoryList();
      categoryController.getCategoryList(0, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("aaaaaaa"+widget.catname.images.toString());
      print("iiiiii"+i.toString());
    }

    return Scaffold(
      appBar: CustomAppBar(title: widget.catname.name.toString()),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          i++;
          print("categoryProvider"+ categoryProvider.categoryList.length.toString());

          if (categoryProvider.categoryList.isEmpty) {
            return Center(
              child: Stack(
                children: [
                Visibility(

                visible: i!=1,
                 child:                  ImageSliderWithIndicator(widget.catname.images),

                  ),
                  Visibility(

                    visible: i!=1,
                    child: const NoInternetOrDataScreenWidget(
                      isNoInternet: false,
                      icon: Images.noProduct,
                      message: 'No products found',
                    ),
                  ),
                  Visibility(
                    visible: i==1,
                    child: Center(
                      child: CircularProgressIndicator(
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Visibility(
              visible: i!=1,

              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if(widget.catname.images!.isNotEmpty)
                      ImageSliderWithIndicator(widget.catname.images),


                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 10,
                          childAspectRatio: .9,
                        ),
                        itemCount: categoryProvider.categoryList.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          CategoryModel category = categoryProvider.categoryList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                  builder: (_) => BrandAndCategoryProductScreen3(
                                    categoryModel:category ,
                                    isBrand: false,
                                    id: category.id.toString(),
                                    name: category.name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: categoryProvider.categorySelectedIndex == index
                                                ? Theme.of(context).highlightColor
                                                : Theme.of(context).hintColor,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CustomImageWidget(
                                            fit: BoxFit.cover,
                                            image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.categoryImageUrl}/${category.icon}',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            category.name!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: titilliumSemiBold.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Products",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // Display the Newcategoryproducts widget
                    Newcategoryproducts(
                      isBrand: false,
                      id: widget.catname.id.toString(),
                      name: widget.catname.name,
                    ),
                  ],
                ),
              ),
            );

          }

        },
      ),
    );
  }
  List<Widget> _buildImageWidgets() {
    return widget.catname.images!.map((image) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            // BoxShadow(
            //   // color: Colors.black26,
            //   blurRadius: 10.0,
            //   offset: Offset(0, 5),
            // ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(AppConstants.baseUrl+"/storage/app/public/product/"+ image), // Adjust according to your image source
        ),
      );

      // return Container(
      //   margin: EdgeInsets.symmetric(horizontal: 5.0),
      //   child: Image.network(AppConstants.baseUrl+"/storage/app/public/product/"+ image), // Adjust according to your image source
      // );
    }).toList();
  }


}