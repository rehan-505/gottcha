// import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:math';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/auth/sign_up.dart';

import '../../utils/constants.dart';
import '../../utils/text_constants.dart';
import '../home/home.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'login.dart';

class AuthController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<bool> loginPassHide = true.obs;
  Rx<bool> signupPassHide = true.obs;
  bool applesignin = false;

  initState() async {
    // applesignin=await AppleSignIn.isAvailable();
  }

  Future<void> emailLogin(String email, String pass) async {
    loading.value = true;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      Get.offAll(() =>HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }

    loading.value = false;
  }

  Future<bool> signInAnonymously() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: getRandomString(15) + '@gmail.com',
        password: getRandomString(10));

    return true;
  }

  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future<void> emailSignUp(
      String email, String pass, BuildContext context) async {
    loading.value = true;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      customDialog(context,
          img: 'assets/images/verified.svg',
          heading: regSuccess,
          body: Text(
            registrationSuccessDetail,
            style: darkGreyNormalStyle16,
            textAlign: TextAlign.center,
          ));

      await Future.delayed(const Duration(seconds: 3));

      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }

    loading.value = false;
  }

  Future<void> logoutAll() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }

    await GoogleSignInController.signOut();
    await FacebookSignInController.logout();

    Get.offAll(() => LoginScreen());

    print("After logout, user id : ${FirebaseAuth.instance.currentUser?.uid}");
  }

  Future<void> resetPass(String email, BuildContext context) async {
    loading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      loading.value = false;
      // await FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword)
      print("email sent to $email");
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                content: Builder(
                  builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          resHeightBox(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: Color.fromRGBO(63, 56, 49, 1.0),
                                ),
                              )
                            ],
                          ),
                          SvgPicture.asset("assets/images/email.svg"),
                          resHeightBox(38),
                          Text(
                            checkEmail,
                            style: blackHeadingStyle32,
                            textAlign: TextAlign.center,
                          ),
                          resHeightBox(16),
                          Text(
                            emailSent,
                            style: darkGreyNormalStyle16,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
                backgroundColor: Colors.white,
              ));
    } catch (e) {
      Get.snackbar("Request Failed", e.toString(),
          backgroundColor: Colors.white);
    }
    loading.value = false;
  }
}

class GoogleSignInController extends GetxController {
  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
          Get.offAll(() => HomeScreen());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            Get.snackbar("Request Failed", e.code,
                backgroundColor: Colors.white);
          } else if (e.code == 'invalid-credential') {
            Get.snackbar("Request Failed", e.code,
                backgroundColor: Colors.white);
          }
        } catch (e) {
          Get.snackbar("Request Failed", e.toString(),
              backgroundColor: Colors.white);
        }
      }
    }
    return user;
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // if (!kIsWeb) {
      // }
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      print("Current User with google sign in:");
      print(googleSignIn.currentUser);
    } catch (e) {
      print(e);
      // Get.snackbar("Google signout error", e.toString(),        backgroundColor: Colors.white);
    }
  }
}

class AppleSignInController extends GetxController {
  static Future<User?> signInWithApple() async {
    User? user;

    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
            final AuthCredential credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final UserCredential _res =
                await FirebaseAuth.instance.signInWithCredential(credential);

            user = _res.user;
            Get.offAll(() => HomeScreen());
          } catch (e) {
            print(e);
            Get.snackbar(
              "Request Failed",
              e.toString(),
            );
          }
          break;
        case AuthorizationStatus.error:
          // do something
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } catch (error) {
      print(error);
      Get.snackbar(
        "Request Failed",
        error.toString(),
      );
    }
    return user;
  }
}

class FacebookSignInController {
  static login() async {
    try {
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: [
        "email",
      ]); // by default we request the email and the public profile
      // or FacebookAuth.i.login()
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        print("access token ${accessToken.userId}");

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);

        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        Get.offAll(() => HomeScreen());
      } else {
        print(result.status);
        print(result.message);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Request Failed", e.toString(),
          backgroundColor: Colors.white);
    }
  }

  static logout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print(e);
    }
  }
}
