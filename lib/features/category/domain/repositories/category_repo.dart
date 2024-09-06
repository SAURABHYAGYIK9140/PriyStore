import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/repositories/category_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:path/path.dart';

class CategoryRepository implements CategoryRepoInterface {
  final DioClient? dioClient;
  CategoryRepository({required this.dioClient});

  @override
  Future<ApiResponse> getList({int? offset}) async {
    try {
    String  uri = '${AppConstants.categoriesUri}' ;
    if(offset==-1)
      {
        uri = '${AppConstants.categoriesUri}' ;
      }
    else if(offset==-2)
    {
      uri = '${AppConstants.categoriesUri}?guest_id=1''&is_bundle=1&parent_id=0';
    }
    else{
      uri = '${AppConstants.categoriesUri}?guest_id=1''&is_dhakad=1&parent_id='+offset.toString() ;

    }
    print("categoriesUri-- > "+uri.toString());


      final response = await dioClient!.get(
       uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSellerWiseCategoryList(int sellerId) async {
    try {
      final response = await dioClient!.get('${AppConstants.sellerWiseCategoryList}$sellerId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
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
}