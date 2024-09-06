import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/models/suggestion_product_model.dart';
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

import '../../product/domain/models/product_model.dart';

class Newcategoryproducts extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const Newcategoryproducts({super.key, required this.isBrand, required this.id, required this.name, this.image});

  @override
  State<Newcategoryproducts> createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<Newcategoryproducts> {
  @override
  void initState() {
    Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(  '0',            "",

        widget.isBrand, widget.id, context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ProductController>(
      builder: (context, productController, child) {
        print("errrrrrrrrrr"+  productController.brandOrCategoryProductList.length.toString());
        final List<Product> newlist = [];
        for (var product in productController.brandOrCategoryProductList) {
          if(product.purchasePrice!=null)
            {
              newlist.add(product as Product);
            }

        }
        print("errrrrrrrrrr"+  newlist.length.toString());

        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

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
          newlist.isNotEmpty ?
          MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width> 480? 3 : 2,
            itemCount: newlist.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: newlist[index]);
            },
          ):const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noProduct,
            message: 'no_product_found',)

        ]);
      },
    );
  }
}