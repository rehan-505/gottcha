// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import 'package:gottcha/screens/auth/forgot_password.dart';
import 'package:gottcha/screens/auth/sign_up.dart';
import 'package:gottcha/screens/home/home.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';

import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/custom_textfield.dart';

import 'auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final AuthController authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          // SvgPicture.asset(
          //     "assets/images/background.svg",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          resHeightBox(69),
                          SvgPicture.asset("assets/images/logo.svg"),
                          resHeightBox(10),
                          Text(
                            login,
                            style: blackHeadingStyle40,
                          ),
                        ],
                      ),
                      Container(
                        decoration: defaultCurveBoxDecoration,
                        padding: EdgeInsets.only(
                            left: resWidth(16),
                            right: resWidth(16),
                            top: resHeight(30)),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                hintText: "Enter Your email",
                                headingText: "Email",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field is required";
                                  } else if (!(RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value))) {
                                    return "Invalid Email";
                                  }

                                  return null;
                                },
                                textEditingController: emailController,
                              ),
                              resHeightBox(16),
                              Obx(() => CustomTextField(
                                    obscureText:
                                        authController.loginPassHide.value,
                                    hintText: "Create Your password",
                                    headingText: "Password",
                                    suffixIconData:
                                        !authController.loginPassHide.value
                                            ? CupertinoIcons.eye_slash_fill
                                            : CupertinoIcons.eye_fill,
                                    onSuffixIconTap: () {
                                      authController.loginPassHide.value =
                                          !(authController.loginPassHide.value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                    textEditingController: passController,
                                  )),
                              resHeightBox(8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ForgotPasswordScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 0.3,

                                      /// space between underline and text
                                    ),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: greyColor,
                                      width: 1.0,

                                      /// Underline width
                                    ))),
                                    child: Text(
                                      "Forgot Password?",
                                      style: greyBoldStyle16,
                                    ),
                                  ),
                                ),
                              ),
                              resHeightBox(32),
                              Obx(() => Container(
                                    child: authController.loading.value
                                        ? SizedBox(
                                            height: resHeight(45),
                                            width: resHeight(45),
                                            child:
                                                const CircularProgressIndicator(
                                              color: primaryColor1,
                                            ),
                                          )
                                        : CustomButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                await authController.emailLogin(
                                                    emailController.text,
                                                    passController.text);
                                              }
                                            },
                                            text: "Log in",
                                          ),
                                  )),
                              resHeightBox(16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dontHaveAcc,
                                    style: greyNormalStyle16,
                                  ),
                                  // Text("Sign Up",style: greyBoldStyle16, ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => SignUpScreen());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 0.3,

                                        /// space between underline and text
                                      ),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: greyColor,
                                        width: 1.0,

                                        /// Underline width
                                      ))),
                                      child: Text(
                                        "Sign Up",
                                        style: greyBoldStyle16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              resHeightBox(32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildGoogleButton(),
                                  resWidthBox(15),
                                  buildFbButton(),
                                  (Platform.isAndroid)?SizedBox():resWidthBox(15),
                                  (Platform.isAndroid)?SizedBox():buildAppleButton()
                                ],
                              ),
                              resHeightBox(32),
                              InkWell(
                                  onTap: () async {
                                    await authController.signInAnonymously();
                                  },
                                  child: gradientNormalStyle(
                                      "Continue as a guest")),
                              resHeightBox(20),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
