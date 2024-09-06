import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/DhakadSubCat.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../product/controllers/product_controller.dart';
import '../../product/screens/BrandAndCategoryProductScreen2.dart';
import '../../product/screens/BrandAndCategoryProductScreen3.dart';
import '../domain/models/category_model.dart';
import 'category_shimmer_widget.dart';

class Subcategorylistwidget extends StatefulWidget {
  final CategoryModel catname;
  final int catid;
  final bool showpros;

  Subcategorylistwidget(this.catname,this.catid,this.showpros);

  @override
  State<Subcategorylistwidget> createState() => _SubcategorylistwidgetState();
}

class _SubcategorylistwidgetState extends State<Subcategorylistwidget> {

  @override
  void initState() {
    super.initState();
    print("widgetidd"+widget.catname.id.toString());
    int catid=widget.catid;
    if(widget.catname.name!=null)
      {
        catid=int.parse(widget.catname.id.toString());
      }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<CategoryController>(Get.context!, listen: false).getCategoryList(
      //   catid ?? 0,
      //   true,
      // );
      // Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(
      //   catid.toString(),
      //   "",
      //   false,
      //   // Provider.of<CategoryController>(context, listen: false).categoryList[0].id.toString(),
      //   catid.toString(),
      //   context,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    // final categoryController = Provider.of<CategoryController>(context, listen: false);
    // categoryController.clearCategoryList();
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {

        return categoryProvider.categoryList.isNotEmpty ?
        SizedBox( height: Provider.of<LocalizationController>(context, listen: false).isLtr? MediaQuery.of(context).size.width/3.7 : MediaQuery.of(context).size.width/3,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categoryProvider.categoryList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell( splashColor: Colors.transparent, highlightColor: Colors.transparent,
                  onTap: () {
                print("catidddd"+widget.catid.toString());
                // if(widget.catname.id==28)
                //   {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Dhakadsubcat(
                        isBrand: false,
                          showproduct: false,
                          catname: categoryProvider.categoryList[index],
                          id:categoryProvider.categoryList[index].id.toString(),
                          name: categoryProvider.categoryList[index].name,
                        ),
                      ),
                    );

                //   }else{
                //   Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen3(
                //       categoryModel: categoryProvider.categoryList[index],
                //       isBrand: false,
                //       id: categoryProvider.categoryList[index].id.toString(),
                //       name: categoryProvider.categoryList[index].name)));
                //
                // }
                        },
                  child: CategoryWidget(category: categoryProvider.categoryList[index],
                      index: index,length:  categoryProvider.categoryList.length));
            },
          ),
        ) : const SizedBox();

      },
    );
  }
}



