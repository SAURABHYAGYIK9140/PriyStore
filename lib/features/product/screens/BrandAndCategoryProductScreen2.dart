import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

import '../../../common/basewidget/title_row_widget.dart';
import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../ImageSliderWithIndicator.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/domain/models/category_model.dart';
import '../../category/screens/NewCategory_screen.dart';
import '../../category/widgets/SubCategoryListWIdget.dart';
import '../../category/widgets/category_list_widget.dart';
import '../domain/models/product_model.dart';

class BrandAndCategoryProductScreen2 extends StatefulWidget {
  final CategoryModel catname;
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen2({
    super.key,
    required this.catname,
    required this.isBrand,
    required this.id,
    required this.name,
    this.image,
  });

  @override
  State<BrandAndCategoryProductScreen2> createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<BrandAndCategoryProductScreen2> with RouteAware {
  late CategoryController categoryController;
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showShimmer = false;
      });
    });
    categoryController = Provider.of<CategoryController>(context, listen: false);
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeObserver = Provider.of<RouteObserver<ModalRoute>>(context, listen: false);
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    final routeObserver = Provider.of<RouteObserver<ModalRoute>>(context, listen: false);
    routeObserver.unsubscribe(this);
    super.dispose();
  }
  @override
  void didPop() {
    // TODO: implement didPop
    _loadData();

    super.didPop();
  }
  @override
  void didPopNext() {
    // Called when the current route is shown again after popping a route off the navigator stack
    _loadData();
  }

  void _loadData() {
    Provider.of<CategoryController>(Get.context!, listen: false).getCategoryList(
      widget.catname.id ?? 0,
      true,
    );
    Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(
      '0',
      '',
      widget.isBrand,
      widget.catname.id.toString(),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BrandAndCategoryProductScreen2BrandAndCategoryProductScreen2");
    return Consumer<ProductController>(
      builder: (context, productController, child) {
        // final List<Product> newlist = productController.brandOrCategoryProductList
        //     .where((product) => product.purchasePrice != null)
        //     .toList();
        final List<Product> newlist = [];
        final Set<int> productIds = {}; // Assuming each product has a unique non-null ID

        for (var product in productController.brandOrCategoryProductList) {
          if (product.purchasePrice != null && product.id != null) {
            if (productIds.add(product.id!)) { // Using the non-null assertion operator
              newlist.add(product as Product);
            }
          }
        }
        return Scaffold(
          appBar: CustomAppBar(title: widget.name),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.catname.images!.isNotEmpty)
                ImageSliderWithIndicator(widget.catname.images),
                // SizedBox(
                //   height: 160,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: CarouselSlider(
                //       options: CarouselOptions(
                //         height: 160,
                //         aspectRatio: 16 / 9,
                //         viewportFraction: 0.92,
                //         initialPage: 0,
                //         enableInfiniteScroll: true,
                //         reverse: false,
                //         autoPlay: true,
                //         autoPlayInterval: Duration(seconds: 3),
                //         autoPlayAnimationDuration: Duration(milliseconds: 800),
                //         autoPlayCurve: Curves.fastOutSlowIn,
                //         enlargeCenterPage: true,
                //         enlargeFactor: 0.3,
                //         scrollDirection: Axis.horizontal,
                //       ),
                //       items: _buildImageWidgets(),
                //     ),
                //   ),
                // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraSmall, vertical: 0),
                child: TitleRowWidget(
                  title: getTranslated('SUBCATEGORY', context),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Subcategorylistwidget(widget.catname, int.parse(28.toString()),false),
              widget.isBrand
                  ? Container(
                height: 100,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                color: Theme.of(context).highlightColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageWidget(
                      image:
                      '${Provider.of<SplashController>(context, listen: false).baseUrls!.brandImageUrl}/${widget.image}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        widget.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              newlist.isNotEmpty
                  ? Expanded(
                child: MasonryGridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width > 480 ? 3 : 2,
                  itemCount: newlist.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(productModel: newlist[index]);
                  },
                ),
              )
              //     : Expanded(
              //   child: productController.hasData!
              //       ? ProductShimmer(isHomePage: false, isEnabled: newlist.isEmpty)
              //       : const NoInternetOrDataScreenWidget(
              //     isNoInternet: false,
              //     icon: Images.noProduct,
              //     message: 'no_product_found',
              //   ),
              // ),
                  : Expanded(
        child: _showShimmer
        ? ProductShimmer(isHomePage: false, isEnabled: newlist.isEmpty)
            : productController.hasData!
        ? Container() // Replace with your actual data widget
            : const NoInternetOrDataScreenWidget(
        isNoInternet: false,
        icon: Images.noProduct,
        message: 'no_product_found',
        ),
        ),
            ],
          ),
        );
      },
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
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            AppConstants.baseUrl + "/storage/app/public/product/" + image,
          ),
        ),
      );
    }).toList();
  }
}