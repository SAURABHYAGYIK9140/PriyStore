import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';

class ChoosePaymentWidget extends StatefulWidget {
  final bool onlyDigital;
  static bool selected_method=false;

  const ChoosePaymentWidget({super.key, required this.onlyDigital});

  @override
  State<ChoosePaymentWidget> createState() => _ChoosePaymentWidgetState();
}

class _ChoosePaymentWidgetState extends State<ChoosePaymentWidget> {

  @override
  Widget build(BuildContext context) {
    print("selected_method"+ChoosePaymentWidget.selected_method.toString());
    print("selected_method"+AppConstants.advance_payment.toString());
    return Consumer<CheckoutController>(
      builder: (context, orderProvider, _) {
        if(AppConstants.advance_payment==false)
        {

          // if()
          // orderProvider.onlineChecked=true;
        }
        return Consumer<SplashController>(
          builder: (context, configProvider, _) {
            bool isPaymentMethodSelected = orderProvider.paymentMethodIndex != -1 || orderProvider.codChecked || orderProvider.offlineChecked || orderProvider.walletChecked;
            return Card(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: isPaymentMethodSelected==ChoosePaymentWidget.selected_method ? Colors.transparent : Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${getTranslated('payment_method', context)}',
                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        InkWell(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (c) => PaymentMethodBottomSheetWidget(onlyDigital: widget.onlyDigital),
                          ),
                          child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3)),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: .125),
                        if (orderProvider.paymentMethodIndex != -1)
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: CustomImageWidget(
                                  image: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayImage ?? ''}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                child: Text(configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayTitle ?? ''),
                              ),
                            ],
                          )
                        else if (orderProvider.codChecked)
                          Text(getTranslated('cash_on_delivery', context) ?? '')
                        else if (orderProvider.offlineChecked)
                            Text(getTranslated('offline_payment', context) ?? '')
                          else if (orderProvider.walletChecked)
                              Text(getTranslated('wallet_payment', context) ?? '')
                            else if (orderProvider.onlineChecked)
                                Text("Pay online")
                              else if (orderProvider.advanceChecked && AppConstants.advance_payment==true)
                                  Text("Advance payment")
                                else
                              InkWell(
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (c) => PaymentMethodBottomSheetWidget(onlyDigital: widget.onlyDigital),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.add_circle_outline_outlined, size: 20, color: Theme.of(context).primaryColor),
                                    ),
                                    Text(
                                      '${getTranslated('add_payment_method', context)}',
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
