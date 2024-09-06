import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../product/screens/BrandAndCategoryProductScreen2.dart';
import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatefulWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {

  @override
  Widget build(BuildContext context) {
    print("getCategoryList");

    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {

        return categoryProvider.homecategoryList.isNotEmpty ?
        SizedBox( height: Provider.of<LocalizationController>(context, listen: false).isLtr? MediaQuery.of(context).size.width/3.7 : MediaQuery.of(context).size.width/3,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categoryProvider.homecategoryList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell( splashColor: Colors.transparent, highlightColor: Colors.transparent,
                  onTap: () {
                    // final productController = Provider.of<CategoryController>(context, listen: false);
                    // productController.homecategoryList.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen2(
                    isBrand: false,
                    catname: categoryProvider.homecategoryList[index],
                    id: categoryProvider.homecategoryList[index].id.toString(),
                    name: categoryProvider.homecategoryList[index].name)));
                },
                child: CategoryWidget(category: categoryProvider.homecategoryList[index],
                    index: index,length:  categoryProvider.homecategoryList.length));
            },
          ),
        ) : const CategoryShimmerWidget();

      },
    );
  }
}



