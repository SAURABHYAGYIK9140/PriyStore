import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/bottom_cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_specification_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_title_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/promise_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/related_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/review_and_specification_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/shop_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/widgets/review_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_product_view_list.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../utill/color_resources.dart';
import '../../PhonpePayment.dart';
import '../../home/shimmers/product_details_shimmer.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;

  const ProductDetails({
    super.key,
    required this.productId,
    required this.slug,
    this.isFromWishList = false,
  });

  @override
  State<ProductDetails> createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  File? _image;
  String filename = 'No file chosen';

  @override
  void initState() {
    _loadData(context);
    imageFiles?.clear();
    addimagecheck=false;
    textController.clear();
    super.initState();
  }

  void _loadData(BuildContext context) {
    Provider.of<ProductDetailsController>(context, listen: false)
        .getProductDetails(
            context, widget.productId.toString(), widget.slug.toString());
    Provider.of<ProductDetailsController>(context, listen: false)
        .getSharableLink(
         widget.slug.toString(), context);
    Provider.of<ReviewController>(context, listen: false).removePrevReview();
    Provider.of<ReviewController>(context, listen: false)
        .getReviewList(widget.productId, widget.slug, context);
    Provider.of<ProductController>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductController>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsController>(context, listen: false)
        .getCount(widget.productId.toString(), context);
  }

 static final TextEditingController textController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
 static List<XFile>? imageFiles = [];
