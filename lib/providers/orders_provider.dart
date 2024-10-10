import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModel> orders = [];
  List<OrdersModel> get getOrders => orders;
  // final usersDB = FirebaseFirestore.instance.collection("userrs");
  // final _auth = FirebaseAuth.instance;
  // User? user = _auth.currentUser;
  Future<List<OrdersModel>> fetchOrders() async {
    try {
      await FirebaseFirestore.instance
          .collection("orders")
          .get()
          .then((ordersSnapshot) {
        orders.clear();
        for (var element in ordersSnapshot.docs) {
          orders.insert(
            0,
            OrdersModel(
              orderId: element.get("orderId"),
              userId: element.get("userId"),
              userName: element.get("userName"),
              productId: element.get("productId"),
              productName: element.get("productName"),
              productImage: element.get("productImage"),
              productPrice: element.get("productPrice").toString(),
              productQuantity: element.get("productQuantity").toString(),
              orderDate: element.get("orderDate"),
            ),
          );
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> removeOrderFromFirebase({
  //   required String productId,
  //   required String orderId,
  // }) async {
  //   try {
  //     usersDB.doc(user!.uid).update({
  //       "orders": FieldValue.arrayRemove(
  //         [
  //           {
  //             "orderId": orderId,
  //             "productId": productId,
  //           }
  //         ],
  //       )
  //     });
  //     orders.remove();
  //     await fetchOrders();
  //   } catch (error) {
  //     rethrow;
  //   }
  //   notifyListeners();
  // }
}
