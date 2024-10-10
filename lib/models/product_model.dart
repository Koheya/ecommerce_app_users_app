import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productName,
      productDescription,
      productPrice,
      productQuantity,
      productCategory,
      productImage;
  Timestamp? createdAt;
  ProductModel({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.productCategory,
    required this.productImage,
    this.createdAt,
  });
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data["productId"] ?? "",
      productImage: data["productImage"] ?? "",
      productName: data["productName"] ?? "",
      productDescription: data["productDescription"] ?? "",
      productPrice: data["productPrice"] ?? "",
      productCategory: data["productCategory"] ?? "",
      productQuantity: data["productQuantity"] ?? "",
      createdAt: data["createdAt"],
    );
  }
}
