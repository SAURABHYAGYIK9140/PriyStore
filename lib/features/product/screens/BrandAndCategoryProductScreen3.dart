import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';
import '../../ImageSliderWithIndicator.dart';

class BrandAndCategoryProductScreen3 extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  CategoryModel categoryModel;
   BrandAndCategoryProductScreen3({super.key, required this.isBrand,
    required this.id, required this.name,
    this.image,required this.categoryModel});

  @override
  State<BrandAndCategoryProductScreen3> createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<BrandAndCategoryProductScreen3> {
  @override
  void initState() {
    Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(  '0',
        '',
        widget.isBrand, widget.categoryModel.id.toString(), context);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      Future.microtask(() {
        Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(  '0',
            '',
            widget.isBrand, widget.categoryModel.id.toString(), context);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("onlyproduct"+widget.categoryModel.images.toString());
    print("onlyproduct"+widget.categoryModel.id.toString());
    return Scaffold(
      appBar: CustomAppBar(title: widget.name),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            if(widget.categoryModel.images!.isNotEmpty)
              ImageSliderWithIndicator(widget.categoryModel.images),


            widget.isBrand ? Container(height: 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              color: Theme.of(context).highlightColor,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls!.brandImageUrl}/${widget.image}',
                  width: 80, height: 80, fit: BoxFit.cover,),
                const SizedBox(width: Dimensions.paddingSizeSmall),


                Expanded(child: Text(widget.name??'',maxLines: 2,overflow: TextOverflow.ellipsis, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge))),
              ]),
            ) : const SizedBox.shrink(),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Products
            productController.brandOrCategoryProductList.isNotEmpty ?
            Expanded(
              child: MasonryGridView.count(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width> 480? 3 : 2,
                itemCount: productController.brandOrCategoryProductList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget(productModel: productController.brandOrCategoryProductList[index]);
                },
              ),
            ) :

            Expanded(child: productController.hasData! ?

            ProductShimmer(isHomePage: false,
                isEnabled: Provider.of<ProductController>(context).brandOrCategoryProductList.isEmpty)
                : const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noProduct,
              message: 'no_product_found',)),

          ]);
        },
      ),
    );
  }

  List<Widget> _buildImageWidgets() {
    return widget.categoryModel.images!.map((image) {
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