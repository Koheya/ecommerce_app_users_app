import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants/my_validators.dart';
import 'package:ecommerce/screens/loading_manager.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:ecommerce/widgets/app_name.dart';
import 'package:ecommerce/widgets/custom_text_form_field.dart';
import 'package:ecommerce/widgets/pick_image_widget.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:ecommerce/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUpScreen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;
  late FocusNode _userNameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _repeatPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;
  bool isRepeatPasswordShow = true;
  XFile? pickedImage;
  String? userImageUrl;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _userNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (pickedImage == null) {
      MyAppMethods.showErrorOrWarningDialog(
        context: context,
        title: "Error!",
        msg: "Please pick an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child("${_emailController.text.trim()}.jpg");
        await ref.putFile(File(pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final User? user = auth.currentUser;

        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "userId": uid,
          "userName": _userNameController.text,
          "userEmail": _emailController.text.toLowerCase(),
          "userImage": userImageUrl,
          "createdAt": Timestamp.now(),
          "userCart": [],
          "userWish": [],
        });
        await user.sendEmailVerification();
        Fluttertoast.showToast(
          msg: "Check your email for verification",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseAuthException catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "An Error ocurred ${error.message}",
          msg: "",
          fct: () {
            Navigator.pop(context);
          },
        );
      } catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "An Error ocurred $error",
          msg: "",
          fct: () {
            Navigator.pop(context);
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFun: () async {
        pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFun: () async {
        pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFun: () {
        pickedImage == null;
        userImageUrl == null;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
            ),
          ),
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
                      const SizedBox(height: 20),
                      const AppNameText(text: "ShopSmart", fontSize: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const TitleTextWidget(
                            label: "Welcome",
                            fontSize: 20,
                          ),
                          const SubTitleTextWidget(
                            label:
                                "Sign up now to recieve special offers and updates from your apps",
                            fontSize: 14,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              height: size.width * 0.3,
                              width: size.width * 0.3,
                              child: PickImageWidget(
                                pickedImage: pickedImage,
                                function: () async {
                                  await localImagePicker();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            Controller: _userNameController,
                            focusNode: _userNameFocusNode,
                            hintText: "Username",
                            icon: Icons.person_outlined,
                            validator: (value) {
                              return MyValidators.displayNamevalidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            Controller: _repeatPasswordController,
                            focusNode: _repeatPasswordFocusNode,
                            hintText: "Repeat Password",
                            icon: Icons.key_outlined,
                            obscureText: isRepeatPasswordShow,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isRepeatPasswordShow = !isRepeatPasswordShow;
                                });
                              },
                              icon: isRepeatPasswordShow
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
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton(
                              onPressed: () {
                                register();
                              },
                              child: const TitleTextWidget(label: "Sign Up"),
                            ),
                          ),
                          const SizedBox(height: 40),
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
