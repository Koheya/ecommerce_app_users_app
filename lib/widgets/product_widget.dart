import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/providers/viewed_prod_provider.dart';
import 'package:ecommerce/screens/inner_screens/product_details.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/heart_button.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? Container()
        : GestureDetector(
            onTap: () async {
              viewedProvider.addProdToHistory(
                  productId: getCurrentProduct.productId);
              await Navigator.of(context).pushNamed(ProductDetails.routeName,
                  arguments: getCurrentProduct.productId);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * 0.22,
                      width: double.infinity,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                          label: getCurrentProduct.productName,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                      ),
                      Flexible(
                        child: HeartButtonWidget(
                          productId: getCurrentProduct.productId,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                          label: "${getCurrentProduct.productPrice}\$",
                          fontSize: 16,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.surface,
                          child: InkWell(
                            splashColor: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              if (cartProvider.isProductInCart(
                                  productId: getCurrentProduct.productId)) {
                                return;
                              }
                              // cartProvider.addProductToCart(
                              //     productId: getCurrentProduct.productId);
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: getCurrentProduct.productId,
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
                                      productId: getCurrentProduct.productId)
                                  ? const Icon(Icons.check)
                                  : const Icon(
                                      Icons.add_shopping_cart_rounded,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
  }
}
