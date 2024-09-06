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

import '../../../common/basewidget/no_internet_screen_widget.dart';
import '../../../common/basewidget/title_row_widget.dart';
import '../../../main.dart';
import '../../../utill/images.dart';
import '../../Slider.dart';
import 'HomeSubCat_screen.dart';
import 'NewSubcategory_screen.dart';

class HomecategoryScreen extends StatefulWidget {
  const HomecategoryScreen({super.key, required this.isHomePage});

  final bool isHomePage;

  @override
  State<HomecategoryScreen> createState() => _NewcategoryScreenState();
}

class _NewcategoryScreenState extends State<HomecategoryScreen> {
  late CategoryController categoryController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    categoryController = Provider.of<CategoryController>(context, listen: false);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && ModalRoute.of(context)?.isCurrent == true) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.getCategoryList(0, true);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // categoryController.getCategoryList(-1, true);
  }

  @override
  Widget build(BuildContext context) {
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
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categoryProvider.categoryList.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    CategoryModel category = categoryProvider.categoryList[index];
                    return InkWell(
                      onTap: () {
                        print("@@@@@@@@@@@@@@");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomesubcatScreen(category)),
                        );
                      },
                      child: Card(
                        elevation: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
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
                      ),
                    );
                  },
                ),
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

  List<Widget> _getSubSubCategories(BuildContext context, SubCategory subCategory) {
    List<Widget> subSubCategories = [];
    subSubCategories.add(Container(
      color: ColorResources.getIconBg(context),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
      child: ListTile(
        title: Row(children: [
          Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context), shape: BoxShape.circle)),
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
                  builder: (_) => BrandAndCategoryProductScreen(
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
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: ListTile(
          title: Row(children: [
            Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                    color: ColorResources.getPrimary(context), shape: BoxShape.circle)),
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
                    builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: subCategory.subSubCategories![index].id.toString(),
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
                            builder: (_) => BrandAndCategoryProductScreen(
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
      {super.key, required this.title, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorResources.getPrimary(context) : null),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
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
