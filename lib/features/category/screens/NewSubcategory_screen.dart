import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/no_internet_screen_widget.dart';
import '../../../common/basewidget/title_row_widget.dart';
import '../../../main.dart';
import '../../../utill/images.dart';
import '../../ImageSliderWithIndicator.dart';
import '../../Slider.dart';

class NewsubcategoryScreen extends StatefulWidget {
  CategoryModel catname;
  String fromdhakad;


  NewsubcategoryScreen(this.catname, this.fromdhakad);

  @override
  State<NewsubcategoryScreen> createState() => _NewsubcategoryScreenState();
}

class _NewsubcategoryScreenState extends State<NewsubcategoryScreen> {
  late CategoryController categoryController;
  String type="";
  int i=0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController = Provider.of<CategoryController>(context, listen: false);
       // type = widget.fromdhakad == "dhakadsub" ? "dhakad" : "bundle";
       type=widget.fromdhakad;
      print("type->"+type);

      if(widget.fromdhakad=="dhakadsub")
      {
        // AppConstants.bundleid=widget.catname.id;

      }else if(widget.fromdhakad=="bundle")
      {
        // AppConstants.bundleid=widget.catname.id;
      }
       print("type->"+type);
      categoryController.getCategoryList(widget.catname.id ?? 0, true);

      // String categoryId = "";
      // if (categoryController.categoryList.isNotEmpty) {
      //   categoryId = categoryController.categoryList[0].id.toString();
      // }

      // Provider.of<ProductController>(context, listen: false)
      //     .initBrandOrCategoryProductList(widget.catname.id.toString(), type, false, categoryId, context);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    Future.microtask(() {
      if (type == "") {
        // print("sssss")
        categoryController.clearCategoryList();
        categoryController.getCategoryList(-1, true);
      }

      else if (type == "bundle"){
        categoryController.clearCategoryList();
        categoryController.getCategoryList(int.parse( AppConstants.bundleid.toString()), true);
      }
      else
          {
            categoryController.clearCategoryList();
            categoryController.getCategoryList(-2, true);
          }


    });
    // categoryController.clearCategoryList();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController = Provider.of<CategoryController>(context, listen: false);

      if (ModalRoute.of(context)?.isCurrent == true) {
        String type = widget.fromdhakad == "dhakad" ? "dhakad" : "bundle";
        // Provider.of<ProductController>(context, listen: false)
        //     .initBrandOrCategoryProductList(
        //   widget.catname.id?.toString() ?? "",
        //   type,
        //   false,
        //   categoryController.categoryList.isNotEmpty
        //       ? categoryController.categoryList[0].id?.toString() ?? ""
        //       : "",
        //   context,
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("NewsubcategoryScreenNewsubcategoryScreen");

    // final categoryController = Provider.of<CategoryController>(context, listen: false);
    // categoryController.clearCategoryList();
    return Scaffold(
      appBar: CustomAppBar(title: widget.catname.name.toString()),
        body: Consumer<CategoryController>(
          builder: (context, categoryProvider, child) {
            i++;
            print("JJJJJJJ"+i.toString());

            if (categoryProvider.categoryList.isEmpty) {
              return Center(
                child: Stack(
                  children: [
                    Visibility(
                      visible: i != 1,
                      child:        ImageSliderWithIndicator(widget.catname.images),

                    ),

                    Visibility(

                      visible: i!=2,
                      child: NoInternetOrDataScreenWidget(
                        isNoInternet: false,
                        icon: Images.noProduct,
                        message: 'No products found',
                      ),
                    ),
                    Visibility(

                      visible: i==2,
                      child: Center(
                        child: CircularProgressIndicator(
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(height: 10),
                  if (widget.catname.images!.isNotEmpty)
                    ImageSliderWithIndicator(widget.catname.images),

                  // SizedBox(height: 10),

                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categoryProvider.categoryList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      CategoryModel category = categoryProvider.categoryList[index];
                      // SubCategory subCategory = category.subCategories![index];

                      return InkWell(
                        onTap: () {

                          if(widget.fromdhakad=="dhakadsub")
                          {
                            AppConstants.bundleid=widget.catname.id;
                            print("sssssssssss"+AppConstants.bundleid.toString());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>   NewsubcategoryScreen(category,"bundle")
                                ));
                          }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BrandAndCategoryProductScreen(
                                    isBrand: false,
                                    id: category.id.toString(),
                                    name: category.name,
                                  ),
                                ));
                          }



                          // _showSubcategoriesDialog(context, category);
                          // Perform actions on tap
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Add decoration as needed
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: categoryProvider.categorySelectedIndex == index
                                        ? Theme.of(context).highlightColor
                                        : Theme.of(context).hintColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImageWidget(
                                    fit: BoxFit.cover,
                                    image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.categoryImageUrl}/${category.icon}',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: titilliumSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Optional: Add additional widgets or rows/columns as needed
                ],
              ),
            );
          },
        ),

    );
  }

  List<Widget> _buildImageWidgets() {
    return widget.catname.images!.map((image) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            // BoxShadow(
            //   // color: Colors.black26,
            //   blurRadius: 10.0,
            //   offset: Offset(0, 5),
            // ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(AppConstants.baseUrl + "/storage/app/public/product/" + image), // Adjust according to your image source
        ),
      );
    }).toList();
  }



}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;

  const CategoryItem({super.key,
    required this.title,
    required this.icon,
    required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding:
      const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorResources.getPrimary(context) : null),
      child: Center(
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: isSelected
                          ? Theme
                          .of(context)
                          .highlightColor
                          : Theme
                          .of(context)
                          .hintColor),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                      fit: BoxFit.cover,
                      image:
                      '${Provider
                          .of<SplashController>(context, listen: false)
                          .baseUrls!
                          .categoryImageUrl}/$icon'))),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text(title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: isSelected
                          ? Theme
                          .of(context)
                          .highlightColor
                          : Theme
                          .of(context)
                          .hintColor))),
        ]),
      ),
    );
  }

}
