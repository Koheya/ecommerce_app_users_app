import 'package:ecommerce/constants/theme_data.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/orders_provider.dart';
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/providers/viewed_prod_provider.dart';
import 'package:ecommerce/providers/wishlist_provider.dart';
import 'package:ecommerce/root_screen.dart';
import 'package:ecommerce/screens/auth/forget_passwoed.dart';
import 'package:ecommerce/screens/auth/login_screen.dart';
import 'package:ecommerce/screens/auth/signup_screen.dart';
import 'package:ecommerce/screens/inner_screens/product_details.dart';
import 'package:ecommerce/screens/inner_screens/view_recently.dart';
import 'package:ecommerce/screens/inner_screens/wishlist_screen.dart';
import 'package:ecommerce/screens/orders/order_screen.dart';
import 'package:ecommerce/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      "An error has been occured ${snapshot.error}"),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ThemeProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => WishlistProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ViewedProdProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                builder: (
                  context,
                  themeProvider,
                  child,
                ) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Shop Smart AR',
                    theme: Styles.themeData(
                        isDarkMode: themeProvider.getIsDarkTheme,
                        context: context),
                    home: const RootScreen(),
                    // home: const RegisterScreen(),
                    routes: {
                      ProductDetails.routeName: (context) =>
                          const ProductDetails(),
                      WishListScreen.routeName: (context) =>
                          const WishListScreen(),
                      ViewRecentlyScreen.routeName: (context) =>
                          const ViewRecentlyScreen(),
                      SignUpScreen.routeName: (context) => const SignUpScreen(),
                      LoginScreen.routeName: (context) => const LoginScreen(),
                      OrderScreen.routeName: (context) => const OrderScreen(),
                      ForgetPasswordScreen.routeName: (context) =>
                          const ForgetPasswordScreen(),
                      SearchScreen.routeName: (context) => const SearchScreen(),
                      RootScreen.routeName: (context) => const RootScreen(),
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
