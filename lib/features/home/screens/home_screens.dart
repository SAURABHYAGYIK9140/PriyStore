import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/StreepModel.dart';
import 'package:flutter_sixvalley_ecommerce/features/HomeCustomeSlider.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/StreepProducts.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/featured_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/home_category_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/products_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/recommended_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/screens/brands_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/featured_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/announcement_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banners_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/widgets/brand_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/cart_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/single_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/all_shop_screen.dart';
import 'package:provider/provider.dart';

import '../../../utill/color_resources.dart';
import '../../Slider.dart';
import '../../cart/screens/WebSocket.dart';
import '../../category/screens/HomeCategory_screen.dart';
import '../../category/screens/NewCategoryProducts.dart';
import '../../category/screens/NewCategory_screen.dart';
import '../../product/widgets/RecentFeaturedProductWidget.dart';
import '../../product/widgets/RecentProducts.dart';
import '../../product/widgets/RecommendedProducts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware{
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(bool reload) async {
    Provider.of<CategoryController>(Get.context!, listen: false).getCategoryListmain(-1,reload);

    Provider.of<BannerController>(Get.context!, listen: false).getBannerList(reload);
      Provider.of<CategoryController>(Get.context!, listen: false).gethomeCategoryList(-1,reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getHomeCategoryProductList(reload);
     await Provider.of<ShopController>(Get.context!, listen: false).getTopSellerList(reload, 1, type: "top");
     await Provider.of<ShopController>(Get.context!, listen: false).getTopSellerList(reload, -1, type: "all_seller");
     await Provider.of<BrandController>(Get.context!, listen: false).getBrandListmain(reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getLatestProductList(1, reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getDeal2prolist('1', reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getRecent('1', reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getDealoftheday('1', reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getRecomended('1', reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getFeaturedProductList('1', reload: reload);
     await Provider.of<FeaturedDealController>(Get.context!, listen: false).getFeaturedDealList(reload);
     await Provider.of<ProductController>(Get.context!, listen: false).getLProductList('1', reload: reload);
     await Provider.of<ProductController>(Get.context!, listen: false).fetchProducts();
     await Provider.of<ProductController>(Get.context!, listen: false).getRecommendedProduct();
     await Provider.of<CartController>(Get.context!, listen: false).getCartData(Get.context!);
     await Provider.of<NotificationController>(Get.context!, listen: false).getNotificationList(1);
    if(Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()){
      await  Provider.of<ProfileController>(Get.context!, listen: false).getUserInfo(Get.context!);
      await Provider.of<WishListController>(Get.context!, listen: false).getWishList();
    }
  }

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void didPopNext() {
    print("triggerd--->didPopNextdidPopNextdidPopNext");

    // Called when the current route is shown again after popping a route off the navigator stack

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorResources.headercolor, // Set the desired color here
      statusBarIconBrightness:  ColorResources.headercolor.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
    ));

  }
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Alert !!!',style: TextStyle(fontSize: 20),),
                  IconButton(
                    icon: Icon(CupertinoIcons.multiply_circle),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
              Image.asset('assets/images/in.png'), // Replace with your image asset
              SizedBox(height: 16), // Add spacing
              Text('This is an Alert dialog with an image.'),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorResources.headercolor, // Set the desired color here
      statusBarIconBrightness:  ColorResources.headercolor.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
    ));
    print("AppLifecycleState changed to:");

    singleVendor = Provider.of<SplashController>(context, listen: false).configModel!.businessMode == "single";
    Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);
    _loadData(false);
    // fetchProducts();
  }
  final List<String> imageList = [
    'https://via.placeholder.com/600x400',
    'https://via.placeholder.com/600x400',
    'https://via.placeholder.com/600x400',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorResources.headercolor, // Set the desired color here
      statusBarIconBrightness:  ColorResources.headercolor.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
    ));

    List<String?> types =[getTranslated('new_arrival', context),getTranslated('top_product', context),
     getTranslated('best_selling', context),  getTranslated('discounted_product', context)];


    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
          onRefresh: () async {
            // showCustomDialog(context);

            await _loadData( true);
            await Provider.of<FlashDealController>(Get.context!, listen: false).getFlashDealList(true, false);
            },
          child: CustomScrollView(

            controller: _scrollController, slivers: [

              SliverAppBar(
                  backgroundColor: ColorResources.headercolor,
                  floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                // backgroundColor: Theme.of(context).highlightColor,
                title: Row(children: [
                  Image.asset(Images.logoWithNameImage, height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('PriyStore', style: titilliumSemiBold.copyWith(

                        fontSize: 22,

                        color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                  ),
                ],), actions: const [
                CartHomePageWidget()]

              ),

              SliverToBoxAdapter(child: Provider.of<SplashController>(context, listen: false).configModel!.announcement!.status == '1'?
                Consumer<SplashController>(
                  builder: (context, announcement, _){
                    return (announcement.configModel!.announcement!.announcement != null && announcement.onOff)?
                    AnnouncementWidget(announcement: announcement.configModel!.announcement):const SizedBox();
                  }):const SizedBox(),),

              SliverPersistentHeader(pinned: true,
                  delegate: SliverDelegate(
                      child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                        child: const SearchHomePageWidget()))),

              SliverToBoxAdapter(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // const SizedBox(height: Dimensions.homePagePadding),






                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraSmall,
                      vertical: 0),
                    child: TitleRowWidget(title: getTranslated('CATEGORY', context),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        // const HomecategoryScreen(isHomePage: true)))),),
                        const NewcategoryScreen()))),),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                   // const CategoryListWidget(isHomePage: true),
          HomeCategoryProductWidget(isHomePage: true),
                  SizedBox(height:10),

                  const BannersWidget(),









                  Consumer<BannerController>(builder: (context, footerBannerProvider, child){
                    return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList!.isNotEmpty?
                     Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding, left:Dimensions.homePagePadding,
                         right: Dimensions.homePagePadding ),
                        child: SingleBannersWidget( bannerModel : footerBannerProvider.footerBannerList?[0])):
                    const SizedBox();}),









                  singleVendor?const SizedBox():
                  // Consumer<ShopController>(
                  //   builder: (context, topSellerProvider, child) {
                  //     return (topSellerProvider.sellerModel != null && (topSellerProvider.sellerModel!.sellers!=null && topSellerProvider.sellerModel!.sellers!.isNotEmpty))?
                  //     TitleRowWidget(title: getTranslated('top_seller', context),
                  //         onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  //         const AllTopSellerScreen( title: 'top_seller',)))):
                  //     const SizedBox();}),

                  Consumer<ShopController>(
                    builder: (context, topSellerProvider, child) {
                      return Column(

                        children: [
                          SizedBox(height:10),

                          Homecustomeslider(true),
                          SizedBox(height:10),

                          Consumer<FlashDealController>(
                            builder: (context, megaDeal, child) {
                              return  megaDeal.flashDeal != null ? megaDeal.flashDealList.isNotEmpty ?
                              Column(children: [
                                Padding(padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding,
                                    Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,
                                    Dimensions.paddingSizeExtraExtraSmall),
                                    child: TitleRowWidget(title: getTranslated('flash_deal', context),
                                        eventDuration: megaDeal.flashDeal != null ? megaDeal.duration : null,
                                        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashDealScreenView()));
                                        },isFlash: true)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(getTranslated('hurry_up_the_offer_is_limited_grab_while_it_lasts', context)??'',
                                    style: textRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                    Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                SizedBox(height: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .58 : 350, child: const Padding(
                                    padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                                    child: FlashDealsListWidget()))

                              ]) : const SizedBox.shrink() :
                              const FlashDealShimmer();},),

                          Consumer<FeaturedDealController>(
                            builder: (context, featuredDealProvider, child) {
                              return  featuredDealProvider.featuredDealProductList != null? featuredDealProvider.featuredDealProductList!.isNotEmpty ?
                              Stack(children: [
                                Container(width: MediaQuery.of(context).size.width,height: 150,
                                    color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                    Theme.of(context).primaryColor.withOpacity(.20):Theme.of(context).primaryColor.withOpacity(.125)),
                                Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                                    child: Column(children: [
                                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                                        child: TitleRowWidget(title: '${getTranslated('featured_deals', context)}',
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                          const FeaturedDealScreenView())),),
                                      ), const FeaturedDealsListWidget()

                                    ])),
                              ]) : const SizedBox.shrink() : const FindWhatYouNeedShimmer();},),

                          Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: LatestProductListWidget(false)),

                          const Padding(padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                              child: RecommendedProductWidget()),
                          TitleRowWidget(title: "Recent Products",
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.RecentProduct)))),

                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                            child: Recentfeaturedproductwidget(scrollController: _scrollController, isHome: true,type: "recent",),),

                          TitleRowWidget(title: "Recommended Products",
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.Recommended)))),

                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                            child: Recentfeaturedproductwidget(scrollController: _scrollController, isHome: true,type: "recommended",),),



                          // const Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          //     child: Recentproducts()),
                          // const Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          //     child: Recommendedproducts()),
                           Consumer<ProductController>(
                              builder: (context, featured,_) {
                                return  featured.featuredProductList != null? featured.featuredProductList!.isNotEmpty ?
                                Stack(children: [
                                  Padding(padding: const EdgeInsets.only( bottom: 25),
                                      child: Container(width: MediaQuery.of(context).size.width,
                                        height: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width/2 :MediaQuery.of(context).size.width-50,
                                        decoration: BoxDecoration(borderRadius: const BorderRadius.only(
                                            topLeft : Radius.circular(Dimensions.paddingSizeDefault),
                                            bottomLeft: Radius.circular(Dimensions.paddingSizeDefault)),
                                            color: Theme.of(context).colorScheme.onSecondaryContainer),)),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Padding(padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeExtraSmall,
                                        vertical: Dimensions.paddingSizeExtraSmall),
                                        child: Padding(padding: const EdgeInsets.only(top: 20, bottom: Dimensions.paddingSizeSmall),
                                            child: TitleRowWidget(title: getTranslated('featured_products', context),
                                                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                                    AllProductScreen(productType: ProductType.featuredProduct))
                                                )))),

                                    Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                                      child: FeaturedProductWidget(scrollController: _scrollController, isHome: true,),),
                                  ])]):const SizedBox(): const FeaturedProductShimmer();}),

                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15,),

                  Consumer<ShopController>(
                      builder: (context, topSellerProvider, child) {
                        return (topSellerProvider.sellerModel != null && (topSellerProvider.sellerModel!.sellers!=null && topSellerProvider.sellerModel!.sellers!.isNotEmpty))?
                        TitleRowWidget(title: getTranslated('top_seller', context),
                            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            const AllTopSellerScreen( title: 'top_seller',)))):
                        const SizedBox();}),

                  singleVendor?const SizedBox(height: 0):const SizedBox(height: Dimensions.paddingSizeSmall),
                  singleVendor?const SizedBox():
                  Consumer<ShopController>(
                    builder: (context, topSellerProvider, child) {
                      return (topSellerProvider.sellerModel != null && (topSellerProvider.sellerModel!.sellers!=null && topSellerProvider.sellerModel!.sellers!.isNotEmpty))?
                       Padding(padding: const EdgeInsets.only(bottom: 0),
                          child: SizedBox(height: ResponsiveHelper.isTab(context)? 170 : 165, child: TopSellerView(isHomePage: true, scrollController: _scrollController,))):const SizedBox();}),

                  // CustomeSlider(false),
                  const SizedBox(height: 10,),





                  // Provider.of<SplashController>(context, listen: false).configModel!.brandSetting == "1"?
                  // TitleRowWidget(title: getTranslated('brand', context),
                  //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  //     const BrandsView()))):const SizedBox(),
                  // SizedBox(height: Provider.of<SplashController>(context, listen: false).configModel!.brandSetting == "1"?
                  // Dimensions.paddingSizeSmall: 0),
                  // Provider.of<SplashController>(context, listen: false).configModel!.brandSetting == "1"?
                  // const BrandListWidget(isHomePage: true) : const SizedBox(),


                    // const HomeCategoryProductWidget(isHomePage: true),
                    // const SizedBox(height: Dimensions.homePagePadding),


                    // Consumer<BannerController>(builder: (context, footerBannerProvider, child){
                    //   return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList!.length>1?
                    //   SingleBannersWidget(bannerModel : footerBannerProvider.footerBannerList?[1]):const SizedBox();}),
                    // const SizedBox(height: Dimensions.homePagePadding),



                  Consumer<ProductController>(
                        builder: (ctx,prodProvider,child) {
                      return Container(decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondaryContainer),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [





                          prodProvider.streepprodlist!.isNotEmpty
                              ?
                              _getListWidgets( prodProvider.streepprodlist)
                          : SizedBox(),


                          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeSmall, 0),
                            child: Row(children: [
                              Expanded(child: Text(prodProvider.title == 'xyz' ? getTranslated('new_arrival',context)!:
                              prodProvider.title!, style: titleHeader)),
                              prodProvider.latestProductList != null ?
                              PopupMenuButton(itemBuilder: (context) {return [

                                PopupMenuItem(value: ProductType.newArrival, textStyle: textRegular.copyWith(
                                  color: Theme.of(context).hintColor), child: Text(getTranslated('new_arrival',context)??'')),

                                PopupMenuItem(value: ProductType.topProduct, textStyle: textRegular.copyWith(
                                  color: Theme.of(context).hintColor), child: Text(getTranslated('top_product',context)??'')),

                                PopupMenuItem(value: ProductType.bestSelling, textStyle: textRegular.copyWith(
                                  color: Theme.of(context).hintColor), child: Text(getTranslated('best_selling',context)??'')),

                                PopupMenuItem(value: ProductType.discountedProduct, textStyle: textRegular.copyWith(
                                    color: Theme.of(context).hintColor),
                                    child: Text(getTranslated('discounted_product',context)??''))];},
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                  child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
                                      Dimensions.paddingSizeSmall,
                                      Dimensions.paddingSizeExtraSmall,Dimensions.paddingSizeSmall ),
                                    child: Image.asset(Images.dropdown, scale: 3)),
                                  onSelected: (dynamic value) {
                                    if(value == ProductType.newArrival){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[0]);
                                    }else if(value == ProductType.topProduct){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[1]);
                                    }else if(value == ProductType.bestSelling){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[2]);
                                    }else if(value == ProductType.discountedProduct){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[3]);
                                    }
                                    ProductListWidget(isHomePage: false, productType: value, scrollController: _scrollController);
                                    Provider.of<ProductController>(context, listen: false).getLatestProductList(1, reload: true);
                                  }) : const SizedBox()])),

                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                            child: ProductListWidget(isHomePage: false, productType: ProductType.newArrival,
                                scrollController: _scrollController),),
                            const SizedBox(height: Dimensions.homePagePadding)]));}),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
  Widget _getListWidgets(List<StreepModel>? yourList) {
    return Column(
      children: yourList!.map((strip) => Column(
        children: [
          Streepproducts(true,strip.products,strip.stripName,strip.strip_background)
        ],
      )).toList(),
    );
  }

}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }

}