static bool addimagecheck=false;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_details', context)),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<ProductDetailsController>(

          builder: (context, details, child) {
            // print("brandId"+details.productDetailsModel?.brandId.toString() );
            // if( details.productDetailsModel?.brandId == 3)
            // {
            //   addimagecheck=true;
            // }
            // if (details.productDetailsModel != null && details.productDetailsModel!.brandId != null) {
            //
            //   print('productDetailsModel' +
            //       details.productDetailsModel!.brandId.toString() +
            //       '--' +
            //       details.productDetailsModel!.name.toString());
            //   if (details.productDetailsModel?.brandId == 3) {
            //     details.setisprint("1");
            //   } else {
            //     details.setisprint("0");
            //   }
            // }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !details.isDetails
                  ? Column(
                      children: [
                        SizedBox(height: 10),
                        ProductImageWidget(
                            productModel: details.productDetailsModel),
                        details.productDetailsModel?.brandId == 3
                            ? Container(

                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Container(
                                        height: 50,
                                        child: TextField(
                                          controller: textController,
                                          // Assign the controller

                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter the requirement',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                                // if(details.productDetailsModel!=null && details.productDetailsModel!.brandId!=null)
                                                // {
                                                //   print('productDetailsModel' +
                                                //       details.productDetailsModel!.brandId.toString() +
                                                //       '--' +
                                                //       details.productDetailsModel!.name.toString());
                                                //   if (details.productDetailsModel?.brandId == 3) {
                                                //     details.setisprint("1");
                                                //   } else {
                                                //     details.setisprint("0");
                                                //   }
                                                //
                                                // }

                                              imageFiles?.clear();
                                              details.setprint_remark(
                                                  textController.text);
                                              final List<XFile>? pickedFiles =
                                                  await _picker
                                                      .pickMultiImage();
                                              if (pickedFiles != null &&
                                                  pickedFiles.isNotEmpty) {
                                                setState(() {
                                                  if (pickedFiles.length > 5) {
                                                    // If more than 5 images are picked, add only the first 5 to _imageFiles
                                                    imageFiles ??= []; // Initialize _imageFiles if it's null
                                                    for (int i = 0; i < 13; i++) {
                                                      imageFiles!.add(pickedFiles[i]);
                                                    }
                                                  } else {
                                                    // If 5 or fewer images are picked, assign pickedFiles directly to _imageFiles
                                                    imageFiles = pickedFiles;
                                                  }


                                                  print("_imageFiles"+imageFiles!.length.toString());
                                                  details.setimagelist(
                                                      pickedFiles);
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorResources.colorMap[900],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            child: Text(
                                              'Upload image',
                                              style: TextStyle(
                                                  color: ColorResources.white),
                                            ),
                                          ),
                                          // ElevatedButton(
                                          //   onPressed: () async {
                                          //     final phonePePaymentService = PhonePePaymentService(
                                          //       environment: "PROD",
                                          //       appId: "your-app-id",
                                          //       merchantId: "PRIYSTOREONLINE",
                                          //       enableLogging: true,
                                          //       saltKey: "4c1fedaa-484a-4e29-ad25-74bacf3d75c0",
                                          //       saltIndex: "1",
                                          //       callbackUrl: "https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1",
                                          //       apiEndPoint: "/pg/v1/pay",
                                          //       packageName: "com.devolyt.priystore",
                                          //     );
                                          //     phonePePaymentService.startPgTransaction(context);
                                          //   },
                                          //   style: ElevatedButton.styleFrom(
                                          //     backgroundColor:
                                          //     ColorResources.colorMap[900],
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 20, vertical: 10),
                                          //     textStyle: TextStyle(
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          //   child: Text(
                                          //     'Pay in Advance',
                                          //     style: TextStyle(
                                          //         color: ColorResources.white),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < imageFiles!.length; i++)
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Image.file(
                                                      File(imageFiles![i].path),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        imageFiles?.removeAt(i);
                                                      });
                                                    },
                                                    child: Icon(
                                                      size: 16,
                                                      CupertinoIcons.multiply_circle,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            // if()
                            ProductTitleWidget(
                              productModel: details.productDetailsModel,
                              averageRatting:
                                  details.productDetailsModel?.averageReview ??
                                      "0",
                            ),
                            const ReviewAndSpecificationSectionWidget(),
                            details.isReviewSelected
                                ? ReviewSection(details: details)
                                : Column(
                                    children: [
                                      details.productDetailsModel?.details !=
                                                  null &&
                                              details.productDetailsModel!
                                                  .details!.isNotEmpty
                                          ? Container(
                                              height: 250,
                                              margin: const EdgeInsets.only(
                                                  top: Dimensions
                                                      .paddingSizeSmall),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              child: ProductSpecificationWidget(
                                                productSpecification: details
                                                        .productDetailsModel!
                                                        .details ??
                                                    '',
                                              ),
                                            )
                                          : SizedBox(),
                                      details.productDetailsModel?.videoUrl !=
                                              null
                                          ? YoutubeVideoWidget(
                                              url: details.productDetailsModel!
                                                  .videoUrl)
                                          : SizedBox(),
                                      details.productDetailsModel != null
                                          ? ShopInfoWidget(
                                              sellerId: details
                                                          .productDetailsModel!
                                                          .addedBy ==
                                                      'seller'
                                                  ? details.productDetailsModel!
                                                      .userId
                                                      .toString()
                                                  : "0")
                                          : SizedBox.shrink(),
                                      SizedBox(
                                          height: Dimensions.paddingSizeLarge),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: Dimensions.paddingSizeLarge,
                                            bottom:
                                                Dimensions.paddingSizeDefault),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor),
                                        child: PromiseWidget(),
                                      ),
                                      details.productDetailsModel != null &&
                                              details.productDetailsModel!
                                                      .addedBy ==
                                                  'seller'
                                          ? Consumer<SellerProductController>(
                                              builder: (context,
                                                  sellerProductController, _) {
                                                return (sellerProductController.sellerProduct != null &&
                                                        sellerProductController
                                                                .sellerProduct!
                                                                .products !=
                                                            null &&
                                                        sellerProductController
                                                            .sellerProduct!
                                                            .products!
                                                            .isNotEmpty)
                                                    ? Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: Dimensions
                                                                .paddingSizeDefault),
                                                        child: TitleRowWidget(
                                                          title: getTranslated(
                                                              'more_from_the_shop',
                                                              context),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    TopSellerProductScreen(
                                                                  fromMore:
                                                                      true,
                                                                  sellerId: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.id,
                                                                  temporaryClose: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.temporaryClose,
                                                                  vacationStatus: details
                                                                          .productDetailsModel
                                                                          ?.seller
                                                                          ?.shop
                                                                          ?.vacationStatus ??
                                                                      false,
                                                                  vacationEndDate: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.vacationEndDate,
                                                                  vacationStartDate: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.vacationStartDate,
                                                                  name: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.name,
                                                                  banner: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.banner,
                                                                  image: details
                                                                      .productDetailsModel
                                                                      ?.seller
                                                                      ?.shop
                                                                      ?.image,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : SizedBox();
                                              },
                                            )
                                          : SizedBox(),
                                      details.productDetailsModel?.addedBy ==
                                              'seller'
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeDefault),
                                              child: ShopProductViewList(
                                                scrollController:
                                                    scrollController,
                                                sellerId: details
                                                    .productDetailsModel!
                                                    .userId!,
                                              ),
                                            )
                                          : SizedBox(),
                                      Consumer<ProductController>(
                                        builder:
                                            (context, productController, _) {
                                          return (productController
                                                          .relatedProductList !=
                                                      null &&
                                                  productController
                                                      .relatedProductList!
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: TitleRowWidget(
                                                    title: getTranslated(
                                                        'related_products',
                                                        context),
                                                    isDetailsPage: true,
                                                  ),
                                                )
                                              : SizedBox();
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault),
                                        child: RelatedProductWidget(),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    )
                  : ProductDetailsShimmer(),
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<ProductDetailsController>(
        builder: (context, details, child) {
          return !details.isDetails
              ? BottomCartWidget(product: details.productDetailsModel)
              : SizedBox();
        },
      ),
    );
  }
}
