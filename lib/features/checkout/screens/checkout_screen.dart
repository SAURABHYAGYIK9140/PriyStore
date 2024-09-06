import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/screens/offline_payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/choose_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/coupon_apply_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/wallet_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import '../../../utill/app_constants.dart';
import '../../PhonePePaymentService.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int? sellerId;
  final bool onlyDigital;
  final bool hasPhysical;
  final int quantity;

  const CheckoutScreen({super.key, required this.cartList, this.fromProductDetails = false,
    required this.discount, required this.tax, required this.totalOrderAmount, required this.shippingFee,
    this.sellerId, this.onlyDigital = false, required this.quantity, required this.hasPhysical});


  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();

  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  late bool _billingAddress;
  double? _couponDiscount;

  static  int noaddress = 0;


  @override
  void initState() {
    super.initState();
    Provider.of<AddressController>(context, listen: false).getAddressList();
    Provider.of<CouponController>(context, listen: false).removePrevCouponData();
    Provider.of<CartController>(context, listen: false).getCartData(context);
    Provider.of<CheckoutController>(context, listen: false).resetPaymentMethod();
    Provider.of<ShippingController>(context, listen: false).getChosenShippingMethod(context);
    if(Provider.of<SplashController>(context, listen: false).configModel != null &&
        Provider.of<SplashController>(context, listen: false).configModel!.offlinePayment != null)
    {
      Provider.of<CheckoutController>(context, listen: false).getOfflinePaymentList();
    }

    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
      Provider.of<CouponController>(context, listen: false).getAvailableCouponList();
    }

    _billingAddress = Provider.of<SplashController>(Get.context!, listen: false).configModel!.billingInputByCustomer == 1;

  }
  static late ProfileController profileProvider2;
  static late CheckoutController orderProvidermain;
  static String orderNote2 = "";
  static String couponCode2 = "";
  static String couponCodeAmount2 ="";
  static String addressId2 = "";
  static String billingAddressId2 = "";
  static String amount = "0";

  static void placeorder(BuildContext cont)
  {
    // orderProvidermain.digitalPaymentPlaceOrder(
    //     orderNote: orderNote2,
    //     customerId: Provider.of<AuthController>(cont, listen: false).isLoggedIn()?
    //     profileProvider2.userInfoModel?.id.toString() : Provider.of<AuthController>(cont, listen: false).getGuestToken(),
    //     addressId: addressId2,
    //     billingAddressId: billingAddressId2,
    //     couponCode: couponCode2,
    //     couponDiscount: couponCodeAmount2,
    //     paymentMethod: orderProvidermain.selectedDigitalPaymentMethodName);
    orderProvidermain.placeOrder2(conxt: cont,
        addressID :  addressId2,
        couponCode : couponCode2,
        couponAmount : couponCodeAmount2,
        billingAddressId : addressId2,
        orderNote : orderNote2);
  }
  @override
  Widget build(BuildContext context) {

    // amount= PriceConverter.convertPrice(context,
    //     (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax));
    // amount=amount.replaceAll("₹", "");
    // print("amountamountamount"+amount.toString());

    _order = widget.totalOrderAmount + widget.discount;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,

      bottomNavigationBar: Consumer<AddressController>(
          builder: (context, locationProvider,_) {
            return Consumer<CheckoutController>(
                builder: (context, orderProvider, child) {
                  orderProvidermain=orderProvider;
                  // if(AppConstants.advance_payment==false)
                  //   {
                  //     orderProvider.advanceChecked=false;
                  //   }

                  return Consumer<CouponController>(
                      builder: (context, couponProvider, _) {
                        return Consumer<CartController>(
                            builder: (context, cartProvider,_) {
                              return Consumer<ProfileController>(
                                  builder: (context, profileProvider,_) {
                                    profileProvider2=profileProvider;
                                    return orderProvider.isLoading ? const Row(
                                      mainAxisAlignment: MainAxisAlignment.center, children: [
                                      SizedBox(width: 30,height: 30,child: CircularProgressIndicator())],):

                                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                      child: CustomButton(onTap: () async {
                                        if(orderProvider.addressIndex == null && widget.hasPhysical) {

                                          // log("message");
                                          noaddress=1;
                                          // log("message"+ noaddress.toString());
                                          showCustomSnackBar(getTranslated('select_a_shipping_address', context), context, isToaster: true);
                                          setState(() {

                                          });
                                        }else if((orderProvider.billingAddressIndex == null && !widget.hasPhysical && !orderProvider.sameAsBilling) || (orderProvider.billingAddressIndex == null && _billingAddress && !orderProvider.sameAsBilling)){
                                          showCustomSnackBar(getTranslated('select_a_billing_address', context), context, isToaster: true);
                                        }

                                        else {
                                          String orderNote = orderProvider.orderNoteController.text.trim();
                                          orderNote2 = orderProvider.orderNoteController.text.trim();

                                          String couponCode = couponProvider.discount != null && couponProvider.discount != 0? couponProvider.couponCode : '';
                                          couponCode2 = couponProvider.discount != null && couponProvider.discount != 0? couponProvider.couponCode : '';
                                          String couponCodeAmount = couponProvider.discount != null && couponProvider.discount != 0?
                                          couponProvider.discount.toString() : '0';

                                          couponCodeAmount2 = couponProvider.discount != null && couponProvider.discount != 0?
                                          couponProvider.discount.toString() : '0';
                                          String addressId = !widget.onlyDigital? locationProvider.addressList![orderProvider.addressIndex!].id.toString():'';
                                          addressId2 = !widget.onlyDigital? locationProvider.addressList![orderProvider.addressIndex!].id.toString():'';
                                          String billingAddressId = (_billingAddress)? orderProvider.sameAsBilling? addressId:
                                          locationProvider.addressList![orderProvider.billingAddressIndex!].id.toString() : '';

                                          billingAddressId2 = (_billingAddress)? orderProvider.sameAsBilling? addressId:
                                          locationProvider.addressList![orderProvider.billingAddressIndex!].id.toString() : '';

                                          if(orderProvider.paymentMethodIndex != -1){
                                            orderProvider.digitalPaymentPlaceOrder(
                                              pay_in_advance: '0',
                                                orderNote: orderNote,
                                                customerId: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
                                                profileProvider.userInfoModel?.id.toString() : Provider.of<AuthController>(context, listen: false).getGuestToken(),
                                                addressId: addressId,
                                                billingAddressId: billingAddressId,
                                                couponCode: couponCode,
                                                couponDiscount: couponCodeAmount,
                                                paymentMethod: orderProvider.selectedDigitalPaymentMethodName);

                                          }else if (orderProvider.codChecked && !widget.onlyDigital){
                                            orderProvider.placeOrder(callback: _callback,
                                                addressID : widget.onlyDigital ? '': addressId,
                                                couponCode : couponCode,
                                                couponAmount : couponCodeAmount,
                                                billingAddressId : _billingAddress? billingAddressId: widget.onlyDigital ? '': addressId,
                                                orderNote : orderNote);

                                          }

                                          else if(orderProvider.offlineChecked){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                                                OfflinePaymentScreen(payableAmount: _order, callback: _callback)));}
                                          else if(orderProvider.onlineChecked){
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                                            // OfflinePaymentScreen(payableAmount: _order, callback: _callback)));


                                            final phonePePaymentService = PhonePePaymentService(
                                              advance_payment: false,
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
                                            phonePePaymentService.startPgTransaction(context);


                                            // orderProvider.digitalPaymentPlaceOrder(
                                            //     orderNote: orderNote,
                                            //     customerId: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
                                            //     profileProvider.userInfoModel?.id.toString() : Provider.of<AuthController>(context, listen: false).getGuestToken(),
                                            //     addressId: addressId,
                                            //     billingAddressId: billingAddressId,
                                            //     couponCode: couponCode,
                                            //     couponDiscount: couponCodeAmount,
                                            //     paymentMethod: 'online');
                                          }
                                          else if(orderProvider.advanceChecked){
                                            if(AppConstants.advance_payment==false)
                                              {
                                                return;

                                              }

                                            orderProvider.digitalPaymentPlaceOrder(
                                                pay_in_advance: '1',
                                                orderNote: orderNote,
                                                customerId: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
                                                profileProvider.userInfoModel?.id.toString() : Provider.of<AuthController>(context, listen: false).getGuestToken(),
                                                addressId: addressId,
                                                billingAddressId: billingAddressId,
                                                couponCode: couponCode,
                                                couponDiscount: couponCodeAmount,
                                                paymentMethod: orderProvider.selectedDigitalPaymentMethodName);
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                                            //     OfflinePaymentScreen(payableAmount: _order, callback: _callback)));
                                            // final phonePePaymentService = PhonePePaymentService(
                                            //   advance_payment: true,
                                            //
                                            //   environment: "SANDBOX",
                                            //   appId: "",
                                            //   merchantId: "PGTESTPAYUAT86",
                                            //   enableLogging: true,
                                            //   saltKey: "96434309-7796-489d-8924-ab56988a6076",
                                            //   saltIndex: "1",
                                            //   callbackUrl: "https://webhook.site/#!/view/7b246852-4c6c-452f-b42e-f96120e3ff7f",
                                            //   apiEndPoint: "/pg/v1/pay",
                                            //   packageName: "com.devolyt.priystore",
                                            // );
                                            // phonePePaymentService.startPgTransaction(context);
                                          }
                                          else if(orderProvider.walletChecked){
                                            // print("iddddddd"+(_billingAddress?
                                            // locationProvider.addressList![orderProvider.billingAddressIndex!].id.toString():
                                            // widget.onlyDigital ? '': locationProvider.addressList![orderProvider.addressIndex!].id.toString()));

                                            showAnimatedDialog(context, WalletPaymentWidget(
                                                currentBalance: profileProvider.balance??0,
                                                orderAmount: _order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax,
                                                onTap: (){if(profileProvider.balance! <
                                                    (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax)){
                                                  showCustomSnackBar(getTranslated('insufficient_balance', context), context, isToaster: true);
                                                }else{
                                                  Navigator.pop(context);
                                                  orderProvider.placeOrder(callback: _callback,wallet: true,
                                                      addressID : widget.onlyDigital ? '':
                                                      locationProvider.addressList![orderProvider.addressIndex!].id.toString(),
                                                      couponCode : couponCode,
                                                      couponAmount : couponCodeAmount,
                                                      billingAddressId : _billingAddress? billingAddressId: widget.onlyDigital ? '': addressId,

                                                      // billingAddressId : _billingAddress?
                                                      // locationProvider.addressList![orderProvider.billingAddressIndex!].id.toString():
                                                      // widget.onlyDigital ? '': locationProvider.addressList![orderProvider.addressIndex!].id.toString(),
                                                      orderNote : orderNote);}}), dismissible: false, willFlip: true);}
                                          else {
                                            setState(() {
                                              ChoosePaymentWidget.selected_method=true;

                                            });
                                            showCustomSnackBar('${getTranslated('select_payment_method', context)}', context);
                                          }
                                        }
                                      },
                                        buttonText: '${getTranslated('proceed', context)}',
                                      ),
                                    );
                                  }
                              );
                            }
                        );
                      }
                  );
                }
            );
          }
      ),

      appBar: CustomAppBar(title: getTranslated('checkout', context)),
      body: Consumer<AuthController>(
          builder: (context, authProvider,_) {
            return Consumer<CheckoutController>(
                builder: (context, orderProvider,_) {
                  return Column(children: [

                    Expanded(child: ListView(physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0), children: [
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                              child: ShippingDetailsWidget(hasPhysical: widget.hasPhysical, billingAddress: _billingAddress)),


                          if(Provider.of<AuthController>(context, listen: false).isLoggedIn())
                            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: CouponApplyWidget(couponController: _controller, orderAmount: _order)),



                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: ChoosePaymentWidget(onlyDigital: widget.onlyDigital)),

                          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall),
                              child: Text(getTranslated('order_summary', context)??'',
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),



                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Consumer<CheckoutController>(
                                  builder: (context, checkoutController, child) {
                                    try{
                                      amount= PriceConverter.convertPrice(context,
                                          (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax));
                                      amount=amount.replaceAll("₹", "");
                                      print("amountamountamount"+amount.toString());
                                    }catch(e){
                                      print("amountamountamount"+e.toString());

                                    }
                                    _couponDiscount = Provider.of<CouponController>(context).discount ?? 0;

                                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      widget.quantity>1?
                                      AmountWidget(title: '${getTranslated('sub_total', context)} ${' (${widget.quantity} ${getTranslated('items', context)}) '}',
                                          amount: PriceConverter.convertPrice(context, _order)):
                                      AmountWidget(title: '${getTranslated('sub_total', context)} ${'(${widget.quantity} ${getTranslated('item', context)})'}',
                                          amount: PriceConverter.convertPrice(context, _order)),
                                      AmountWidget(title: getTranslated('shipping_fee', context),
                                          amount: PriceConverter.convertPrice(context, widget.shippingFee)),
                                      AmountWidget(title: getTranslated('discount', context),
                                          amount: PriceConverter.convertPrice(context, widget.discount)),
                                      AmountWidget(title: getTranslated('coupon_voucher', context),
                                          amount: PriceConverter.convertPrice(context, _couponDiscount)),
                                      AmountWidget(title: getTranslated('tax', context),
                                          amount: PriceConverter.convertPrice(context, widget.tax)),
                                      Divider(height: 5, color: Theme.of(context).hintColor),

                                      (orderProvider.advanceChecked)?
                                      Column(
                                        children: [
                                          AmountWidget(
                                            title: getTranslated('total_payable', context),
                                            amount: PriceConverter.convertPrice(
                                              context,
                                              (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax) * 0.3,
                                            ),
                                          ),
  ],
                                      ):AmountWidget(title: getTranslated('total_payable', context),
                                          amount: PriceConverter.convertPrice(context,
                                              (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax)))

                                    ]);})),


                          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Text('${getTranslated('order_note', context)}',
                                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge))]),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                CustomTextFieldWidget(
                                    hintText: getTranslated('enter_note', context),
                                    inputType: TextInputType.multiline,
                                    inputAction: TextInputAction.done,
                                    maxLines: 3,
                                    focusNode: _orderNoteNode,
                                    controller: orderProvider.orderNoteController)])),
                        ]),
                    ),
                  ],
                  );
                }
            );
          }
      ),
    );
  }

    void _callback( bool isSuccess, String message, String orderID) async {
    if(isSuccess) {
      Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
      showAnimatedDialog(context, OrderPlaceDialogWidget(
        icon: Icons.check,
        title: getTranslated('order_placed', context),
        description: getTranslated('your_order_placed', context),
        isFailed: false,
      ), dismissible: false, willFlip: true);
    }else {
      showCustomSnackBar(message, context, isToaster: true);
    }
  }
}

class PhonePePaymentService {
  final bool advance_payment;
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

  PhonePePaymentService({
    required this.advance_payment,
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
    print("boduy"+body.toString());
  }

  String getChecksum() {
    // print("sss"+CheckoutScreenState.amount.toString());
    int amount = (int.parse(CheckoutScreenState.amount.replaceAll(".00", "").replaceAll(",", "")) * 100);
    if(advance_payment)
      {
        amount = (amount * 30) ~/ 100;
      }

    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT${getRandomNumber()}",
      "merchantUserId": "MU${getRandomNumber()}",
      "amount":amount,
      // "amount": int.parse('1')*100,
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
      Fluttertoast.showToast(msg: 'PhonePe SDK Initialized - $val');
    }).catchError((error) {
      handleError(error);
    });
  }

  Future<void> startPgTransaction(BuildContext context) async {
    try {
      var response = PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, packageName);
      response.then((val) async {
        if (val != null) {
          String status = val['status'].toString();
          String error = val['error'].toString();

          if (status == 'SUCCESS') {
            // Fluttertoast.showToast(msg: "Flow complete - status : SUCCESS");
            CheckoutScreenState.placeorder(context);

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
