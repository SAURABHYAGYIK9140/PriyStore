
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_widget.dart';

import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/latest_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/custom_app_bar_widget.dart';
import '../../../common/basewidget/product_widget.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../Slider.dart';
import 'StreepProducts.dart';


class Streepallproducts extends StatelessWidget {
  List<Product>? mainproductList;
  String name;
  bool home;


  Streepallproducts(this.home,this.mainproductList, this.name);

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList =mainproductList;

        return productList != null? productList.isNotEmpty ?
        Scaffold(
          appBar: CustomAppBar(title:name ,),
          backgroundColor: ColorResources.getHomeBg(context),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(children: [
            
              SizedBox(height: 20,),
            
              // const SizedBox(height: Dimensions.paddingSizeSmall),
              Stack(children: [
            
                MasonryGridView.count(
                  itemCount:home==true?4: productList.length,
                  crossAxisCount: ResponsiveHelper.isTab(context)? 3 :2,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => ProductWidget(productModel: productList![index]),
                )
            
            
                // Padding(padding: EdgeInsets.only(right: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .18 : 0),
                //       child: SizedBox(height: MediaQuery.of(context).size.width * 1,
                //           width: MediaQuery.of(context).size.width * .85,
                //           child: Image.asset(Images.bgLatest))),
                //   SizedBox(height: MediaQuery.of(context).size.width,
                //       child: Swiper(autoplay: false,
                //           allowImplicitScrolling: true,
                //           autoplayDisableOnInteraction: true,
                //           autoplayDelay: Duration.minutesPerHour,
                //           layout: SwiperLayout.TINDER,
                //           itemWidth: MediaQuery.of(context).size.width * .75,
                //           itemHeight: MediaQuery.of(context).size.width * 1.2,
                //           itemBuilder: (BuildContext context,int index)=> LatestProductWidget(productModel :productList![index] ),
                //           itemCount: productList.length)),
              ],
              ),
            ],
            ),
          ),
        ): const SizedBox.shrink() : const LatestProductShimmer();
      },
    );
  }
}

