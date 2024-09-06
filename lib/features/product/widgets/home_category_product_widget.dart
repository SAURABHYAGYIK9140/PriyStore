import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/home_category_item_widget.dart';
import 'package:provider/provider.dart';

import '../../../localization/controllers/localization_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/domain/models/category_model.dart';
import '../../category/widgets/CategoryWidget2.dart';
import '../../category/widgets/category_shimmer_widget.dart';
import '../../category/widgets/category_widget.dart';
import '../screens/BrandAndCategoryProductScreen2.dart';

class HomeCategoryProductWidget extends StatelessWidget {
  final bool isHomePage;
  const HomeCategoryProductWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, homeCategoryProductController, child) {
        print("HomeCategoryProductWidget"+homeCategoryProductController.homeCategoryProductList
        .length.toString());

        return homeCategoryProductController.homeCategoryProductList.isNotEmpty ?
        Container(
          height: Provider.of<LocalizationController>(context, listen: false).isLtr? MediaQuery.of(context).size.width/3.7 : MediaQuery.of(context).size.width/3,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: homeCategoryProductController.homeCategoryProductList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell( splashColor: Colors.transparent, highlightColor: Colors.transparent,
                  onTap: () {
                    final productController = Provider.of<CategoryController>(context, listen: false);
                    productController.homecategoryList.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen2(
                        isBrand: false,
                        catname:  homeCategoryProductController.homeCategoryProductList[index],
                        id: homeCategoryProductController.homeCategoryProductList[index].id.toString(),
                        name: homeCategoryProductController.homeCategoryProductList[index].name)));
                  },
                  child: CategoryWidget(category:  homeCategoryProductController.homeCategoryProductList[index] ,
                      index: index,length: homeCategoryProductController.homeCategoryProductList.length));
            },
          ),
        ) : const CategoryShimmerWidget();
      },
    );
  }
}


