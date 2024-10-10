import 'package:ecommerce/models/viewed_prod_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedProdItems = {};
  Map<String, ViewedProdModel> get getViewedProdItems {
    return _viewedProdItems;
  }

  // bool isProductInWishlist({required String productId}) {
  //   return _wishlistItems.containsKey(productId);
  // }

  void addProdToHistory({required String productId}) {
    _viewedProdItems.putIfAbsent(
      productId,
      () => ViewedProdModel(
        id: const Uuid().v4(),
        productId: productId,
      ),
    );

    notifyListeners();
  }

  void clearLocalWishlist() {
    _viewedProdItems.clear();
    notifyListeners();
  }
}
