import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/viewed_prod_provider.dart';
import 'package:ecommerce/screens/inner_screens/product_details.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/heart_button.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestArrivalProductWidget extends StatefulWidget {
  const LatestArrivalProductWidget({super.key});

  @override
  State<LatestArrivalProductWidget> createState() =>
      _LatestArrivalProductWidgetState();
}

class _LatestArrivalProductWidgetState
    extends State<LatestArrivalProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productProviderModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProdToHistory(
              productId: productProviderModel.productId);
          await Navigator.of(context).pushNamed(ProductDetails.routeName,
              arguments: productProviderModel.productId);
        },
        child: SizedBox(
          width: size.width * 0.5,
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FancyShimmerImage(
                      imageUrl: productProviderModel.productImage,
                      width: size.width * 0.3,
                      height: size.width * 0.4,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextWidget(
                        label: productProviderModel.productName,
                        fontSize: 16,
                        maxLines: 2,
                      ),
                      // const Spacer(),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).colorScheme.surface,
                              child: InkWell(
                                splashColor: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  if (cartProvider.isProductInCart(
                                      productId:
                                          productProviderModel.productId)) {
                                    return;
                                  }
                                  // cartProvider.addProductToCart(
                                  //     productId: getCurrentProduct.productId);
                                  try {
                                    await cartProvider.addToCartFirebase(
                                        productId:
                                            productProviderModel.productId,
                                        qty: 1,
                                        context: context);
                                  } catch (error) {
                                    MyAppMethods.showErrorOrWarningDialog(
                                        context: context,
                                        title: "Error",
                                        msg: error.toString(),
                                        fct: () {});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: cartProvider.isProductInCart(
                                          productId:
                                              productProviderModel.productId)
                                      ? const Icon(Icons.check)
                                      : const Icon(
                                          Icons.add_shopping_cart_rounded,
                                        ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 8,
                            // ),
                            HeartButtonWidget(
                              productId: productProviderModel.productId,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      FittedBox(
                        child: TitleTextWidget(
                          label: "${productProviderModel.productPrice}\$",
                          fontSize: 14,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
