import 'package:ecommerce/providers/orders_provider.dart';
import 'package:ecommerce/screens/orders/order_widget.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/widgets/empty_bag_widget.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = '/OrderScreen';
  const OrderScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: "Your Orders"),
      ),
      body: FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child:
                  SelectableText("An error has been occured ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
            return EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "Your Orders is empty",
              subTitle: "no Orders has been placed yet",
              buttonText: "Shop Now",
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return OrderWidget(
                  ordersModel: ordersProvider.getOrders[index],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
    );
  }
}
