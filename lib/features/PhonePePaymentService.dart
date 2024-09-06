// import 'dart:convert';
// import 'dart:math';
//
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:http/http.dart' as http;
//
// class PhonePePaymentService {
//   final String environment;
//   final String appId;
//   final String merchantId;
//   final bool enableLogging;
//   final String saltKey;
//   final String saltIndex;
//   final String callbackUrl;
//   final String apiEndPoint;
//   final String packageName;
//
//   late String transactionId;
//   late String checksum;
//   late String body;
//
//   PhonePePaymentService({
//     required this.environment,
//     required this.appId,
//     required this.merchantId,
//     required this.enableLogging,
//     required this.saltKey,
//     required this.saltIndex,
//     required this.callbackUrl,
//     required this.apiEndPoint,
//     required this.packageName,
//   }) {
//     transactionId = DateTime.now().millisecondsSinceEpoch.toString();
//     phonepeInit();
//     body = getChecksum();
//   }
//
//   String getChecksum() {
//     final requestData = {
//       "merchantId": merchantId,
//       "merchantTransactionId": "MT${getRandomNumber()}",
//       "merchantUserId": "MU${getRandomNumber()}",
//       "amount": 100,
//       "mobileNumber": "7011134385",
//       "callbackUrl": callbackUrl,
//       "paymentInstrument": {"type": "PAY_PAGE"},
//     };
//
//     String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
//     checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
//     return base64Body;
//   }
//
//   void phonepeInit() {
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging).then((val) {
//       Fluttertoast.showToast(msg: 'PhonePe SDK Initialized - $val');
//     }).catchError((error) {
//       handleError(error);
//     });
//   }
//
//   Future<void> startPgTransaction(BuildContext context) async {
//     try {
//       var response = PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, packageName);
//       response.then((val) async {
//         if (val != null) {
//           String status = val['status'].toString();
//           String error = val['error'].toString();
//           if (status == 'SUCCESS') {
//             Fluttertoast.showToast(msg: "Flow complete - status : SUCCESS");
//             await checkStatus();
//           } else {
//             Fluttertoast.showToast(msg: "Flow complete - status : $status and error $error");
//           }
//         } else {
//           Fluttertoast.showToast(msg: "Flow Incomplete");
//         }
//       }).catchError((error) {
//         handleError(error);
//       });
//     } catch (error) {
//       handleError(error);
//     }
//   }
//
//   void handleError(error) {
//     Fluttertoast.showToast(msg: "Error: ${error.toString()}");
//   }
//
//   Future<void> checkStatus() async {
//     try {
//       String url = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
//       String concatenatedString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
//       String hashedString = sha256.convert(utf8.encode(concatenatedString)).toString();
//       String xVerify = "$hashedString###$saltIndex";
//
//       Map<String, String> headers = {
//         "Content-Type": "application/json",
//         "X-MERCHANT-ID": merchantId,
//         "X-VERIFY": xVerify,
//       };
//
//       http.Response response = await http.get(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         try {
//           Map<String, dynamic> res = jsonDecode(response.body);
//           if (res["code"] == "PAYMENT_SUCCESS" && res['data']['responseCode'] == "SUCCESS") {
//             Fluttertoast.showToast(msg: res["message"]);
//           } else {
//             Fluttertoast.showToast(msg: "Something went wrong");
//           }
//         } catch (e) {
//           print("Failed to decode JSON: ${e.toString()}");
//         }
//       } else {
//         print("API request failed with status: ${response.statusCode}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//   }
//
//   String getRandomNumber() {
//     Random random = Random();
//     String randomMerchant = "";
//     for (int i = 0; i < 15; i++) {
//       randomMerchant += random.nextInt(10).toString();
//     }
//     return randomMerchant;
//   }
// }
