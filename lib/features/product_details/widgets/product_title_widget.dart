import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

import '../../../utill/app_constants.dart';
import '../../product/domain/models/product_model.dart';

class ProductTitleWidget extends StatefulWidget {
  final ProductDetailsModel? productModel;
  final String? averageRatting;

  const ProductTitleWidget({Key? key, required this.productModel, this.averageRatting})
      : super(key: key);

  @override
  State<ProductTitleWidget> createState() => _ProductTitleWidgetState();
}

class _ProductTitleWidgetState extends State<ProductTitleWidget> {
  double? startingPrice = 0;
  double? endingPrice;
  String filename = 'No file chosen';
  File? _image;
  // int _selected = -1;
  int _selectedcolor = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductDetailsController>(context, listen: false).initData(
        widget.productModel!,
        widget.productModel!.minimumOrderQty,
        context);
    // _selected = -1;
     _selectedcolor = 0;
    Future.delayed(Duration(milliseconds: 100), () {
      String selectedColor = widget.productModel!.colors![0].code.toString().replaceFirst('#', '');
      print("colorcode --> " + selectedColor);

      List<ColorImage>? colorImages = widget.productModel!.colorImage;
      int foundIndex = colorImages?.indexWhere((item) => item.color == selectedColor) ?? -1;

      if (foundIndex != -1) {
        print('Color found at index: $foundIndex');
      } else {
        print('Color not found');
      }
      ProductImageWidget.controller.animateToPage(foundIndex, duration: const Duration(microseconds: 50), curve:Curves.ease);
    });
  }


  @override
  Widget build(BuildContext context) {
    // print("productDetailsModel"+widget.productModel!.choiceOptions!. length.toString());
    // print("productDetailsModel"+widget.productModel!.choiceOptions![0].options.toString());

    if (widget.productModel != null &&
        widget.productModel!.variation != null &&
        widget.productModel!.variation!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in widget.productModel!.variation!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if (priceList[0]! < priceList[priceList.length - 1]!) {
        endingPrice = priceList[priceList.length - 1];
      }
    } else {
      startingPrice = widget.productModel!.unitPrice;
    }

    return widget.productModel != null
        ? Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.homePagePadding),
      child: Consumer<ProductDetailsController>(


        builder: (context, details, child) {
          double priceWithQuantity=0.0;
          // if( widget.productModel!.choiceOptions!.length<2)
          // {
            Variation? variation;
            String? variantName = (widget.productModel!.colors != null &&
                widget.productModel!.colors!.isNotEmpty) ?
            widget.productModel!.colors![details.variantIndex!].name : null;
            List<String> variationList = [];
            for (int index = 0; index <
                widget.productModel!.choiceOptions!.length; index++) {
              variationList.add(
                  widget.productModel!.choiceOptions![index].options![details
                      .variationIndex![index]].trim());
            }
            String variationType = '';
            if (variantName != null) {
              variationType = variantName;
              for (var variation in variationList) {
                variationType = '$variationType-$variation';
              }
            } else {
              bool isFirst = true;
              for (var variation in variationList) {
                if (isFirst) {
                  variationType = '$variationType$variation';
                  isFirst = false;
                } else {
                  variationType = '$variationType-$variation';
                }
              }
            }
            double? price = widget.productModel!.unitPrice;
            int? stock = widget.productModel!.currentStock;
            variationType = variationType.replaceAll(' ', '');
            for (Variation variation in widget.productModel!.variation!) {
              if (variation.type == variationType) {
                price = variation.price;
                variation = variation;
                stock = variation.qty;
                break;
              }
            }
            double priceWithDiscount = PriceConverter.convertWithDiscount(
                context,
                price, widget.productModel!.discount, widget.productModel!.discountType)!;
             priceWithQuantity = priceWithDiscount * details.quantity!;

          // }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Text(
                widget.productModel!.name ?? '',
                style: titleRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       bottom: Dimensions.paddingSizeDefault),
              //   child: Row(
              //     children: [
              //       Text(
              //         '${startingPrice != null ? PriceConverter.convertPrice(
              //           context,
              //           startingPrice,
              //           discount: widget.productModel!.discount,
              //           discountType:
              //           widget.productModel!.discountType,
              //         ) : ''}'
              //             '${endingPrice != null ? ' - ${PriceConverter
              //             .convertPrice(
              //             context,
              //             endingPrice,
              //             discount:
              //             widget.productModel!.discount,
              //             discountType:
              //             widget.productModel!
              //                 .discountType)}' : ''}',
              //         style: titilliumBold.copyWith(
              //           color: ColorResources.getPrimary(context),
              //           fontSize: Dimensions.fontSizeLarge,
              //         ),
              //       ),
              //       widget.productModel!.discount != null &&
              //           widget.productModel!.discount! > 0
              //           ? Flexible(
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal:
              //             Dimensions.paddingSizeSmall,
              //           ),
              //           child: Text(
              //             '${PriceConverter.convertPrice(
              //               context,
              //               startingPrice,
              //             )}'
              //                 '${endingPrice != null ? ' - ${PriceConverter
              //                 .convertPrice(
              //                 context,
              //                 endingPrice)}' : ''}',
              //             style: titilliumRegular.copyWith(
              //               color: Theme.of(context).hintColor,
              //               decoration:
              //               TextDecoration.lineThrough,
              //             ),
              //           ),
              //         ),
              //       )
              //           : const SizedBox(),
              //       if (widget.productModel != null &&
              //           widget.productModel!.discount != null &&
              //           widget.productModel!.discount! > 0)
              //         Container(
              //           padding: const EdgeInsets.all(
              //             Dimensions.paddingSizeExtraSmall,
              //           ),
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //             color: Theme.of(context)
              //                 .colorScheme
              //                 .error
              //                 .withOpacity(.20),
              //             borderRadius: BorderRadius.circular(
              //               Dimensions.paddingSizeExtraSmall,
              //             ),
              //           ),
              //           child: Text(
              //             PriceConverter.percentageCalculation(
              //               context,
              //               widget.productModel!.unitPrice,
              //               widget.productModel!.discount,
              //               widget.productModel!.discountType,
              //             ),
              //             style: textRegular.copyWith(
              //               color: Theme.of(context).colorScheme.error,
              //               fontSize: Dimensions.fontSizeLarge,
              //             ),
              //           ),
              //         ),
              //     ],
              //   ),
              // ),


              //total_price
              (endingPrice == null)?               Padding(
              padding: const EdgeInsets.only(
          bottom: Dimensions.paddingSizeDefault),
          child: Row(
          children: [
          Text(
          '${startingPrice != null ? PriceConverter.convertPrice(
          context,
          startingPrice,
          discount: widget.productModel!.discount,
          discountType:
          widget.productModel!.discountType,
          ) : ''}'
          '${endingPrice != null ? ' - ${PriceConverter
              .convertPrice(
          context,
          endingPrice,
          discount:
          widget.productModel!.discount,
          discountType:
          widget.productModel!
              .discountType)}' : ''}',
          style: titilliumBold.copyWith(
          color: ColorResources.getPrimary(context),
          fontSize: Dimensions.fontSizeLarge,
          ),
          ),
          widget.productModel!.discount != null &&
          widget.productModel!.discount! > 0
          ? Flexible(
          child: Padding(
          padding: const EdgeInsets.symmetric(
          horizontal:
          Dimensions.paddingSizeSmall,
          ),
          child: Text(
          '${PriceConverter.convertPrice(
          context,
          startingPrice,
          )}'
          '${endingPrice != null ? ' - ${PriceConverter
              .convertPrice(
          context,
          endingPrice)}' : ''}',
          style: titilliumRegular.copyWith(
          color: Theme.of(context).hintColor,
          decoration:
          TextDecoration.lineThrough,
          ),
          ),
          ),
          )
              : const SizedBox(),
          if (widget.productModel != null &&
          widget.productModel!.discount != null &&
          widget.productModel!.discount! > 0)
          Container(
          padding: const EdgeInsets.all(
          Dimensions.paddingSizeExtraSmall,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .error
              .withOpacity(.20),
          borderRadius: BorderRadius.circular(
          Dimensions.paddingSizeExtraSmall,
          ),
          ),
          child: Text(
          PriceConverter.percentageCalculation(
          context,
          widget.productModel!.unitPrice,
          widget.productModel!.discount,
          widget.productModel!.discountType,
          ),
          style: textRegular.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontSize: Dimensions.fontSizeLarge,
          ),
          ),
          ),
          ],
          ),
          ):
              Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(getTranslated('total_price', context)!+" : " ,
                        style: robotoBold),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                        PriceConverter.convertPrice(context, priceWithQuantity),
                        style: titilliumBold.copyWith(color: ColorResources
                            .getPrimary(context), fontSize: Dimensions
                            .fontSizeLarge)),
                    widget.productModel!.taxModel == 'exclude' ?
                    Padding(padding: const EdgeInsets.only(top: Dimensions
                        .paddingSizeExtraSmall),
                        child: Text('(${getTranslated(
                            'tax', context)} : ${widget.productModel?.tax}%)',
                            style: titilliumRegular.copyWith(
                                color: ColorResources.hintTextColor,
                                fontSize: Dimensions.fontSizeDefault))) :
                    Padding(padding: const EdgeInsets.only(top: Dimensions
                        .paddingSizeExtraSmall),
                        child: Text('(${getTranslated('tax', context)} ${widget
                            .productModel!.taxModel})',
                            style: titilliumRegular.copyWith(
                                color: ColorResources.hintTextColor,
                                fontSize: Dimensions.fontSizeDefault)))
                  ])),

              Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: Row(
                  children: [
                    RatingBar(
                      rating: widget.productModel!.reviews != null
                          ? widget.productModel!.reviews!.isNotEmpty
                          ? double.parse(widget.averageRatting!)
                          : 0.0
                          : 0.0,
                    ),
                    Text('(${widget.productModel?.reviewsCount})'),
                  ],
                ),
              ),
              Consumer<ReviewController>(

                builder: (context, reviewController, _) {

                  return Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                              '${reviewController.reviewList != null ? reviewController.reviewList!.length : 0} ',
                              style: textMedium.copyWith(
                                color: Provider.of<ThemeController>(
                                  context,
                                  listen: false,
                                ).darkTheme
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${getTranslated('reviews', context)} | ',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${details.orderCount} ',
                              style: textMedium.copyWith(
                                color: Provider.of<ThemeController>(
                                  context,
                                  listen: false,
                                ).darkTheme
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${getTranslated('orders', context)} | ',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${details.wishCount} ',
                              style: textMedium.copyWith(
                                color: Provider.of<ThemeController>(
                                  context,
                                  listen: false,
                                ).darkTheme
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${getTranslated('wish_listed', context)}',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),


              widget.productModel!.colors != null && widget.productModel!.colors!.isNotEmpty ?
              Row(children: [
                Text('${getTranslated('select_variant', context)} : ',
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
                Expanded(child: SizedBox(height: 40,
                    child: ListView.builder(
                      itemCount: widget.productModel!.colors!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,

                      itemBuilder: (context, index) {
                        String colorString = '0xff${widget.productModel!.colors![index]
                            .code!.substring(1, 7)}';
                        return GestureDetector(
                          onTap: () {

                            String selectedColor = widget.productModel!.colors![index].code.toString().replaceFirst('#', '');
                            print("colorcode --> " + selectedColor);

                            List<ColorImage>? colorImages = widget.productModel!.colorImage;
                            int foundIndex = colorImages?.indexWhere((item) => item.color == selectedColor) ?? -1;

                            if (foundIndex != -1) {
                              print('Color found at index: $foundIndex');
                            } else {
                              print('Color not found');
                            }
                            ProductImageWidget.controller.animateToPage(foundIndex, duration: const Duration(microseconds: 50), curve:Curves.ease);


                            details.setImageSliderSelectedIndex(index);
                            details.setCartVariantIndex(widget.productModel!.minimumOrderQty, index, context);

                            setState(() {
                              _selectedcolor=index;
                              AppConstants.selectedcoloreindex=index;
                            });


                          },
                          child: Center(child: Container(
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(
                              //         Dimensions.paddingSizeExtraSmall)),
                              decoration: BoxDecoration(
                                color: _selectedcolor == index
                                    ? Color(0xFFFF0000)
                                    : Color(0xFFFFFFFF),
                                borderRadius:
                                BorderRadius.circular(20),
                                // border: Border.all(
                                //   // color: _selectedcolor == index
                                //   //     ? Color(0xFFF05A22)
                                //   //     : Color(0xFF3952F3),
                                // ),
                              ),
                              child: Padding(padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                                  child: Container(height: 20,
                                      width: 20,
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(int.parse(colorString)),
                                          borderRadius: BorderRadius.circular(
                                              30)))))),
                        );
                      },))),
              ]) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              //sizes
              // widget.productModel!.choiceOptions != null &&
              //     widget.productModel!.choiceOptions!.isNotEmpty
              //     ? SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //
              //       Text('Available size : ',
              //           style: titilliumRegular.copyWith(
              //               fontSize: Dimensions.fontSizeLarge)),
              //       Row(
              //         children: List.generate(
              //           widget.productModel!.choiceOptions!.length,
              //               (index) {
              //             return Padding(
              //               padding: const EdgeInsets.only(
              //                 right:
              //                 Dimensions.paddingSizeExtraSmall,
              //               ),
              //               child: GestureDetector(
              //                 onTap: () {
              //                   setState(() {
              //                     _selected = index;
              //                     AppConstants.selectedsizeindex=index;
              //                     print("selected: $_selected");
              //                   });
              //                   // details.setCartVariationIndex(
              //                   //   widget.productModel!.minimumOrderQty,
              //                   //   index,
              //                   //   0,
              //                   //   context,
              //                   // );
              //                 },
              //                 child: Container(
              //                   width: 40,
              //                   height: 40,
              //                   decoration: BoxDecoration(
              //                     color: _selected == index
              //                         ? Color(0xFF3952F3)
              //                         : Color(0xFFFFFFFF),
              //                     borderRadius:
              //                     BorderRadius.circular(20),
              //                     border: Border.all(
              //                       width: 1,
              //                       color: _selected == index
              //                           ? Color(0xFFF05A22)
              //                           : Color(0xFF3952F3),
              //                     ),
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       '${widget.productModel?.choiceOptions![index].title}',
              //                       style: titilliumRegular.copyWith(
              //                         color: _selected == index
              //                             ? Color(0xFFFFFFFF)
              //                             : Color(0xFF3952F3),
              //                         fontSize:
              //                         Dimensions.fontSizeDefault,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       ),
              //       // Variation
              //     ],
              //   ),
              //
              // )
              //     : const SizedBox(),


              widget.productModel!.choiceOptions!=null && widget.productModel!.choiceOptions!.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.productModel!.choiceOptions!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('${getTranslated('available', context)} ${widget.productModel!.choiceOptions![index].title} :',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Expanded(child: Padding(padding: const EdgeInsets.all(2.0),
                            child: SizedBox(height: 40,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: widget.productModel!.choiceOptions![index].options!.length,
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            details.setCartVariationIndex(widget.productModel!.minimumOrderQty, index, i, context);
                                            // _selected = i;
                                            AppConstants.selectedsizeindex=i;
                                            print("selected: $details.variationIndex![index]");
                                          });
                                          // details.setCartVariationIndex(
                                          //   widget.productModel!.minimumOrderQty,
                                          //   i,
                                          //   0,
                                          //   context,
                                          // );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: details.variationIndex![index] == i
                                                  ? Color(0xFF3952F3)
                                                  : Color(0xFFFFFFFF),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              border: Border.all(
                                                width: 1,
                                                color: details.variationIndex![index] == i
                                                    ? Color(0xFFF05A22)
                                                    : Color(0xFF3952F3),
                                              ),
                                            ),

                                            child: Center(child: Padding(padding: const EdgeInsets.only(right:0),
                                                child: Text(widget.productModel!.choiceOptions![index].options![i].trim(), maxLines: 1,
                                                    overflow: TextOverflow.ellipsis, style: textRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeLarge,
                                                      color: details.variationIndex![index] == i

                                                          ? Color(0xFFFFFFFF)
                                                          : Color(0xFF3952F3),
                                                       )))),
                                          ),
                                        ),
                                      );
                                    })))),
                      ]);
                },
              ):const SizedBox(),
            ],
          );
        },
      ),
    )
        : Container(); // Return an empty container if productModel is null
  }
}
