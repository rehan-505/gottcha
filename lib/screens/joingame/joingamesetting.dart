import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/creategame/creategamecontroller.dart';
import 'package:gottcha/screens/joingame/joincontroller.dart';
import 'package:gottcha/screens/lobby_room/lobby_room.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/custom_textfield.dart';
import 'package:gottcha/widgets/customappbar.dart';

class JoinGameSettingScreen extends StatelessWidget {
  JoinGameSettingScreen({Key? key}) : super(key: key);
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
              _buildBottomSheet(),
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

  _buildBottomSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: resHeight((Get.height*0.68).toInt()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _controller.formNameKey,
                  child:  CustomTextField(
                    hintText: "Kate",
                    headingText: "Your Name",
                    textEditingController:_controller.lobbyName,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                ),
                resHeightBox(20),
                Text(
                 'Add your icon',
                  style: blackBoldStyle16,
                ),
                resHeightBox(10),

                SizedBox(
                  height: 190,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, childAspectRatio: 1),
                      itemCount: _controller.avatar.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _controller.selectedAvatar.value =
                            _controller.avatar[index];
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Obx(
                                    ()=>CustomGradientContainer(
                                      shadow: _controller.selectedAvatar.value ==
                                          _controller.avatar[index],
                                      gradient: _controller.selectedAvatar.value ==
                                          _controller.avatar[index]? LinearGradient(
                                        colors: [primaryColor1, primaryColor2],):LinearGradient(colors: [Colors.white,Colors.white]),
                                      strokeWidth: 3,
                                      child: CircleAvatar(
                                        backgroundColor: Color(
                                            -202032),
                                          backgroundImage: Image.asset(
                                            _controller.avatar[index],
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.fill,
                                          ).image),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 10,
                                child: Obx(() =>
                                _controller.selectedAvatar.value ==
                                    _controller.avatar[index]
                                    ? Image.asset(
                                  'assets/images/tick.png',
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.fill,
                                )
                                    : SizedBox()),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
            ///CHANGE IT TO 80

            Column(
              children: [
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
                      _controller.enterLobby();
                    },
                    text: joinGameHeading,
                  ),
                ),
                SizedBox(height: 50,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


