import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/creategame/creategamecontroller.dart';
import 'package:gottcha/screens/joingame/joincontroller.dart';
import 'package:gottcha/screens/joingame/joingamesetting.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/custom_textfield.dart';
import 'package:gottcha/widgets/customappbar.dart';

class JoinGameScreen extends StatelessWidget {
  JoinGameScreen({Key? key}) : super(key: key);
  JoinGameSettingController _controller=Get.put(JoinGameSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              resHeightBox(30),
              CustomAppBar(
                leading: 'assets/images/Arrow.svg',
                action: 'assets/images/info.svg',
                isLeadingRec: true,
                actionFunction: () async {
                  await showInfoMenu(context);
                },
                leadingFunction: () {Get.back();},
              ),
              buildUpperLayer(),
              resHeightBox(40),
              Expanded(child: _buildBottomSheet()),
              
            ],
          ),
        ));
  }

  buildUpperLayer() {
    return Column(
      children: [
        resHeightBox(20),
        Text(
          joinGameHeading,
          style: darkGreyBoldStyle45,
          textAlign: TextAlign.center,
        ),
        resHeightBox(5),
        Text(
          enterId,
          style: darkGreyNormalStyle20,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Padding(
      padding:  EdgeInsets.only(left: 20,right: 20, bottom: resHeight(30)),
      child: SizedBox(
        // height: Get.height*0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                resHeightBox(5),
                Form(
                  key: _controller.formIdKey,
                  child: Obx(
                    ()=> CustomTextField(
                      textEditingController: _controller.lobbyId,
                      keyboardType: TextInputType.number,
error: _controller.error.value?'Game Id does not exist':null,
                      hintText: "36723672362",
                      headingText: "Game Id",
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return "Game ID is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            Obx(
                ()=>_controller.loading.value?Center(
                  child: SizedBox(
                    height: resHeight(45),
                    width: resHeight(45),
                    child: const CircularProgressIndicator(
                      color: primaryColor1,
                    ),
                  ),
                ) : CustomButton(
                onPressed: () async {
                  if(_controller.formIdKey.currentState!.validate()) {
                    bool value=await _controller.checkIfDocExists();
                    if(value) {
                      Get.to(() => JoinGameSettingScreen());
                    } else {
                      _controller.error.value=true;
                    }
                  }
                },
                text: joinGameHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
