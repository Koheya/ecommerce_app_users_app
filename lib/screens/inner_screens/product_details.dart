import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/heart_button.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});
  static const String routeName = "/ProductDetails";
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Scaffold(
            appBar: AppBar(
              title: const AppNameText(text: "ShopSmart"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * 0.45,
                      width: double.infinity,
                      boxFit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: TitleTextWidget(
                                  label: getCurrentProduct.productName,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 18,
                              ),
                              Flexible(
                                child: TitleTextWidget(
                                  label: "${getCurrentProduct.productPrice}\$",
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                HeartButtonWidget(
                                  productId: getCurrentProduct.productId,
                                  color: Colors.blue.shade300,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight - 10,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                      onPressed: () async {
                                        if (cartProvider.isProductInCart(
                                            productId:
                                                getCurrentProduct.productId)) {
                                          return;
                                        }
                                        // cartProvider.addProductToCart(
                                        //     productId: getCurrentProduct.productId);
                                        try {
                                          await cartProvider.addToCartFirebase(
                                              productId:
                                                  getCurrentProduct.productId,
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
                                      label: cartProvider.isProductInCart(
                                              productId:
                                                  getCurrentProduct.productId)
                                          ? const Text(
                                              "In cart",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : const Text(
                                              "Add to cart",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      icon: cartProvider.isProductInCart(
                                              productId:
                                                  getCurrentProduct.productId)
                                          ? const Icon(Icons.check)
                                          : const Icon(
                                              Icons.add_shopping_cart_rounded,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleTextWidget(label: "About the Item"),
                              SubTitleTextWidget(
                                  label: getCurrentProduct.productCategory)
                            ],
                          ),
                          const SizedBox(height: 25),
                          TitleTextWidget(
                            label: getCurrentProduct.productDescription,

                            // "A smartwatch is a watch that offers extra functionality and connectivity on top of the features offered by standard watches. They do this by including a computer system that carries out the normal functionality we expect, but can also handle some extra bells and whistles. ",
                            fontSize: 14,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
