import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishlistItems = {};
  Map<String, WishListModel> get getWishlistItems {
    return _wishlistItems;
  }

// Firebase
  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Future<void> addToWishlistFirebase(
      {required String productId, required BuildContext context}) async {
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
    final wishlistId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        "userWish": FieldValue.arrayUnion(
          [
            {
              "wishlistId": wishlistId,
              "productId": productId,
            }
          ],
        )
      });
      Fluttertoast.showToast(msg: "Item added to wishlist");
      await fetchWishlist();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log("========================================the function has been called and the user is null log in wishlist =====================================================");
      _wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final leng = userDoc.get("userWish").length;
      for (int index = 0; index < leng; index++) {
        _wishlistItems.putIfAbsent(
            userDoc.get("userWish")[index]["productId"],
            () => WishListModel(
                  wishlistId: userDoc.get("userWish")[index]["wishlistId"],
                  productId: userDoc.get("userWish")[index]["productId"],
                ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearWishlistFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      usersDB.doc(user!.uid).update({"userWish": []});
      _wishlistItems.clear();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirebase({
    required String productId,
    required String wishlistId,
  }) async {
    User? user = _auth.currentUser;
    try {
      usersDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove(
          [
            {
              "wishlistId": wishlistId,
              "productId": productId,
            }
          ],
        )
      });
      _wishlistItems.remove(productId);
      await fetchWishlist();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

// local
  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () => WishListModel(
          wishlistId: const Uuid().v4(),
          productId: productId,
        ),
      );
    }

    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
