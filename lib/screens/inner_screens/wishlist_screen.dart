import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce/providers/wishlist_provider.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/empty_bag_widget.dart';
import 'package:ecommerce/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  static const String routeName = "/wishListScreen";
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "Your wishlist is empty",
              subTitle:
                  "looks like you didn't add anything to your cart yet \ngo ahead and start shopping now!",
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: AppNameText(
                text: "wishlist (${wishlistProvider.getWishlistItems.length})",
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethods.showErrorOrWarningDialog(
                      context: context,
                      title: "Clear Wishlist",
                      msg: "Are you sure you want to clear your Wishlist?",
                      fct: () async {
                        await wishlistProvider.clearWishlistFromFirebase();
                        wishlistProvider.clearLocalWishlist();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                  color: Colors.red,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DynamicHeightGridView(
                builder: (context, index) {
                  return ProductWidget(
                    productId: wishlistProvider.getWishlistItems.values
                        .toList()[index]
                        .productId,
                  );
                },
                itemCount: wishlistProvider.getWishlistItems.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
