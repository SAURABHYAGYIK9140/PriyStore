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
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/title_row_widget.dart';
import '../../../main.dart';
import '../../Slider.dart';
import '../widgets/category_list_widget.dart';
import 'NewSubcategory_screen.dart';

class NewcategoryScreen extends StatefulWidget {
  const NewcategoryScreen({super.key});

  @override
  State<NewcategoryScreen> createState() => _NewcategoryScreenState();
}

class _NewcategoryScreenState extends State<NewcategoryScreen> {
  late CategoryController categoryController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController = Provider.of<CategoryController>(context, listen: false);
    categoryController.clearCategoryList();
    categoryController.getCategoryList(-1, false);
      String categoryId = categoryController.categoryList.isNotEmpty
          ? categoryController.categoryList[0].id.toString()
          : "0";
      Provider.of<ProductController>(context, listen: false)
          .initBrandOrCategoryProductList("0", "", true, categoryId, context);
    // });
  }
  @override
  void dispose() {
    // Ensure the state is updated after the current frame
    // Future.microtask(() {
    //   // categoryController.clearCategoryList();
    //   categoryController.getCategoryList(-1, true);
    //
    // });
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && ModalRoute.of(context)?.isCurrent == true) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.getCategoryList(-1, true);
      });
    }
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   categoryController = Provider.of<CategoryController>(context, listen: false);
  //   if (ModalRoute.of(context)?.isCurrent == true) {
  //     // categoryController.getCategoryList(-1, true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // categoryController.clearCategoryList();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context)),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.categoryList.isNotEmpty
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                CustomeSlider(false),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categoryProvider.categoryList.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    CategoryModel category =
                    categoryProvider.categoryList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  NewsubcategoryScreen(category, "")),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: categoryProvider
                                      .categorySelectedIndex ==
                                      index
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CustomImageWidget(
                                  fit: BoxFit.cover,
                                  image:
                                  '${Provider.of<SplashController>(context, listen: false).baseUrls!.categoryImageUrl}/${category.icon}',
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
              ],
            ),
          )
              : Stack(
                children: [
                  Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
                ],
              );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;

  const CategoryItem(
      {super.key,
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
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).hintColor),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                      fit: BoxFit.cover,
                      image:
                      '${Provider.of<SplashController>(context, listen: false).baseUrls!.categoryImageUrl}/$icon'))),
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
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).hintColor))),
        ]),
      ),
    );
  }
}
