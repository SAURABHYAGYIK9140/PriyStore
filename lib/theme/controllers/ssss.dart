import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
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
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    _selected = -1;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        filename = pickedFile.name ?? 'No file chosen';
        if (kDebugMode) {
          print('pickedFile: $filename');
        }
      });
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
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
              ),
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
              const SizedBox(height: Dimensions.paddingSizeSmall),
              widget.productModel!.choiceOptions != null &&
                  widget.productModel!.choiceOptions!.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    widget.productModel!.choiceOptions!.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right:
                          Dimensions.paddingSizeExtraSmall,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = index;
                              print("selected: $_selected");
                            });
                            // details.setCartVariationIndex(
                            //   widget.productModel!.minimumOrderQty,
                            //   index,
                            //   0,
                            //   context,
                            // );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _selected == index
                                  ? const Color(0xFF3952F3)
                                  : Color(0xFFFFFFFF),
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: _selected == index
                                    ? const Color(0xFFF05A22)
                                    : const Color(0xFF3952F3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.productModel?.choiceOptions![index].title}',
                                style: titilliumRegular.copyWith(
                                  color: _selected == index
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFF3952F3),
                                  fontSize:
                                  Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
                  : const SizedBox(),
            ],
          );
        },
      ),
    )
        : Container(); // Return an empty container if productModel is null
  }
}
