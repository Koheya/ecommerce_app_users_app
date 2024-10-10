import 'package:ecommerce/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.onTap,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final void Function()? onTap;
  final Color? color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Material(
      shape: const CircleBorder(),
      color: widget.color,
      child: IconButton(
        onPressed: () async {
          // wishlistProvider.addOrRemoveFromWishlist(productId: widget.productId);
          setState(() {
            isLoading = true;
          });
          try {
            if (wishlistProvider.getWishlistItems
                .containsKey(widget.productId)) {
              wishlistProvider.removeWishlistItemFromFirebase(
                  productId: widget.productId,
                  wishlistId: wishlistProvider
                      .getWishlistItems[widget.productId]!.wishlistId);
            } else {
              wishlistProvider.addToWishlistFirebase(
                  productId: widget.productId, context: context);
            }
            await wishlistProvider.fetchWishlist();
          } catch (e) {
            rethrow;
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Icon(
                  wishlistProvider.isProductInWishlist(
                          productId: widget.productId)
                      ? IconlyBold.heart
                      : IconlyLight.heart,
                  size: widget.size,
                  color: wishlistProvider.isProductInWishlist(
                          productId: widget.productId)
                      ? Colors.red
                      : Colors.grey,
                ),
        ),
      ),
    );
  }
}
