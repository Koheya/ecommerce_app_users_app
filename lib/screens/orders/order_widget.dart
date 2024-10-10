import 'package:ecommerce/models/orders_model.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key, required this.ordersModel});
  final OrdersModel ordersModel;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: widget.ordersModel.productImage,
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  boxFit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: TitleTextWidget(
                            label: widget.ordersModel.productName,
                            fontSize: 16,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.clear),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const TitleTextWidget(
                          label: "Price: ",
                          fontSize: 16,
                          maxLines: 2,
                        ),
                        SubTitleTextWidget(
                          label: "${widget.ordersModel.productPrice} \$",
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const TitleTextWidget(
                          label: "Qty: ",
                          fontSize: 16,
                          maxLines: 2,
                        ),
                        SubTitleTextWidget(
                          label: widget.ordersModel.productQuantity,
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
