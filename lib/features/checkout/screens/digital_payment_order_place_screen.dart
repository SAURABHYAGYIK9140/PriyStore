import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
//
// class DigitalPaymentScreen extends StatefulWidget {
//   final String url;
//   final bool fromWallet;
//   const DigitalPaymentScreen({super.key, required this.url,  this.fromWallet = false});
//
//   @override
//   DigitalPaymentScreenState createState() => DigitalPaymentScreenState();
// }
//
// class DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
//   String? selectedUrl;
//   double value = 0.0;
//   final bool _isLoading = true;
//
//   late WebViewController controllerGlobal;
//   PullToRefreshController? pullToRefreshController;
//   late MyInAppBrowser browser;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedUrl = widget.url;
//     _initData();
//   }
//
//   void _initData() async {
//     browser = MyInAppBrowser(context);
//     if(Platform.isAndroid){
//       await InAppWebViewController.setWebContentsDebuggingEnabled(true);
//       bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
//       bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
//       if (swAvailable && swInterceptAvailable) {
//         ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
//         await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
//           shouldInterceptRequest: (request) async {
//             if (kDebugMode) {
//               print(request);
//             }
//             return null;
//           },
//         ));
//       }
//     }
//     await browser.openUrlRequest(
//         urlRequest: URLRequest(url: WebUri(selectedUrl??'')),
//         settings: InAppBrowserClassSettings(
//             webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
//             browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: Platform.isAndroid)));
//
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(canPop: false,
//       onPopInvoked: (val) => _exitApp(context),
//       child: Scaffold(
//         appBar: AppBar(title: const Text(''),backgroundColor: Theme.of(context).cardColor),
//         body: Column(crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,children: [
//
//             _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox.shrink()])),
//     );
//   }
//
//   Future<bool> _exitApp(BuildContext context) async {
//     if (await controllerGlobal.canGoBack()) {
//       controllerGlobal.goBack();
//       return Future.value(false);
//     } else {
//       Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
//       showAnimatedDialog(Get.context!, OrderPlaceDialogWidget(
//         icon: Icons.clear,
//         title: getTranslated('payment_cancelled', Get.context!),
//         description: getTranslated('your_payment_cancelled', Get.context!),
//         isFailed: true,
//       ), dismissible: false, willFlip: true);
//       return Future.value(true);
//     }
//   }
// }
//
//
//
// class MyInAppBrowser extends InAppBrowser {
//
//   final BuildContext context;
//
//   MyInAppBrowser(this.context, {
//     super.windowId,
//     super.initialUserScripts,
//   });
//
//   bool _canRedirect = true;
//
//   @override
//   Future onBrowserCreated() async {
//     if (kDebugMode) {
//       print("\n\nBrowser Created!\n\n");
//     }
//   }
//
//   @override
//   Future onLoadStart(url) async {
//     if (kDebugMode) {
//       print("\n\nStarted: $url\n\n");
//     }
//     _pageRedirect(url.toString());
//   }
//
//   @override
//   Future onLoadStop(url) async {
//     pullToRefreshController?.endRefreshing();
//     if (kDebugMode) {
//       print("\n\nStopped: $url\n\n");
//     }
//     _pageRedirect(url.toString());
//   }
//
//   @override
//   void onLoadError(url, code, message) {
//     pullToRefreshController?.endRefreshing();
//     if (kDebugMode) {
//       print("Can't load [$url] Error: $message");
//     }
//   }
//
//   @override
//   void onProgressChanged(progress) {
//     if (progress == 100) {
//       pullToRefreshController?.endRefreshing();
//     }
//     if (kDebugMode) {
//       print("Progress: $progress");
//     }
//   }
//
//   @override
//   void onExit() {
//     if(_canRedirect) {
//       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
//           builder: (_) => const DashBoardScreen()), (route) => false);
//
//
//
//       showAnimatedDialog(context, OrderPlaceDialogWidget(
//         icon: Icons.clear,
//         title: getTranslated('payment_failed', context),
//         description: getTranslated('your_payment_failed', context),
//         isFailed: true,
//       ), dismissible: false, willFlip: true);
//     }
//
//     if (kDebugMode) {
//       print("\n\nBrowser closed!\n\n");
//     }
//   }
//
//   @override
//   Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
//     if (kDebugMode) {
//       print("\n\nOverride ${navigationAction.request.url}\n\n");
//     }
//     return NavigationActionPolicy.ALLOW;
//   }
//
//   @override
//   void onLoadResource(resource) {
//   }
//
//   @override
//   void onConsoleMessage(consoleMessage) {
//     if (kDebugMode) {
//       print("""
//     console output:
//       message: ${consoleMessage.message}
//       messageLevel: ${consoleMessage.messageLevel.toValue()}
//    """);
//     }
//   }
//
//   void _pageRedirect(String url) {
//     if(_canRedirect) {
//       bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
//       bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
//       bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
//       if(isSuccess || isFailed || isCancel) {
//         _canRedirect = false;
//         close();
//       }
//       if(isSuccess){
//
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
//
//
//         showAnimatedDialog(context, OrderPlaceDialogWidget(
//           icon: Icons.done,
//           title: getTranslated('order_placed', context),
//           description: getTranslated('your_order_placed', context),
//         ), dismissible: false, willFlip: true);
//
//
//       }else if(isFailed) {
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
//             builder: (_) => const DashBoardScreen()), (route) => false);
//
//
//
//         showAnimatedDialog(context, OrderPlaceDialogWidget(
//           icon: Icons.clear,
//           title: getTranslated('payment_failed', context),
//           description: getTranslated('your_payment_failed', context),
//           isFailed: true,
//         ), dismissible: false, willFlip: true);
//
//
//       }else if(isCancel) {
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
//             builder: (_) => const DashBoardScreen()), (route) => false);
//
//
//         showAnimatedDialog(context, OrderPlaceDialogWidget(
//           icon: Icons.clear,
//           title: getTranslated('payment_cancelled', context),
//           description: getTranslated('your_payment_cancelled', context),
//           isFailed: true,
//         ), dismissible: false, willFlip: true);
//
//       }
//     }
//
//   }
//
//
//
// }


class DigitalPaymentScreen extends StatefulWidget {
  final String url;
  final bool fromWallet;

  const DigitalPaymentScreen({super.key, required this.url, this.fromWallet = false});

  @override
  _DigitalPaymentScreenState createState() => _DigitalPaymentScreenState();
}

class _DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  late String finalUrl;
  late WebViewController _controller;
  double _progress = 0;
  bool _canRedirect = true;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.url;

    if (finalUrl.contains('http://')) {
      finalUrl = finalUrl.replaceAll("http://", "https://");
      print("$finalUrl this is the final URL");
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            _pageRedirect(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _progress = 1.0;
            });
          },
          // onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            _pageRedirect(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(finalUrl));

    _initServiceWorker();
  }

  Future<void> _initServiceWorker() async {
    if (Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        // _controller.stopLoading();
      }
      if (isSuccess) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
        _showOrderDialog(Icons.done, 'order_placed', 'your_order_placed', false);
      } else if (isFailed) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
        _showOrderDialog(Icons.clear, 'payment_failed', 'your_payment_failed', true);
      } else if (isCancel) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
        _showOrderDialog(Icons.clear, 'payment_cancelled', 'your_payment_cancelled', true);
      }
    }
  }

  void _showOrderDialog(IconData icon, String title, String description, bool isFailed) {
    showAnimatedDialog(
      context,
      OrderPlaceDialogWidget(
        icon: icon,
        title: getTranslated(title, context),
        description: getTranslated(description, context),
        isFailed: isFailed,
      ),
      dismissible: false,
      willFlip: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            if (_progress < 1)
              Center(
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
