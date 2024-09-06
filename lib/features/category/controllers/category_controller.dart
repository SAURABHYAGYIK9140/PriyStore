import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/services/category_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';

class CategoryController extends ChangeNotifier {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});


  late List<CategoryModel> _categoryListmain = [];
  late List<CategoryModel> _categoryList = [];
  final List<CategoryModel> _homecategoryList = [];
  int? _categorySelectedIndex;

  List<CategoryModel> get categoryListmain => _categoryListmain;
  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get homecategoryList => _homecategoryList;
  int? get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryListmain(int  id,bool reload) async {
    // if(id>=0)
    //   {
    //     _categoryList.clear();
    //     notifyListeners();
    //
    //   }
    if(reload)
    {
      _categoryListmain = [];
      // _categoryList.clear();
      _categorySelectedIndex = 0;
      notifyListeners();
    }
    if (_categoryListmain.isEmpty || reload) {
      ApiResponse apiResponse = await categoryServiceInterface!.getList(id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryListmain.clear();
        apiResponse.response!.data.forEach((category) => _categoryListmain.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        // ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }
  Future<void> getCategoryList(int  id,bool reload) async {
    // if(id>=0)
    //   {
    //     _categoryList.clear();
    //     notifyListeners();
    //
    //   }
    if(reload)
    {
      _categoryList = [];
      // _categoryList.clear();
      _categorySelectedIndex = 0;
      notifyListeners();
    }
    if (_categoryList.isEmpty || reload) {
      ApiResponse apiResponse = await categoryServiceInterface!.getList(id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response!.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        // ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }
  Future<void> gethomeCategoryList(int  id,bool reload) async {
    // if(id>=0)
    //   {
    //     _categoryList.clear();
    //     notifyListeners();
    //
    //   }
    if(reload)
    {
      _homecategoryList.clear();
      _categorySelectedIndex = 0;
      notifyListeners();
    }
    if (_homecategoryList.isEmpty || reload) {
      ApiResponse apiResponse = await categoryServiceInterface!.getList(id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _homecategoryList.clear();
        apiResponse.response!.data.forEach((category) => _homecategoryList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
        for (CategoryModel categoryModel in  _homecategoryList)
          {
            if(categoryModel.name=="Dhakad Trend")
              {
                AppConstants.dhakadcategoryModel=categoryModel;
              }
          }

      } else {
        // ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }
  Future<void> getSellerWiseCategoryList(int sellerId) async {
      ApiResponse apiResponse = await categoryServiceInterface!.getSellerWiseCategoryList(sellerId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response!.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        // ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();

  }

  List<int> selectedCategoryIds = [];
  void checkedToggleCategory(int index){
    _categoryList[index].isSelected = !_categoryList[index].isSelected!;
    notifyListeners();
  }

  void checkedToggleSubCategory(int index, int subCategoryIndex){
    _categoryList[index].subCategories![subCategoryIndex].isSelected = !_categoryList[index].subCategories![subCategoryIndex].isSelected!;
    notifyListeners();
  }

  void resetChecked(int? id, bool fromShop){
    if(fromShop){
      getSellerWiseCategoryList(id!);
      Provider.of<BrandController>(Get.context!, listen: false).getSellerWiseBrandList(id);
      Provider.of<SellerProductController>(Get.context!, listen: false).getSellerProductList(id.toString(), 1, "");
    }else{
      getCategoryList(-1,true);
      Provider.of<BrandController>(Get.context!, listen: false).getBrandList(true);
    }


  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
  // Add this method
  void clearCategoryList() {
    if (kDebugMode) {
      print("clearCategoryList");
    }
    if(_categoryList.isNotEmpty)
      {
        print("clearCategoryList@@");

        _categoryList.clear();
        _categorySelectedIndex = 0;
        notifyListeners();
      }
  }
}
