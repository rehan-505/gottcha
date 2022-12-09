import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/creategame/creategamecontroller.dart';
import 'package:gottcha/screens/creategame/creategamesettingcontroller.dart';

import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/custom_textfield.dart';
import 'package:gottcha/widgets/customappbar.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class CreateGameSettingScreen extends StatelessWidget {
  CreateGameSettingScreen({Key? key}) : super(key: key);
  CreateGameSettingController _controller =
  Get.put(CreateGameSettingController());
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
                leadingFunction: () {
                  Get.back();
                },
              ),
              buildUpperLayer(),
              resHeightBox(40),
              _buildBottomSheet(context),
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
          enterSettings,
          style: darkGreyNormalStyle20,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  _buildBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height:resHeight((Get.height * 0.67).toInt()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            resHeightBox(40),
            Form(
              key: _controller.formKey,
              child:  CustomTextField(
                hintText: "Enter Your Name",
                headingText: "Your Name",
                textEditingController: _controller.userNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },

              ),
            ),
            resHeightBox(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yourIcon,
                      style: blackBoldStyle16,
                    ),
                    resHeightBox(10),
                    GestureDetector(
                      onTap: () async {
                        await selectAvatarDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: primaryColor1.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          changeIcon,
                          style: whiteBoldStyle16,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                      (){
                    print(_controller.selectedAvatar.value);
                    return Image.asset(
                      _controller.selectedAvatar.value,
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    );
                  },
                )
              ],
            ),
            resHeightBox(25),
            buildSettingTab(context),
            Spacer(),
            Obx(
                  () =>_controller.loading.value?Center(
                    child: SizedBox(
            height: resHeight(45),
        width: resHeight(45),
        child: const CircularProgressIndicator(
          color: primaryColor1,
        ),
    ),
                  ) : CustomButton(
                onPressed: () async {
                 _controller.createGame();
                },
                text: createGameHeading,
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

  buildSettingTab(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await selectTimeDialog(context);
          },
          child: Container(
            padding:
            const EdgeInsets.only(left: 20, top: 13, bottom: 13, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromRGBO(63, 56, 49, 0.2),
                  width: 1,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gameTime,
                  style: blackBoldStyle16,
                ),
                Row(
                  children: [
                    Obx(
                          () => Text(
                        _controller.selectedTime.value == '0'
                            ? ('Choose time')
                            : (_controller.selectedTime.value),
                        style: greyNormalStyle16,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor1,
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        resHeightBox(5),
        GestureDetector(
          onTap: () async {
            selectModeDialog(context);
          },
          child: Container(
            padding:
            const EdgeInsets.only(left: 20, top: 13, bottom: 13, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromRGBO(63, 56, 49, 0.2),
                  width: 1,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Game Mode',
                  style: blackBoldStyle16,
                ),
                Row(
                  children: [
                    Obx(
                          () => Text(
                        _controller.shrinked.value ? 'Shrink' : 'No Shrink',
                        style: greyNormalStyle16,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor1,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildCard({required bool isShrinkMode}) {
    return GestureDetector(
      onTap: () {
        _controller.selected.value = isShrinkMode ? 1 : 2;
      },
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            Image.asset(isShrinkMode
                ? 'assets/images/shrink.png'
                : 'assets/images/noshrink.png'),
            Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                            () => Container(
                          decoration: BoxDecoration(
                              color: (isShrinkMode
                                  ? _controller.selected.value == 1
                                  : _controller.selected.value == 2)
                                  ? primaryColor1
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: (isShrinkMode
                                  ? _controller.selected.value == 1
                                  : _controller.selected.value == 2)
                                  ? Border.all(color: Colors.transparent)
                                  : Border.all(color: Colors.white, width: 2)),
                          height: 50,
                          width: 50,
                          child: (isShrinkMode
                              ? _controller.selected.value == 1
                              : _controller.selected.value == 2)
                              ? SvgPicture.asset('assets/images/tickicon.svg')
                              : const SizedBox(),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isShrinkMode ? shrinkMode : nonShrinkMode,
                            style: whiteBoldStyle20,
                          ),
                          Text(
                            isShrinkMode ? shrinkModeDes : nonShrinkModeDes,
                            style: whiteNormalStyle16.copyWith(fontSize: 12),
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

  selectModeDialog(BuildContext context) async {
    await customDialog(context,
        heading: chooseGameMode,
        body: Column(
          children: [
            buildCard(isShrinkMode: true),
            buildCard(isShrinkMode: false),
            resHeightBox(10),
            CustomButton(
              onPressed: () async {
                _controller.shrinked.value = _controller.selected.value == 1;
                Get.back();
              },
              text: 'Apply',
            ),
            resHeightBox(10),
            InkWell(
                onTap: () {
                  Get.back();
                },
                child:  SizedBox(
                  height:resHeight(60),
                  width: Get.width,
                  child: Center(
                    child: gradientNormalStyle(
                      'Cancel',

                    ),
                  ),
                ))
          ],
        ));
  }

  selectTimeDialog(BuildContext context) async {
    await customDialog(context,
        heading: gameTime,
        body: SizedBox(
          width: resWidth(350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose the time of game',style: blackNormalStyle16,),
              resHeightBox(40),
              CustomButton(
                onPressed: () async {
                  _controller.selectedTime.value ='unlimited';
                  Get.back();

                },
                text: 'until game is finished',
              ),resHeightBox(10),
              SizedBox(
                child: SizedBox(
                  height: resHeight(70),
                  child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: _controller.time.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(
                              () => InkWell(
                            onTap: () {
                              _controller.tempSelectedTime.value =
                              _controller.time[index];
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  gradient:
                                  _controller.tempSelectedTime.value ==
                                      _controller.time[index]
                                      ? const LinearGradient(colors: [
                                    primaryColor1,
                                    primaryColor2
                                  ])
                                      : const LinearGradient(colors: [
                                    backgroundColor,
                                    backgroundColor
                                  ]),
                                  border: Border.all(color: primaryColor1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                  child: Text(
                                    _controller.time[index],
                                    style: _controller.tempSelectedTime.value ==
                                        _controller.time[index]
                                        ? whiteNormalStyle16
                                        : blackNormalStyle16,
                                  )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              resHeightBox(10),
              CustomButton(
                onPressed: () async {
                  _controller.selectedTime.value =
                      _controller.tempSelectedTime.value;
                  Get.back();
                },
                text: 'Apply',
              ),
              resHeightBox(10),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child:  SizedBox(
                    height:resHeight(60),
                    width: Get.width,
                    child: Center(
                      child: gradientNormalStyle(
                        'Cancel',

                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  selectAreaDialog(BuildContext context) async {
    _controller.customArea=TextEditingController(text: '10');
    _controller.customAreaValue.value='';
    await customDialog(context,
        heading: gameTime,
        body: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose the time of game',style: blackNormalStyle16,),
              resHeightBox(10),
              SizedBox(
                child: SizedBox(
                  height: resHeight(140),
                  child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: _controller.area.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(
                              () => InkWell(
                            onTap: () {
                              _controller.tempSelectedArea.value =
                              _controller.area[index];
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  gradient:
                                  _controller.tempSelectedArea.value ==
                                      _controller.area[index]
                                      ? const LinearGradient(colors: [
                                    primaryColor1,
                                    primaryColor2
                                  ])
                                      : const LinearGradient(colors: [
                                    backgroundColor,
                                    backgroundColor
                                  ]),
                                  border: Border.all(color: primaryColor1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                  child: Text(
                                    _controller.area[index],
                                    style: _controller.tempSelectedArea.value ==
                                        _controller.area[index]
                                        ? whiteNormalStyle16
                                        : blackNormalStyle16,
                                  )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              resHeightBox(10),
              OutlineGradientButton(
                gradient: const LinearGradient(
                  colors: [primaryColor1, primaryColor2],
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                ),
                strokeWidth: 2,
                child: Container(
                  height: resHeight(40),
                  width: resWidth(283),
                  child: Obx(()=> Center(child: gradientNormalStyle(_controller.customAreaValue.value==''?"Choose your size":'${_controller.customAreaValue.value}m', fontSize: 20, fontWeight: FontWeight.w600 ))),
                ),
                radius: Radius.circular(16),
                onTap: () async{


                  await showQuantityDialog(context);


                },

              ),
              resHeightBox(10)
              ,              CustomButton(
                onPressed: () async {
                  if(_controller.customAreaValue.value!=''){
                    _controller.selectedArea.value =_controller.customAreaValue.value+'m';
                  }
                  else
                  _controller.selectedArea.value =
                      _controller.tempSelectedArea.value;
                  Get.back();
                },
                text: 'Apply',
              ),
              resHeightBox(10),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child:  gradientNormalStyle(
                    'Cancel',

                  ))
            ],
          ),
        ));
  }

  selectAvatarDialog(BuildContext context) async {
    await customDialog(context,
        heading: changeIcon,
        body: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is how your friends will see you',style: blackNormalStyle16,),
              resHeightBox(10),
              SizedBox(
                height: 200,
                child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1),
                    itemCount: _controller.avatar.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _controller.tempSelectedAvatar.value =
                          _controller.avatar[index];
                        },
                        child: Stack(
                          children: [

                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Obx(
                                      ()=>CustomGradientContainer(
                                    shadow: _controller.tempSelectedAvatar.value ==
                                        _controller.avatar[index],
                                    gradient: _controller.tempSelectedAvatar.value ==
                                        _controller.avatar[index]? LinearGradient(
                                      colors: [primaryColor1, primaryColor2],):LinearGradient(colors: [Colors.white,Colors.white]),
                                    strokeWidth: 3,
                                    child: CircleAvatar(backgroundColor: Color(
                                        -202032),

                                        backgroundImage: Image.asset(
                                          _controller.avatar[index],
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ).image),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 10,
                              child: Obx(() =>
                              _controller.tempSelectedAvatar.value ==
                                  _controller.avatar[index]
                                  ? Image.asset(
                                'assets/images/tick.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              )
                                  : SizedBox()),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              resHeightBox(10),
              CustomButton(
                onPressed: () async {
                  _controller.selectedAvatar.value =
                      _controller.tempSelectedAvatar.value;
                  Get.back();
                },
                text: 'Apply',
              ),
              resHeightBox(10),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child:  SizedBox(
                    height:resHeight(60),
                    width: Get.width,
                    child: Center(
                      child: gradientNormalStyle(
                        'Cancel',

                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
  Future<void> showQuantityDialog(BuildContext context)async{
    await showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))
          ),
          content: Builder(
            builder: (context) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    resHeightBox(30),
                    // img==null?SizedBox():SvgPicture.asset("assets/images/Frame44.svg"),
                    // SvgPicture.asset("assets/images/verified.svg"),
                    Text("Choose your own Game Size", style: darkHeadingStyle32, textAlign: TextAlign.center,),
                    resHeightBox(16),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: resWidth(16)),
                      child: Text("Enter your  wanted Game Area in meters", style: greyDarkStyle16w400,textAlign: TextAlign.center),
                    ),
                    resHeightBox(32),

                    Container(
                      decoration:  BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            primaryColor1,
                            primaryColor2,
                          ],
                        ) ,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 0),
                      height: resHeight(64),
                      width: resWidth(283),
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // border: selected ? Border.all(color: whiteColorLight) : null
                          ),
                          padding:  EdgeInsets.only(left: resWidth(12), right: resWidth(22)),
                          child: Center(
                            child: TextFormField(
                              controller: _controller.customArea,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,

                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,

                            ),
                          ),
                        ),
                      ),
                    ),

                    resHeightBox(32),


                    CustomButton(onPressed: (){
                      _controller.customAreaValue.value = _controller.customArea.text;
                      Get.back();
                    }, text: "Apply",),
                    resHeightBox(26),

                    InkWell(
                        onTap: (){Get.back();},
                        child: gradientNormalStyle("Cancel",fontSize: 20, fontWeight: FontWeight.w600)),
                    resHeightBox(40),


                  ],
                ),
              );
            },
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
          backgroundColor: Colors.white,

        )
    );
  }
}

