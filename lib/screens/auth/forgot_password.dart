import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/auth/auth_controller.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';


import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/custom_textfield.dart';
import 'package:gottcha/widgets/customappbar.dart';


class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController forgotPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController authController = AuthController();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Image.asset("assets/images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,

          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      resHeightBox(30),
                      CustomAppBar(
                        leading: 'assets/images/Arrow.svg',
                        isLeadingRec: true,
                        leadingFunction: () {Get.back();},
                      ),
                      resHeightBox(270),
                      Expanded(
                          child: Container(
                            decoration: defaultCurveBoxDecoration,
                            padding: EdgeInsets.symmetric(horizontal: resWidth(16), vertical: 0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  resHeightBox(42),
                                  Text(forgotPass, style: blackHeadingStyle40,),
                                  resHeightBox(16),
                                  Text(forgotPassDetail, style: greyNormalStyle16, textAlign: TextAlign.center,),
                                  resHeightBox(40),
                                  CustomTextField(hintText: "Enter Your email", headingText: "Email",
                                  textEditingController: forgotPassController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Field is required";
                                      }
                                      else if(!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))){
                                        return "Invalid Email";

                                      }

                                      return null;
                                    },

                                  ),
                                  resHeightBox(80),
                              Obx(() =>                                   Container(
                                child: (authController.loading.value) ? SizedBox(
                                  height: resHeight(45),
                                  width: resHeight(45),
                                  child: const CircularProgressIndicator(
                                    color: primaryColor1,
                                  ),
                                ) : CustomButton(onPressed: () async{
                                  if(formKey.currentState!.validate()){
                                    await authController.resetPass(forgotPassController.text,context);
                                  }

                                }, text: "Reset Password",),
                              )),

                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )

          )
        ],
      ),
    );
  }

}
