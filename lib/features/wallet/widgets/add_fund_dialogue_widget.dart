
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/custom_check_box_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../common/basewidget/animated_custom_dialog_widget.dart';
import '../../../data/datasource/remote/dio/dio_client.dart';
import '../../../data/datasource/remote/exception/api_error_handler.dart';
import '../../../data/model/api_response.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../checkout/widgets/order_place_dialog_widget.dart';

class AddFundDialogueWidget extends StatelessWidget {
  const AddFundDialogueWidget({super.key, required this.focusNode, required this.inputAmountController});
  final FocusNode focusNode;
  final TextEditingController inputAmountController;


  @override

  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,
      child: Padding(padding: const EdgeInsets.all(8.0),
        child: Consumer<CheckoutController>(
          builder: (context, digitalPaymentProvider,_) {
            return Consumer<SplashController>(
              builder: (context, configProvider,_) {
                return SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: InkWell(onTap: () => Navigator.pop(context),
                          child: Align(alignment: Alignment.topRight,child: Icon(Icons.cancel,
                            color: Theme.of(context).hintColor, size: 30,))),),

                    Container(decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
                      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                          Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeSmall,
                          Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Text(getTranslated('add_fund_to_wallet', context)!,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeDefault),
                            child: Text(getTranslated('add_fund_form_secured_digital_payment_gateways', context)!,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),),


                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              border: Border.all(width: .5,color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                              Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(.5))),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(configProvider.myCurrency!.symbol!,
                                        style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                            color:  Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.75) )),
                                  ),
                                  IntrinsicWidth(
                                    child: TextField(
                                      controller: inputAmountController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      textAlign: TextAlign.center,
                                      style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: 'Ex: 500')))]))),


                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault,
                              right: Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              Text('${getTranslated('add_money_via_online', context)}',
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                child: Text('${getTranslated('fast_and_secure', context)}',
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).hintColor)))])),


                          Consumer<SplashController>(
                              builder: (context, configProvider,_) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: configProvider.configModel?.paymentMethods?.length??0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return  CustomCheckBoxWidget(index: index,
                                      icon: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel?.paymentMethods?[index].additionalDatas?.gatewayImage??''}',
                                      name: configProvider.configModel!.paymentMethods![index].keyName!,
                                      title: configProvider.configModel!.paymentMethods![index].additionalDatas?.gatewayTitle??'');
                                  },
                                );
                              }),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: CustomButton(
                              buttonText: getTranslated('add_fund', context)!,
                              onTap: () {
                                if(digitalPaymentProvider.selectedDigitalPaymentMethodName.isEmpty){
                                  digitalPaymentProvider.setDigitalPaymentMethodName(0,
                                      configProvider.configModel!.paymentMethods![0].keyName!);
                                }
                                if(inputAmountController.text.trim().isEmpty){
                                  showCustomSnackBar('${getTranslated('please_input_amount', context)}', context);
                                }else if(double.parse(inputAmountController.text.trim()) <= 0){
                                  showCustomSnackBar('${getTranslated('please_input_amount', context)}', context);
                                }else if(digitalPaymentProvider.paymentMethodIndex == -1){

                                  final phonePePaymentService = PhonePePaymentService(
                                    amt: inputAmountController.text.trim(),
                                    environment: "SANDBOX",
                                    appId: "",
                                    merchantId: "PGTESTPAYUAT86",
                                    enableLogging: true,
                                    saltKey: "96434309-7796-489d-8924-ab56988a6076",
                                    saltIndex: "1",
                                    callbackUrl: "https://webhook.site/#!/view/7b246852-4c6c-452f-b42e-f96120e3ff7f",
                                    apiEndPoint: "/pg/v1/pay",
                                    packageName: "com.devolyt.priystore",
                                  );
                                  phonePePaymentService.startPgTransaction(Provider.of<WalletController>(context, listen: false),context);
                                  showCustomSnackBar('${getTranslated('please_select_any_payment_type', context)}', context);
                                }else{
                                  Provider.of<WalletController>(context, listen: false).addFundToWallet(inputAmountController.text.trim(), digitalPaymentProvider.selectedDigitalPaymentMethodName);
                                }
                              },
                            ),
                          ),
                        ],),
                      ),
                    ),
                  ],),
                );
              }
            );
          }
        ),
      ),
    );
  }
}
class PhonePePaymentService {
  final String amt;
  final String environment;
  final String appId;
  final String merchantId;
  final bool enableLogging;
  final String saltKey;
  final String saltIndex;
  final String callbackUrl;
  final String apiEndPoint;
  final String packageName;

  late String transactionId;
  late String checksum;
  late String body;

  PhonePePaymentService( {
    required this.amt,
    required this.environment,
    required this.appId,
    required this.merchantId,
    required this.enableLogging,
    required this.saltKey,
    required this.saltIndex,
    required this.callbackUrl,
    required this.apiEndPoint,
    required this.packageName,
  }) {
    transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    phonepeInit();
    body = getChecksum();

    print("boduy"+amt.toString());
    print("boduy"+body.toString());
  }

  String getChecksum() {
    // print("sss"+CheckoutScreenState.amount.toString());
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT${getRandomNumber()}",
      "merchantUserId": "MU${getRandomNumber()}",
      // "amount": int.parse(CheckoutScreenState.amount.replaceAll(".00", "").replaceAll(",", ""))*100,
      "amount": int.parse(amt.toString())*100,
      "mobileNumber": "7011134381",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"},
    };


    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    return base64Body;
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging).then((val) {
      // Fluttertoast.showToast(msg: 'PhonePe SDK Initialized - $val');
    }).catchError((error) {
      handleError(error);
    });
  }

  Future<void> startPgTransaction(WalletController walletctlr, BuildContext context) async {
    Navigator.pop(context);
    try {
      var response = PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, packageName);
      response.then((val) async {
        if (val != null) {
          String status = val['status'].toString();
          String error = val['error'].toString();

          if (status == 'SUCCESS') {
            Fluttertoast.showToast(msg: "Flow complete - status : SUCCESS");
            walletctlr.addFundToWallet(amt,
               'phonepay');
            await checkStatus();

          } else {
            // Fluttertoast.showToast(msg: "Flow complete - status : $status and error $error");
            Fluttertoast.showToast(msg: " $status and error $error");
          }
        } else {
          Fluttertoast.showToast(msg: "Flow Incomplete");
        }
      }).catchError((error) {
        print("sssssss"+error.toString());
        handleError(error);
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    Fluttertoast.showToast(msg: "Error: ${error.toString()}");
  }

  Future<void> checkStatus() async {
    try {
      String url = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
      String concatenatedString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
      String hashedString = sha256.convert(utf8.encode(concatenatedString)).toString();
      String xVerify = "$hashedString###$saltIndex";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-MERCHANT-ID": merchantId,
        "X-VERIFY": xVerify,
      };

      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> res = jsonDecode(response.body);
          if (res["code"] == "PAYMENT_SUCCESS" && res['data']['responseCode'] == "SUCCESS") {
            Fluttertoast.showToast(msg: res["message"]);
          } else {
            Fluttertoast.showToast(msg: "Something went wrong");
          }
        } catch (e) {
          print("Failed to decode JSON: ${e.toString()}");
        }
      } else {
        print("API request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  String getRandomNumber() {
    Random random = Random();
    String randomMerchant = "";
    for (int i = 0; i < 15; i++) {
      randomMerchant += random.nextInt(10).toString();
    }
    return randomMerchant;
  }
}
