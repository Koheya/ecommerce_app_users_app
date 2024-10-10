import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

// Firebase
  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Future<void> addToCartFirebase(
      {required String productId,
      required int qty,
      required BuildContext context}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "Error!",
          msg: "User not Found , please login first",
          fct: () {});
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        "userCart": FieldValue.arrayUnion(
          [
            {
              "cartId": cartId,
              "productId": productId,
              "quantity": qty,
            }
          ],
        )
      });
      Fluttertoast.showToast(msg: "Item added to cart");
      await fetchCart();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log("====================================================the function has been called and the user is null log in cart=========================================");
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        _cartItems.putIfAbsent(
          userDoc.get("userCart")[index]["productId"],
          () => CartModel(
            cartId: userDoc.get("userCart")[index]["cartId"],
            productId: userDoc.get("userCart")[index]["productId"],
            quantity: userDoc.get("userCart")[index]["quantity"],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearCartFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      usersDB.doc(user!.uid).update({"userCart": []});
      _cartItems.clear();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartItemFromFirebase({
    required String productId,
    required String cartId,
    required int qty,
  }) async {
    User? user = _auth.currentUser;
    try {
      usersDB.doc(user!.uid).update({
        "userCart": FieldValue.arrayRemove(
          [
            {
              "cartId": cartId,
              "productId": productId,
              "quantity": qty,
            }
          ],
        )
      });
      _cartItems.remove(productId);
      await fetchCart();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

// local
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );

    notifyListeners();
  }

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.productId,
        productId: productId,
        quantity: quantity,
      ),
    );

    notifyListeners();
  }

  double getTotalPrice({required ProductProvider productProvider}) {
    double total = 0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrentProduct =
          productProvider.findProdId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  int getQuantity() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
