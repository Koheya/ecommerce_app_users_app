import 'package:ecommerce/constants/my_validators.dart';
import 'package:ecommerce/root_screen.dart';
import 'package:ecommerce/screens/auth/forget_passwoed.dart';
import 'package:ecommerce/screens/auth/google_btn.dart';
import 'package:ecommerce/screens/auth/signup_screen.dart';
import 'package:ecommerce/screens/loading_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/custom_text_form_field.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            Fluttertoast.showToast(
              msg: "Login Successfully",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
            );
            Navigator.pushReplacementNamed(context, RootScreen.routeName);
          } else {
            await MyAppMethods.showErrorOrWarningDialog(
              context: context,
              title: "Error!",
              msg: "Email is not verified. Please verify your email.",
              fct: () {},
            );
            await user.sendEmailVerification();
          }
        }
      } on FirebaseAuthException catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "An Error ocurred ${error.message}",
          msg: "",
          fct: () {},
        );
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: LoadingManager(
            isLoading: isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const AppNameText(text: "ShopSmart", fontSize: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const TitleTextWidget(
                            label: "Welcom Back",
                            fontSize: 20,
                          ),
                          const SubTitleTextWidget(
                            label:
                                "Let/'s get you logged in so you can start Exploring",
                            fontSize: 14,
                          ),
                          const SizedBox(height: 40),
                          CustomTextFormField(
                            Controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: "Email",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          const SizedBox(height: 30),
                          CustomTextFormField(
                            Controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            hintText: "Password",
                            icon: Icons.key_outlined,
                            obscureText: isPasswordShow,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow = !isPasswordShow;
                                });
                              },
                              icon: isPasswordShow
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                            validator: (value) {
                              return MyValidators.passwordValidator(value);
                            },
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ForgetPasswordScreen.routeName,
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: const TitleTextWidget(label: "Sign In"),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Align(
                            alignment: Alignment.center,
                            child: TitleTextWidget(
                              label: "Or Connect Using",
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: kBottomNavigationBarHeight + 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: kBottomNavigationBarHeight,
                                      child: FittedBox(
                                        child: GoogleButton(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: SizedBox(
                                      height: kBottomNavigationBarHeight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                              context, RootScreen.routeName);
                                        },
                                        child: const FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: TitleTextWidget(
                                            label: "Guest?",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubTitleTextWidget(
                                label: "Don't have an account?",
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: const TitleTextWidget(
                                  label: "Sign Up",
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
