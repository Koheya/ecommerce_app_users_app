import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/product_widget.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextContoller;
  @override
  void initState() {
    searchTextContoller = TextEditingController();
    super.initState();
  }

  List<ProductModel> productListSearch = [];
  @override
  void dispose() {
    searchTextContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productsList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findProdCtgry(ctgName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppNameText(text: passedCategory ?? "Search"),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Image(
              image: AssetImage(AssetsManager.shoppingCart),
            ),
          ),
        ),
        body: StreamBuilder<List<ProductModel>>(
            stream: productProvider.fetchProductsAsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: TitleTextWidget(label: snapshot.error.toString()),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: TitleTextWidget(label: "No Products Found"),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchTextContoller,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // setState(() {
                            searchTextContoller.clear();
                            FocusScope.of(context).unfocus();
                            // });
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     productListSearch = productProvider.searchProduct(
                      //         searchText: searchTextContoller.text);
                      //   });
                      // },
                      onSubmitted: (value) {
                        setState(() {
                          productListSearch = productProvider.searchProduct(
                              searchText: searchTextContoller.text);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (productListSearch.isEmpty &&
                        searchTextContoller.text.isNotEmpty) ...[
                      const Center(
                        child: TitleTextWidget(
                          label: "No Products Found",
                          fontSize: 30,
                        ),
                      )
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        builder: (context, index) {
                          return ProductWidget(
                            productId: searchTextContoller.text.isNotEmpty
                                ? productListSearch[index].productId
                                : productsList[index].productId,
                          );
                        },
                        itemCount: searchTextContoller.text.isNotEmpty
                            ? productListSearch.length
                            : productsList.length,
                        crossAxisCount: 2,
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
