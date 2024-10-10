import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/screens/loading_manager.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/screens/cart/bottom_checkout.dart';
import 'package:ecommerce/screens/cart/cart_widget.dart';
import 'package:ecommerce/widgets/empty_bag_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final bool isEmpty = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your cart is empty",
              subTitle:
                  "looks like you didn't add anything to your cart yet \ngo ahead and start shopping now!",
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: AppNameText(
                text: "Cart (${cartProvider.getCartItems.length})",
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image(
                  image: AssetImage(AssetsManager.shoppingCart),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethods.showErrorOrWarningDialog(
                      context: context,
                      title: "Clear Cart",
                      msg: "Are you sure you want to clear your cart?",
                      fct: () async {
                        await cartProvider.clearCartFromFirebase();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                  color: Colors.red,
                ),
              ],
            ),
            bottomSheet: CartBottomCheckout(
              function: () async {
                await placeOrder(
                    cartProvider: cartProvider,
                    userProvider: userProvider,
                    productProvider: productProvider);
              },
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: cartProvider.getCartItems.values
                              .toList()
                              .reversed
                              .toList()[index],
                          child: const CartWidget(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight + 10),
                ],
              ),
            ),
          );
  }

  Future<void> placeOrder(
      {required CartProvider cartProvider,
      required UserProvider userProvider,
      required ProductProvider productProvider}) async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrentProducts = productProvider.findProdId(value.productId);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
          "orderId": orderId,
          "userId": uid,
          "userName": userProvider.getUserModel!.userName,
          "productId": value.productId,
          "productPrice":
              double.parse(getCurrentProducts!.productPrice) * value.quantity,
          "productName": getCurrentProducts.productName,
          "productImage": getCurrentProducts.productImage,
          "totalPrice":
              cartProvider.getTotalPrice(productProvider: productProvider),
          "productQuantity": value.quantity,
          "orderDate": Timestamp.now(),
        });
      });
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
    } catch (e) {
      MyAppMethods.showErrorOrWarningDialog(
        context: context,
        title: "Error",
        msg: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
