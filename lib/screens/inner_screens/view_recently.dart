import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce/providers/viewed_prod_provider.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/empty_bag_widget.dart';
import 'package:ecommerce/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewRecentlyScreen extends StatelessWidget {
  const ViewRecentlyScreen({super.key});
  static const String routeName = "/ViewRecentlyScreen";
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    return viewedProvider.getViewedProdItems.isEmpty
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmptyBagWidget(
                imagePath: AssetsManager.recent,
                title: "Your seen Products list is empty",
                subTitle:
                    "looks like you didn't add anything to your cart yet \ngo ahead and start shopping now!",
                buttonText: "Shop Now",
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: AppNameText(
                text:
                    "Viewed Recently (${viewedProvider.getViewedProdItems.length})",
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
                      title: "Clear Viewed Products",
                      msg: "Are you sure you want to clear your Wishlist?",
                      
                      fct: () {
                        viewedProvider.clearLocalWishlist();
                        Navigator.pop(context);
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductWidget(
                      productId: viewedProvider.getViewedProdItems.values
                          .toList()[index]
                          .productId,
                    ),
                  );
                },
                itemCount: viewedProvider.getViewedProdItems.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
