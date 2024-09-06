// To parse this JSON data, do
//
//     final streepModel = streepModelFromMap(jsonString);

import 'dart:convert';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

List<StreepModel> streepModelFromMap(String str) => List<StreepModel>.from(json.decode(str).map((x) => StreepModel.fromMap(x)));

String streepModelToMap(List<StreepModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class StreepModel {
  int id;

  String stripType;
  String strip_background;
  String stripName;
  List<Product> products;

  StreepModel({
    required this.id,
    required this.stripType,
    required this.strip_background,
    required this.stripName,
    required this.products,
  });

  factory StreepModel.fromMap(Map<String, dynamic> json) => StreepModel(
    id: json["id"],
    stripType: json["strip_type"],
    strip_background: json["strip_background"],
    stripName: json["strip_name"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "strip_type": stripType,
    "strip_background": strip_background,
    "strip_name": stripName,
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
  };
}
