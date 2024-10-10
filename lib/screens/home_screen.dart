import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce/constants/app_constants.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/category_rounded_widget.dart';
import 'package:ecommerce/widgets/latest_arrival.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AppNameText(
          text: "ShopSmart",
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image(
            image: AssetImage(AssetsManager.shoppingCart),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: Swiper(
                  itemCount: AppConstants.bannerImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset(
                        AppConstants.bannerImages[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  autoplay: true,
                  pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.blue,
                      activeColor: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: const TitleTextWidget(label: "Latest Arrival"),
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.18,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.getProducts.length < 10
                        ? productProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: productProvider.getProducts[index],
                        child: const LatestArrivalProductWidget(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TitleTextWidget(label: "Categories"),
              const SizedBox(height: 16),
              GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(AppConstants.categoriesList.length,
                      (index) {
                    return CategoryRounderWidget(
                      image: AppConstants.categoriesList[index].image,
                      name: AppConstants.categoriesList[index].name,
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
