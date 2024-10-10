import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/services/assets_manager.dart';

class AppConstants {
  static const String productImageUrl =
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D";

  static List<String> bannerImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "Phones",
      name: "Phones",
      image: AssetsManager.mobiles,
    ),
    CategoryModel(
      id: "Accessories",
      name: "Accessories",
      image: AssetsManager.fashion,
    ),
    CategoryModel(
        id: AssetsManager.electronics,
        name: "Electronics",
        image: AssetsManager.electronics),
    CategoryModel(
        id: AssetsManager.shoes, name: "Shoes", image: AssetsManager.shoes),
    CategoryModel(
        id: AssetsManager.cosmetics,
        name: "Cosmetics",
        image: AssetsManager.cosmetics),
    CategoryModel(
        id: AssetsManager.book, name: "books", image: AssetsManager.book),
    CategoryModel(
        id: AssetsManager.watch, name: "watches", image: AssetsManager.watch),
    CategoryModel(
      id: "Laptops",
      name: "Laptops",
      image: AssetsManager.pc,
    ),
  ];
}
