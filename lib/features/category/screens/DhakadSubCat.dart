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
import '../controllers/category_controller.dart';
import '../domain/models/category_model.dart';
import 'NewCategory_screen.dart';
import '../widgets/SubCategoryListWIdget.dart';
import '../widgets/category_list_widget.dart';
import '../../product/domain/models/product_model.dart';
import '../../product/screens/BrandAndCategoryProductScreen2.dart';

class Dhakadsubcat extends StatefulWidget {
  final CategoryModel catname;
  final bool isBrand;
  final bool showproduct;
  final String id;
  final String? name;
  final String? image;
  const Dhakadsubcat({super.key, required this.catname, required this.showproduct,required this.isBrand, required this.id, required this.name, this.image});

  @override
  State<Dhakadsubcat> createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<Dhakadsubcat> with RouteAware {
  late CategoryController categoryController;


  // @override
  // void dispose() {
  //   if (mounted) {
  //     // Future.microtask(() {
  //     //   Future.microtask(() {
  //     //     categoryController.clearCategoryList();
  //     //     // categoryController.getCategoryList( int.parse("28"), true);
  //     //     categoryController.getCategoryList( int.parse(widget.catname.id.toString()), true);
  //     //
  //     //   });
  //     //
  //     //   Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(  '0',
  //     //       '',
  //     //       widget.isBrand, widget.id, context);
  //     // });
  //   }
  //   super.dispose();
  // }
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
    print("triggerd--->didPopdidPopdidPop");
    // _loaddata();
    super.didPop();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    print("triggerd--->didPushdidPushdidPush");
    _loaddata();

    super.didPush();
  }
  @override
  void didPushNext() {
    // TODO: implement didPushNext
    print("triggerd--->didPushNextdidPushNextdidPushNext");
    // _loaddata();

    super.didPushNext();
  }
  @override
  void didPopNext() {
    print("triggerd--->didPopNextdidPopNextdidPopNext");

    // Called when the current route is shown again after popping a route off the navigator stack
_loaddata();

  }
  @override
  void initState() {
    final categoryController = Provider.of<ProductController>(context, listen: false);
    categoryController.cleardata();
    _loaddata();

    super.initState();
  }
  void _loaddata()
  {
    print("_loaddata_loaddata");
    int? catid=widget.catname.id;
    if(widget.catname.name!=null)
    {
      catid=int.parse(widget.catname.id.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(Get.context!, listen: false).getCategoryList(
        catid ?? 0,
        true,
      );
      categoryController = Provider.of<CategoryController>(context, listen: false);
      Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(  '0',
          '',
          widget.isBrand, catid.toString(), context);
  });
  }
  @override
  Widget build(BuildContext context) {
    print("catidididiiddi"+widget.id);
    print("catidididiiddi"+widget.catname.name.toString());

    return Consumer<ProductController>(
      builder: (context, productController, child) {
        print("BrandAndCategoryProductScreen2-->"+  productController.brandOrCategoryProductList.length.toString());
        // final List<Product> newlist = [];
        // for (var product in productController.brandOrCategoryProductList) {
        //   if(product.purchasePrice!=null)
        //   {
        //     newlist.add(product as Product);
        //   }
        // }
        final List<Product> newlist = [];
        final Set<int> productIds = {}; // Assuming each product has a unique non-null ID

        for (var product in productController.brandOrCategoryProductList) {
          if (product.purchasePrice != null && product.id != null) {
            if (productIds.add(product.id!)) { // Using the non-null assertion operator
              newlist.add(product as Product);
            }
          }
        }
        print("DhakadsubcatDhakadsubcatnewlist"+newlist.length.toString());


        return Scaffold(
          appBar: CustomAppBar(title: widget.name),
          body: Consumer<ProductController>(
            builder: (context, productController, child) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if(widget.catname.images!.isNotEmpty)
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
                  //       items: widget.catname.images!.isEmpty
                  //           ? [SizedBox()]
                  //           : _buildImageWidgets(),
                  //     ),
                  //   ),
                  // ),


                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraSmall,
                    vertical: 0),
                    child: TitleRowWidget(title: getTranslated('SUBCATEGORY', context),
                      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                      // const HomecategoryScreen(isHomePage: true)))),),
                      // const NewcategoryScreen()

                    )
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                SizedBox(height: 10),
                Subcategorylistwidget(widget.catname,int.parse(widget.catname.id.toString()),true),

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
                          : Expanded(
                        child: productController.hasData!
                            ? Expanded(
                              child: ProductShimmer(isHomePage: false, isEnabled: newlist.isEmpty),
                            )
                            : const NoInternetOrDataScreenWidget(
                          isNoInternet: false,
                          icon: Images.noProduct,
                          message: 'no_product_found',
                        ),

                ),

              ]);
            },
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