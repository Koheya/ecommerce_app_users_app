import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/root_screen.dart';
import 'package:ecommerce/services/my_app_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> loginWithGoogle({required BuildContext context}) async {
    final _auth = FirebaseAuth.instance;
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final authResults = await _auth.signInWithCredential(cred);
      if (authResults.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResults.user!.uid)
            .set({
          'userId': authResults.user!.uid,
          'userName': authResults.user!.displayName,
          'userImage': authResults.user!.photoURL,
          'userEmail': authResults.user!.email,
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
        log("=========================user added to firebase by google sign in================================");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        });
      } else {
        log("=========================user already exist================================");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        });
      }
    } on FirebaseException catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "Error",
          msg: "An error has been occured ${error.message}",
          fct: () {},
        );
      });
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          title: "Error",
          msg: "An error has been occured $error",
          fct: () {},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () async {
        await loginWithGoogle(context: context);
      },
    );
  }
}

// Future<void> _goolgeSignIn({required BuildContext context}) async {
//   log("=========================the function has been called and the user is null log in google sign in=========================================");
//   final googleAccount = await GoogleSignIn().signIn();
//   if (googleAccount != null) {
//     final googleAuth = await googleAccount.authentication;
//     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//       try {
//         final authResults = await FirebaseAuth.instance
//             .signInWithCredential(GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         ));
//         if (authResults.additionalUserInfo!.isNewUser) {
//           await FirebaseFirestore.instance
//               .collection("users")
//               .doc(authResults.user!.uid)
//               .set({
//             'userId': authResults.user!.uid,
//             'userName': authResults.user!.displayName,
//             'userImage': authResults.user!.photoURL,
//             'userEmail': authResults.user!.email,
//             'createdAt': Timestamp.now(),
//             'userWish': [],
//             'userCart': [],
//           });
//           log("=========================user added to firebase by google sign in================================");
//         }
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           Navigator.pushReplacementNamed(context, RootScreen.routeName);
//         });
//       } on FirebaseException catch (error) {
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           await MyAppMethods.showErrorOrWarningDialog(
//             context: context,
//             title: "Error",
//             msg: "An error has been occured ${error.message}",
//             fct: () {},
//           );
//         });
//       } catch (error) {
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           await MyAppMethods.showErrorOrWarningDialog(
//             context: context,
//             title: "Error",
//             msg: "An error has been occured $error",
//             fct: () {},
//           );
//         });
//       }
//     }
//   }
// }

