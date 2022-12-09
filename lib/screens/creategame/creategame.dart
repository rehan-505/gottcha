import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/creategame/creategamecontroller.dart';
import 'package:gottcha/screens/creategame/creategamesetting.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/customappbar.dart';

class CreateGameScreen extends StatelessWidget {
  CreateGameScreen({Key? key}) : super(key: key);
  CreateGameController _controller=Get.put(CreateGameController());

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
          createGameHeading,
          style: darkGreyBoldStyle45,
          textAlign: TextAlign.center,
        ),
        resHeightBox(5),
        Text(
          chooseGameMode,
          style: darkGreyNormalStyle20,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          buildCard(isShrinkMode: true),
          resHeightBox(13),
          buildCard(isShrinkMode: false),
          resHeightBox(40),
          Obx(
                ()=> CustomButton(isDiabled: _controller.selected.value==0,
              onPressed: () async {
                Get.to(()=>CreateGameSettingScreen());
              },
              text: createGameHeading,
            ),
          ),

        ],
      ),
    );
  }

  buildCard({required bool isShrinkMode}) {

    return GestureDetector(
      onTap: (){
        _controller.selected.value=isShrinkMode?1:2;
      },
      child: SizedBox(
        // height: 180,
        child: Stack(
          children: [

            Image.asset(isShrinkMode?'assets/images/shrink.png':'assets/images/noshrink.png'),

            Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  height: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                            ()=>Container(
                          decoration: BoxDecoration(
                              color: (isShrinkMode?_controller.selected.value==1:_controller.selected.value==2)?primaryColor1:Colors.transparent,
                              shape: BoxShape.circle,
                              border:(isShrinkMode?_controller.selected.value==1:_controller.selected.value==2)?Border.all(color: Colors.transparent):Border.all(color: Colors.white,width: 2)),
                          height: 50,
                          width: 50,
                          child: (isShrinkMode?_controller.selected.value==1:_controller.selected.value==2)?SvgPicture.asset('assets/images/tickicon.svg'):SizedBox(),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isShrinkMode?shrinkMode:nonShrinkMode,
                            style: whiteBoldStyle20,
                          ),
                          Text(
                            isShrinkMode?shrinkModeDes:nonShrinkModeDes,
                            style: whiteNormalStyle16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
