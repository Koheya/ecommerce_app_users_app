import 'package:flutter/material.dart';

class WishListModel with ChangeNotifier {
  final String wishlistId, productId;
  WishListModel({
    required this.wishlistId,
    required this.productId,
  });
}
