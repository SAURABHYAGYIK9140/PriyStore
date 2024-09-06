
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';

import '../../../product_details/screens/product_details_screen.dart';


class CartRepository implements CartRepositoryInterface<ApiResponse>{
  final DioClient? dioClient;
  CartRepository({required this.dioClient, });


  @override
  Future<ApiResponse> getList({int? offset}) async {
    try {
      final response = await dioClient!.get('${AppConstants.getCartDataUri}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      print("getCartDataUri"+response.realUri.toString());
      print("getCartDataUri"+response.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override

  Future<ApiResponse> addToCartListData(CartModelBody cart, List<ChoiceOptions> choiceOptions, List<int>? variationIndexes) async {
    Map<String, dynamic> choice = {}; // Ensure map has String keys

    for(int index=0; index<choiceOptions.length; index++){
      // Ensure choiceOptions[index].name is a String (null-safe check)
      if (choiceOptions[index].name != null) {
        choice.addAll({choiceOptions[index].name!: 'placeholder_value'}); // Use null-assertion for key
        // Update with actual value from choiceOptions[index].options[variationIndexes[index]]
        choice[choiceOptions[index].name!] = choiceOptions[index].options![variationIndexes![index]];
      } else {
        // Handle the case where choiceOptions[index].name is null (optional)
        print('Warning: choiceOptions[$index].name is null');
      }
    }

    Map<String, dynamic> data = {
      'id': cart.productId,
      'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
      'variant': cart.variation?.type, // Use null-safe operator
      'quantity': cart.quantity,
      'is_print': cart.is_print,
      'print_remark': cart.print_remark,
    };
    print("cartproductId"+data.toString());
    data.addAll(choice);
    if(cart.variant?.isNotEmpty ?? false) { // null-safe check for variant
      data.addAll({'color': cart.color});
    }
    List<XFile>? imageFileslist = cart.imageFileslist;
    print('Error reading image file: '+imageFileslist!.length.toString());
    try {
      FormData formData = FormData.fromMap(data);

      for (int i = 0; i < imageFileslist!.length; i++) {
        String? imagePath = imageFileslist[i].path;
        if (imagePath != null && imagePath.isNotEmpty) {
          try {
            List<int> imageBytes = await File(imagePath).readAsBytes();
            var mimeType = lookupMimeType(imagePath);
            formData.files.add(MapEntry(
              'print_image[]',
              MultipartFile.fromBytes(
                imageBytes,
                filename: 'print_image.${mimeType?.split('/')[1]}',
              ),
            ));
          } catch (e) {
            if (e is FileSystemException) {
              print('Error reading image file: $e');
              // Handle file system error (e.g., show a user-friendly message)
            } else {
              print('Unknown error reading image file: $e');
              // Handle other types of errors if needed
            }
          }
        }
      }
      print("ffffffff"+formData.toString());
      final response = await dioClient!.post(AppConstants.addToCartUri, data: formData);
      ProductDetailsState.textController.clear();

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  // Future<ApiResponse> addToCartListData(CartModelBody cart, List<ChoiceOptions> choiceOptions, List<int>? variationIndexes) async {
  //   Map<String?, dynamic> choice = {};
  //   for(int index=0; index<choiceOptions.length; index++){
  //     choice.addAll({choiceOptions[index].name: choiceOptions[index].options![variationIndexes![index]]});
  //   }
  //
  //   Map<String?, dynamic> data = {
  //     'id': cart.productId,
  //     'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
  //     'variant': cart.variation?.type,
  //     'quantity': cart.quantity,
  //     'is_print': cart.is_print,
  //     'print_remark': cart.print_remark,
  //     'print_image': cart.print_image,
  //
  //   };
  //   data.addAll(choice);
  //   if(cart.variant!.isNotEmpty) {
  //     data.addAll({'color': cart.color});
  //   }
  //
  //   try {
  //     final response = await dioClient!.post(AppConstants.addToCartUri, data: data);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }




  @override
  Future<ApiResponse> updateQuantity(int? key,int quantity) async {
    try {
      final response = await dioClient!.post(AppConstants.updateCartQuantityUri,
        data: {'_method': 'put',
          'key': key,
          'quantity': quantity,
          'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> delete(int? key) async {
    try {
      final response = await dioClient!.post(AppConstants.removeFromCartUri,
          data: {'_method': 'delete',
            'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            'key': key});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }
}
