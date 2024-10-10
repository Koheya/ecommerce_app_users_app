import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/screens/auth/login_screen.dart';
import 'package:ecommerce/screens/inner_screens/view_recently.dart';
import 'package:ecommerce/screens/inner_screens/wishlist_screen.dart';
import 'package:ecommerce/screens/loading_manager.dart';
import 'package:ecommerce/screens/orders/order_screen.dart';
import 'package:ecommerce/services/assets_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/custom_list_tile.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  bool isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppMethods.showErrorOrWarningDialog(
        context: context,
        title: "An Error ocurred $error",
        msg: "",
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
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
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 60),
                  child: Align(
                    alignment: Alignment.center,
                    child: TitleTextWidget(
                      label: "Please Login for ultimate",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              userModel == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(userModel!.userImage),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextWidget(label: userModel!.userName),
                              SubTitleTextWidget(label: userModel!.userEmail),
                            ],
                          )
                        ],
                      ),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleTextWidget(label: "General"),
                    user == null
                        ? const SizedBox.shrink()
                        : CustomListTile(
                            text: "All Orders",
                            imagePath: AssetsManager.orderSvg,
                            function: () async {
                              await Navigator.pushNamed(
                                  context, OrderScreen.routeName);
                            },
                          ),
                    const SizedBox(height: 4),
                    user == null
                        ? const SizedBox.shrink()
                        : CustomListTile(
                            text: "WishList",
                            imagePath: AssetsManager.wishlistSvg,
                            function: () {
                              Navigator.pushNamed(
                                  context, WishListScreen.routeName);
                            },
                          ),
                    const SizedBox(height: 4),
                    CustomListTile(
                      text: "View Recently",
                      imagePath: AssetsManager.recent,
                      function: () {
                        Navigator.pushNamed(
                            context, ViewRecentlyScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 4),
                    CustomListTile(
                      text: "Addresses",
                      imagePath: AssetsManager.address,
                      function: () {},
                    ),
                    const SizedBox(height: 4),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(height: 4),
                    const TitleTextWidget(label: "Settings"),
                    const SizedBox(height: 4),
                    SwitchListTile(
                      secondary: Image(
                        image: AssetImage(AssetsManager.theme),
                        height: 35,
                      ),
                      title: Text(
                        themeProvider.getIsDarkTheme
                            ? "Dark Mode"
                            : "Light Mode",
                      ),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(themeValue: value);
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(height: 4),
                    const TitleTextWidget(label: "Others"),
                    CustomListTile(
                        imagePath: AssetsManager.privacy,
                        text: "Privacy and Policy",
                        function: () {})
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    if (user == null) {
                      await Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    } else {
                      MyAppMethods.showErrorOrWarningDialog(
                        context: context,
                        title: "Logout",
                        msg: "Are you sure you want to logout?",
                        fct: () async {
                          await auth.signOut();
                          Fluttertoast.showToast(
                            msg: "Logout Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.white,
                          );
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                      );
                    }
                  },
                  label: Text(
                    user == null ? "Login" : "Logout",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    user == null ? Icons.login : Icons.logout,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
