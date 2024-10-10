import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersModel with ChangeNotifier {
  final String orderId;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final String productImage;
  final String productPrice;
  final String productQuantity;
  final Timestamp? orderDate;
  OrdersModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productQuantity,
    this.orderDate,
  });
}
