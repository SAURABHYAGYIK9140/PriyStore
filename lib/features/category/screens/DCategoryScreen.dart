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
import '../../product/screens/DProductList.dart';
import 'NewSubcategory_screen.dart';

class Dcategoryscreen extends StatefulWidget {
  const Dcategoryscreen({super.key});

  @override
  State<Dcategoryscreen> createState() => _NewcategoryScreenState();
}

class _NewcategoryScreenState extends State<Dcategoryscreen> {
  late CategoryController categoryController;

  @override
  void initState() {
    categoryController = Provider.of<CategoryController>(context, listen: false);
    categoryController.getCategoryList(-2, true);

    Provider.of<ProductController>(context, listen: false)
        .initBrandOrCategoryProductList(
        "0",
        "dhakad",
        false,
        "0",
        context);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Provider.of<CategoryController>(Get.context!, listen: false).getCategoryList(-1,true);
    // Provider.of<CategoryController>(Get.context!, listen: false)
    //     .getCategoryList(-1, true);
    Future.microtask(() {
      categoryController.clearCategoryList();
      categoryController.getCategoryList(-1, true);

    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    categoryController = Provider.of<CategoryController>(context, listen: false);

    if (ModalRoute.of(context)?.isCurrent == true) {
      // Provider.of<CategoryController>(Get.context!, listen: false)
      //     .getCategoryList(-2, true);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    // final categoryController = Provider.of<CategoryController>(context, listen: false);
    // categoryController.clearCategoryList();
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('CATEGORY', context)),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {

          return categoryProvider.categoryList.isNotEmpty
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomeSlider(false),
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
                    CategoryModel category =
                    categoryProvider.categoryList[index];
                    return InkWell(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  NewsubcategoryScreen(category,"dhakadsub")),
                        );
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
                // Optional: Add additional widgets or rows/columns as needed
              ],
            ),
          )
              : Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  List<Widget> _getSubSubCategories(
      BuildContext context, SubCategory subCategory) {
    List<Widget> subSubCategories = [];
    subSubCategories.add(Container(
      color: ColorResources.getIconBg(context),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall),
      child: ListTile(
        title: Row(children: [
          Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context),
                  shape: BoxShape.circle)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Flexible(
              child: Text(getTranslated('all_products', context)!,
                  style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis))
        ]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Dproductlist(
                    isBrand: false,
                    id: subCategory.id.toString(),
                    name: subCategory.name,
                  )));
        },
      ),
    ));
    for (int index = 0; index < subCategory.subSubCategories!.length; index++) {
      subSubCategories.add(Container(
        color: ColorResources.getIconBg(context),
        margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall),
        child: ListTile(
          title: Row(children: [
            Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                    color: ColorResources.getPrimary(context),
                    shape: BoxShape.circle)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Flexible(
                child: Text(subCategory.subSubCategories![index].name!,
                    style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeDefault),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)),
          ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Dproductlist(
                      isBrand: false,
                      id: subCategory.subSubCategories![index].id
                          .toString(),
                      name: subCategory.subSubCategories![index].name,
                    )));
          },
        ),
      ));
    }
    return subSubCategories;
  }

  void _showSubcategoriesDialog(BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(category.name!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: category.subCategories!.length,
                itemBuilder: (context, index) {
                  SubCategory subCategory = category.subCategories![index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: ListTile(
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 30,
                      ),
                      title: Text(subCategory.name!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Dproductlist(
                              isBrand: false,
                              id: subCategory.id.toString(),
                              name: subCategory.name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('close'),
                ),
              ),
            ],
          ),
        );
      },
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
