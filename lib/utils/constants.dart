import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:gottcha/screens/home/home.dart';
import 'package:gottcha/utils/NoShrinkModeGlobals.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../screens/auth/auth_controller.dart';

const Color primaryColor1 = Color.fromRGBO(255, 117, 39, 1);
const Color primaryColor2 = Color.fromRGBO(255, 51, 137, 1);
const Color primaryColor1_Opacity10 = Color.fromRGBO(255, 117, 39, 0.1);
const Color primaryColor2_Opacity10 = Color.fromRGBO(255, 51, 137, 0.1);
const Color lightBlue = Color.fromRGBO(124, 153, 255, 1);
const Color backgroundColor = Color.fromRGBO(255, 247, 236, 1.0);
const Color greyColor = Color.fromRGBO(63, 56, 49, 0.6);
const Color greyColor50 = Color.fromRGBO(63, 56, 49, 0.5);

const Color greyColorDark = Color.fromRGBO(63, 56, 49, 1);

const Color greyColor40 = Color.fromRGBO(63, 56, 49, 0.4);
const Color greyLight20 = Color.fromRGBO(63, 56, 49, 0.2);
const Color greyLight10 = Color.fromRGBO(63, 56, 49, 0.1);

const Color whiteColorLight = Color.fromRGBO(255, 252, 249, 1);

final TextStyle blackHeadingStyle40 = TextStyle(
    fontSize: resWidth(40), fontWeight: FontWeight.w800, color: Colors.black);

final TextStyle blackHeadingStyle32 = TextStyle(
    fontSize: resWidth(32), fontWeight: FontWeight.w800, color: Colors.black);

final TextStyle darkHeadingStyle32 = TextStyle(
    fontSize: resWidth(32), fontWeight: FontWeight.w800, color: greyColorDark);

final TextStyle blackStyle24w700 = TextStyle(
    fontSize: resWidth(24), fontWeight: FontWeight.w700, color: Colors.black);

final TextStyle blackNormalStyle16 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w500, color: Colors.black);

final TextStyle blackNormalStyle16w400 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w400, color: Colors.black);

final TextStyle whiteHeadingStyle40 = TextStyle(
    fontSize: resWidth(40), fontWeight: FontWeight.w800, color: Colors.white);

final TextStyle whiteMiniText12 = TextStyle(
    fontSize: resWidth(12), fontWeight: FontWeight.w500, color: Colors.white);

final TextStyle whiteText14w600 = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w600, color: Colors.white);

Widget gradientNormalStyle(String text,
    {int fontSize = 16, FontWeight fontWeight = FontWeight.w600}) {
  return GradientText(
    text,
    style: TextStyle(fontSize: resWidth(fontSize), fontWeight: fontWeight),
    colors: const [primaryColor1, primaryColor2],
  );
}

final TextStyle greyNormalStyle16 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w400, color: greyColor);

final TextStyle greyStyle14DarkText = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w400, color: greyColorDark);

final TextStyle greyStyle14Darkw600 = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w600, color: greyColorDark);

final TextStyle greyMiniStyle14 = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w400, color: greyColor);

final TextStyle greyMiniStyle14Color50 = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w400, color: greyColor50);

final TextStyle greyMiniStyle12Color50w500 = TextStyle(
    fontSize: resWidth(12), fontWeight: FontWeight.w500, color: greyColor50);

final TextStyle greyMiniStyle14Color40 = TextStyle(
    fontSize: resWidth(14), fontWeight: FontWeight.w400, color: greyColor40);

final TextStyle darkGreyNormalStyle16 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w400, color: greyColorDark);

final TextStyle darkGreyStyle16w600 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w600, color: greyColorDark);

final TextStyle darkGreyBoldStyle16 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w900, color: greyColorDark);
final TextStyle darkGreySemiBoldStyle20 = TextStyle(
    fontSize: resWidth(20), fontWeight: FontWeight.w700, color: greyColorDark);

final TextStyle greyBoldStyle16 = TextStyle(
  fontSize: resWidth(16),
  fontWeight: FontWeight.w700,
  color: greyColor,
  // decoration: TextDecoration.underline,
);

final TextStyle greyDarkStyle16 = TextStyle(
  fontSize: resWidth(16),
  fontWeight: FontWeight.w600,
  color: greyColorDark,
  // decoration: TextDecoration.underline,
);

final TextStyle greyDarkStyle16w400 = TextStyle(
  fontSize: resWidth(16),
  fontWeight: FontWeight.w400,
  color: greyColorDark,
  // decoration: TextDecoration.underline,
);

final TextStyle greyDarkStyle24w600 = TextStyle(
  fontSize: resWidth(24),
  fontWeight: FontWeight.w600,
  color: greyColorDark,
  // decoration: TextDecoration.underline,
);

final TextStyle greyDarkHeading64w600 = TextStyle(
  fontSize: resWidth(64),
  fontWeight: FontWeight.w400,
  color: greyColorDark,
  // decoration: TextDecoration.underline,
);

final TextStyle greyDark48w600 = TextStyle(
  fontSize: resWidth(64),
  fontWeight: FontWeight.w400,
  color: greyColorDark,
  // decoration: TextDecoration.underline,
);

final TextStyle greyBoldStyle20 = TextStyle(
  fontSize: resWidth(20),
  fontWeight: FontWeight.w700,
  color: greyColor,
  // decoration: TextDecoration.underline,
);

final TextStyle greyHeadingStyle55 = TextStyle(
    fontSize: resWidth(55), fontWeight: FontWeight.w900, color: greyColorDark);

final TextStyle whiteBoldStyle20 = TextStyle(
  fontSize: resWidth(20),
  fontWeight: FontWeight.w900,
  color: Colors.white,
  // decoration: TextDecoration.underline,
);

const BoxDecoration defaultCurveBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(32), topRight: Radius.circular(32)),
);

class CustomToastContainer extends StatelessWidget {
  const CustomToastContainer({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
          color: greyColor, borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Text(
        text,
        style: whiteNormalStyle16,
        textAlign: TextAlign.center,
      ),
    );
  }
}

double resWidth(int width) {
  return Get.width * (width / 375);
}

SizedBox resWidthBox(int width) {
  return SizedBox(
    width: Get.width * (width / 375),
  );
}

double resHeight(int height) {
  return Get.height * (height / 812);
}

SizedBox resHeightBox(int height) {
  return SizedBox(
    height: Get.height * (height / 812),
  );
}

Future<void> customDialog(BuildContext context,
    {String? img,
    String? buttonText,
    VoidCallback? function,
    required String heading,
    required Widget body,
    int space = 0}) async {
  await showDialog(
      context: context,
      barrierDismissible:false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Builder(
                builder: (context) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        resHeightBox(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: Color.fromRGBO(63, 56, 49, 1.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        img == null ? SizedBox() : SvgPicture.asset(img),
                        // SvgPicture.asset("assets/images/verified.svg"),
                        Text(
                          heading,
                          style: blackHeadingStyle32,
                          textAlign: TextAlign.center,
                        ),
                        resHeightBox(16),
                        body,
                        resHeightBox(space),
                        buttonText == null
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal:10,vertical: 5),
                                child: CustomButton(
                                  onPressed: function!,
                                  text: buttonText,
                                ),
                              )
                      ],
                    ),
                  );
                },
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
              backgroundColor: Colors.white,
            ),
      ));
}

final TextStyle darkGreyNormalStyle20 = TextStyle(
    fontSize: resWidth(20), fontWeight: FontWeight.w400, color: greyColorDark);

final TextStyle darkGreyBoldStyle45 = TextStyle(
    fontSize: resWidth(45), fontWeight: FontWeight.bold, color: greyColorDark);
final TextStyle darkGreyBoldStyle55 = TextStyle(
    fontSize: resWidth(55), fontWeight: FontWeight.bold, color: greyColorDark);

final TextStyle blackBoldStyle16 = TextStyle(
    fontSize: resWidth(16), fontWeight: FontWeight.w900, color: Colors.black);

final TextStyle whiteNormalStyle20 = TextStyle(
  fontSize: resWidth(20),
  fontWeight: FontWeight.w400,
  color: Colors.white,
  // decoration: TextDecoration.underline,
);
final TextStyle whiteNormalStyle16 = TextStyle(
  fontSize: resWidth(16),
  fontWeight: FontWeight.w400,
  color: Colors.white,
  // decoration: TextDecoration.underline,
);
final TextStyle whiteBoldStyle16 = TextStyle(
  fontSize: resWidth(16),
  fontWeight: FontWeight.bold,
  color: Colors.white,
  // decoration: TextDecoration.underline,
);

Future<void> menuDialog(BuildContext context, LobbyModel lobbyModel,
    {required bool isHider}) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: resHeight(100),
                    width: resWidth(345),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor1_Opacity10,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black38)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mode",
                                        style: blackBoldStyle16.copyWith(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        lobbyModel.modeType!.capitalizeFirst!,
                                        style: blackBoldStyle16,
                                      )
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Time",
                                        style: blackBoldStyle16.copyWith(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        lobbyModel.time!,
                                        style: blackBoldStyle16,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resHeight(260),
                    width: resWidth(345),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Menu',
                              style: blackHeadingStyle32.copyWith(fontSize: 26),
                            ),
                            resHeightBox(15),
                            Text(
                              'Game Info',
                              style: blackStyle24w700.copyWith(fontSize: 20),
                            ),
                            const Divider(
                              color: Colors.grey,
                              indent: 20,
                              endIndent: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                Get.back();
                                await quitGameDialog(context, onLeave: () async {
                                  if (isHider) {
                                    lobbyModel.hiders!.removeWhere((element) =>
                                        element.email ==
                                        FirebaseAuth.instance.currentUser!.email);
                                    FirebaseFirestore.instance
                                        .collection('lobbies')
                                        .doc(lobbyModel.lobbyId!.toString())
                                        .update({
                                      'hiders': lobbyModel.hiders!
                                          .map((i) => i.toJson())
                                          .toList(),
                                      'gameFinished': lobbyModel.hiders!.isEmpty
                                    });
                                  } else {
                                    lobbyModel.searchers!.removeWhere((element) =>
                                        element.email ==
                                        FirebaseAuth.instance.currentUser!.email);
                                    FirebaseFirestore.instance
                                        .collection('lobbies')
                                        .doc(lobbyModel.lobbyId!.toString())
                                        .update({
                                      'searchers': lobbyModel.searchers!
                                          .map((i) => i.toJson())
                                          .toList(),
                                      'gameFinished':
                                          lobbyModel.searchers!.isEmpty
                                    });
                                  }
                                });
                              },
                              child: Text(
                                'Leave Game',
                                style: blackStyle24w700.copyWith(fontSize: 20),
                              ),
                            ),
                            resHeightBox(15),
                            CustomButton(
                              onPressed: () {
                                Get.back();
                              },
                              text: 'Resume Game',
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
              backgroundColor: Colors.transparent,
            ),
      ));
}

cannotStartDialog(BuildContext context) async {
  await customDialog(context,
      function: () {},
      buttonText: 'Try Again',
      img: 'assets/images/cross.svg',
      heading: cannotStart,
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            cannotStartDes,
            style: darkGreyNormalStyle20,
            textAlign: TextAlign.center,
          )));
}

gameCrashedDialog(BuildContext context) async {
  await customDialog(context, function: () {
    Get.offAll(HomeScreen());
  },
      buttonText: 'Game Crashed',
      img: 'assets/images/sademoji.svg',
      heading: 'The searcher left the game, so the game is over',
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            cannotStartDes,
            style: darkGreyNormalStyle20,
            textAlign: TextAlign.center,
          )));
}

winDialog(BuildContext context,
    {required bool hiderWon,
    required UserModel myUser,
    required LobbyModel lobbyModel}) async {
  print("showing win Dialog");

  int value = lobbyModel.noOfSecondsGameLasted!;
  // int totalEliminated = lobbyModel.;
  await showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: resHeight(240),
                    width: resWidth(345),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                    top: 20, left: 15, right: 15, bottom: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      myUser.name!,
                                      style: blackHeadingStyle32.copyWith(fontSize: 28),
                                    ),
                                    resHeightBox(10),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor1_Opacity10,
                                          borderRadius: BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.black38)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Game Time",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12,color: greyColorDark),
                                                ),
                                                resHeightBox(5),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        'assets/images/clock.svg'),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          value <= 60
                                                              ? '00:'
                                                              : '${(value) ~/ 60}:',
                                                          style: blackBoldStyle16
                                                              .copyWith(fontSize: 20),
                                                        ),
                                                        Text(
                                                          ( ((value) % 60) < 10)
                                                              ? '0${(value) % 60}'
                                                              : '${(value) % 60}',
                                                          style: blackBoldStyle16
                                                              .copyWith(fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Found",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12,color: greyColorDark),
                                                ),
                                                resHeightBox(5),
                                                Text(
                                                  (lobbyModel.hiders!
                                                          .where((element) =>
                                                              element.eliminated)
                                                          .length)
                                                      .toString(),
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 20),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Unfound",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12,color: greyColorDark),
                                                ),
                                                resHeightBox(5),
                                                Text(
                                                  (lobbyModel.hiders!
                                                          .where((element) =>
                                                              (!element
                                                                  .eliminated))
                                                          .length)
                                                      .toString(),
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 20),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            child: hiderWon
                                ? Image.asset(
                                    myUser.image!,
                                    height: 90,
                                    width: 110,
                                    fit: BoxFit.fill,
                                  )
                                : buildSearcherAvatarForDialog(myUser.image!,
                                    height: 90, width: 110)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: hiderWon?resHeight(480):resHeight(380),
                    width: resWidth(345),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/trophy.svg'),
                            hiderWon
                                ? Container(
                                    height: resHeight(170),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Winners',
                                          style: greyBoldStyle20,
                                        ),
                                        ListView.builder(
                                            itemCount: lobbyModel.hiders!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              UserModel userModel =
                                                  lobbyModel.hiders![index];
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Row(children: [
                                                  Image.asset(
                                                    userModel.image!,
                                                    width: 30,
                                                    height: 30,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  resWidthBox(10),
                                                  Text(
                                                    userModel.name!,
                                                    style: blackBoldStyle16,
                                                  )
                                                ]),
                                              );
                                            }),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            resHeightBox(15),
                            Text(
                              'You Won',
                              style: blackHeadingStyle32.copyWith(fontSize: 28),
                            ),
                            resHeightBox(5),
                            Text(
                              hiderWon
                                  ? "You and ${lobbyModel.hiders!.length - 1} other player are the best hiders! Well done!"
                                  : 'Congratulations, you found all players in this game. ',
                              textAlign: TextAlign.center,
                              style: blackNormalStyle16.copyWith(color: greyColorDark),
                            ),
                            resHeightBox(10),
                            CustomButton(
                              onPressed: () {
                                Get.offAll(() => HomeScreen());
                              },
                              text: 'Go to Main Page',
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
              backgroundColor: Colors.transparent,
            ),
      ),
      barrierDismissible: false);
}

loseDialog(BuildContext context,
    {required bool hiderLost,
    required UserModel myUser,
    required LobbyModel lobbyModel}) async {
  print("showing loseDialog");

  int value = lobbyModel.noOfSecondsGameLasted!;

  await showDialog(
      context: context,
      builder: (_) =>WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: resHeight(230),
                    width: resWidth(345),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                    top: 30, left: 15, right: 15, bottom: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      myUser.name!,
                                      style: blackHeadingStyle32.copyWith(fontSize: 28),
                                    ),
                                    resHeightBox(10),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor1_Opacity10,
                                          borderRadius: BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.black38)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Game Time",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12,color: greyColorDark),
                                                ),
                                                resHeightBox(5),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        'assets/images/clock.svg'),
                                                    Text(
                                                      value <= 60
                                                          ? '00:'
                                                          : '${(value) ~/ 60}:',
                                                      style: blackBoldStyle16
                                                          .copyWith(fontSize: 20),
                                                    ),
                                                    Text(
                                                      ( ((value) % 60) < 10)
                                                          ? '0${(value) % 60}'
                                                          : '${(value) % 60}',
                                                      style: blackBoldStyle16
                                                          .copyWith(fontSize: 20),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Found",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12,color: greyColorDark),
                                                ),
                                                resHeightBox(5),
                                                Text(
                                                  (lobbyModel.hiders!
                                                          .where((element) =>
                                                              element.eliminated)
                                                          .length)
                                                      .toString(),
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 20,color: greyColorDark),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Unfound",
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 12),
                                                ),
                                                resHeightBox(5),
                                                Text(
                                                  (lobbyModel.hiders!
                                                          .where((element) =>
                                                              (!element
                                                                  .eliminated))
                                                          .length)
                                                      .toString(),
                                                  style: blackBoldStyle16
                                                      .copyWith(fontSize: 20),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            child: hiderLost
                                ? Image.asset(
                                    myUser.image!,
                                    height: 70,
                                    width: 90,
                                    fit: BoxFit.fill,
                                  )
                                : buildSearcherAvatarForDialog(myUser.image!,
                                    height: 70, width: 90)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: resHeight(500),
                    width: resWidth(345),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/sademoji.svg',
                              height: 110,
                              width: 110,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              height: resHeight(170),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Text(
                                    'Winners',
                                    style: greyBoldStyle20,
                                  ),
                                  ListView.builder(
                                      itemCount: hiderLost
                                          ? lobbyModel.searchers!.length
                                          : lobbyModel.hiders!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        UserModel user = hiderLost
                                            ? lobbyModel.searchers![index]
                                            : lobbyModel.hiders![index];
                                        return Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Row(children: [
                                            Image.asset(
                                              user.image!,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.fill,
                                            ),
                                            resWidthBox(10),
                                            Text(
                                              user.name!,
                                              style: blackBoldStyle16,
                                            )
                                          ]),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            resHeightBox(10),
                            Text(
                              'You Lost!',
                              style: blackHeadingStyle32,
                            ),
                            resHeightBox(10),
                            Text(
                              hiderLost
                                  ? "The searcher found all of hiders!"
                                  : '${(lobbyModel.hiders!.where((element) => !element.eliminated).length)} players have slipped out of your hands in this game! ',
                              textAlign: TextAlign.center,
                              style: blackNormalStyle16.copyWith(color: greyColorDark),
                            ),
                            resHeightBox(10),
                            CustomButton(
                              onPressed: () {
                                Get.offAll(() => HomeScreen());
                              },
                              text: 'Go to Main Page',
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
              backgroundColor: Colors.transparent,
            ),
      ),
      barrierDismissible: false);
}

showOutOfGameDialog() async {
  NoShrinkModeGobals.showingDialog = true;

  await Get.defaultDialog(
      content: AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32))),
    content: Builder(
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              resHeightBox(30),
              SvgPicture.asset("assets/images/sademoji.svg"),
              Text(
                "You are out of game",
                style: blackHeadingStyle32,
                textAlign: TextAlign.center,
              ),
              resHeightBox(16),
              Text(
                "You are out of the the area, searchers can see you.",
                style: darkGreyNormalStyle16,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Go inside within ",
                    style: darkGreyNormalStyle16,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "30 seconds",
                    style: darkGreyStyle16w600,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              resHeightBox(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: "OK, I`m running",
                ),
              )
            ],
          ),
        );
      },
    ),
    insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
    backgroundColor: Colors.white,
  ));
  NoShrinkModeGobals.showingDialog = false;
}

outOfZoneDeath() async {
  if (NoShrinkModeGobals.showingDialog) {
    Get.back();
  }

  await Get.defaultDialog(
      content: AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32))),
    content: Builder(
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              resHeightBox(30),
              SvgPicture.asset("assets/images/sademoji.svg"),
              Text(
                "You are out of game",
                style: blackHeadingStyle32,
                textAlign: TextAlign.center,
              ),
              resHeightBox(16),
              Text(
                "You are out of the the area, You are eliminated",
                style: darkGreyNormalStyle16,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: "Spectate",
                ),
              )
            ],
          ),
        );
      },
    ),
    insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
    backgroundColor: Colors.white,
  ));
}

showGameCrashedSearcherLeft(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          content: Builder(
            builder: (context) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    resHeightBox(30),
                    SvgPicture.asset("assets/images/sademoji.svg"),
                    Text(
                      "Game crashed",
                      style: blackHeadingStyle32,
                      textAlign: TextAlign.center,
                    ),
                    resHeightBox(16),
                    Text(
                      "The searcher left the game, so the\n game is over",
                      style: darkGreyNormalStyle16,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomButton(
                        onPressed: () {
                          Get.offAll(() =>
                              HomeScreen());
                        },
                        text: "Go to Main Page",
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
          backgroundColor: Colors.white,
        );
      });
}
showInfoMenu(BuildContext context) async {
  return await customDialog(context,
      heading: gameInfo,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            searchers,
            style: darkGreySemiBoldStyle20,
            textAlign: TextAlign.center,
          ),
          resHeightBox(10),
          Text(
            searcherInfo,
            style: darkGreyNormalStyle16,
            textAlign: TextAlign.left,
          ),
          resHeightBox(10),
          Text(
            hider,
            style: darkGreySemiBoldStyle20,
            textAlign: TextAlign.center,
          ),
          resHeightBox(10),
          Text(
            hiderInfo,
            style: darkGreyNormalStyle16,
            textAlign: TextAlign.left,
          ),
          resHeightBox(10),
        ],
      ),
      buttonText: infoButtonText, function: () {
        Get.back();
      });
}
quitGameDialog(BuildContext context,
    {bool searcher = false, required Function onLeave}) async {
  await customDialog(
    context,
    heading: 'Quiet Game',
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        resHeightBox(10),
        Text(
          'Are sure you want to quit game? You won`t be able to return anymore,',
          style: darkGreyNormalStyle16,
          textAlign: TextAlign.left,
        ),
        resHeightBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlineGradientButton(
              backgroundColor: Colors.white,
              gradient: const LinearGradient(
                colors: [primaryColor1, primaryColor2],
                // begin: Alignment.topCenter,
                // end: Alignment.bottomCenter,
              ),
              strokeWidth: 2,
              radius: const Radius.circular(16),
              onTap: () async {
                await onLeave();
                Get.offAll(() =>  HomeScreen());
              },
              child: SizedBox(
                height: resHeight(43),
                width: resWidth(120),
                child: Center(
                    child: gradientNormalStyle("Yes,quit",
                        fontSize: 20, fontWeight: FontWeight.w600)),
              ),
            ),
            CustomButton(
              width: resWidth(130),
              onPressed: () async {
                Get.back();
              },
              text: "No,stay",
            ),
          ],
        ),
        resHeightBox(10),
      ],
    ),
  );
}

disConnectGame(Function onTryAgain) async {
  await Get.defaultDialog(barrierDismissible: false,
    backgroundColor: Colors.white,
      content: Builder(
        builder: (context) {
          return WillPopScope(
              onWillPop: () async => false,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/disconnect.svg"),
                  Text(
                    "Disconnected",
                    style: darkHeadingStyle32,
                    textAlign: TextAlign.center,
                  ),
                  resHeightBox(16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: resWidth(16)),
                    child: Text(
                        "You`ve got the bad internet connection. You can try to reconnect in 5 minutes or just leave.",
                        style: greyDarkStyle16w400,
                        textAlign: TextAlign.center),
                  ),
                  resHeightBox(32),
                  CustomButton(
                    onPressed: () async {
                      // Get.back();
                      await onTryAgain();
                    },
                    text: "Try Again",
                  ),
                  resHeightBox(26),
                  InkWell(
                      onTap: () {
                        // Get.back();
                        Get.offAll(() => HomeScreen());
                      },
                      child: gradientNormalStyle("Leave Game",
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  resHeightBox(10),
                ],
              ),
            ),
          );
        },
      ),
    title: "",
    contentPadding: EdgeInsets.symmetric(horizontal: resWidth(16), vertical: resHeight(16)),
    radius: 35,



  );
}
treePassingDialog() async {
  await Get.defaultDialog(
    backgroundColor: Colors.white,
    content: Builder(
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/images/treepassingicon.svg"),
              Text(
                "Warning!",
                style: darkHeadingStyle32,
                textAlign: TextAlign.center,
              ),
              resHeightBox(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: resWidth(16)),
                child: Text(
                    "Be careful when you’re hiding. Some areas may be owned by someone and it’s may be restricted to trespassing into such areas.",
                    style: greyDarkStyle16w400,
                    textAlign: TextAlign.center),
              ),
              resHeightBox(32),
              CustomButton(
                onPressed: () async {
                  Get.back();

                },
                text: "OK, I understand",
              ),

              resHeightBox(10),
            ],
          ),
        );
      },
    ),
    title: "",
    contentPadding: EdgeInsets.symmetric(horizontal: resWidth(16), vertical: resHeight(16)),
    radius: 35,


  );
}
Widget buildGoogleButton() {
  return InkWell(
    onTap: () async {
      await GoogleSignInController.signInWithGoogle();
    },
    child: Material(
      elevation: 10,
      color: Colors.white,
      shadowColor: const Color.fromRGBO(155, 155, 155, 0.2),
      borderRadius: const BorderRadius.all(const Radius.circular(16)),
      child: Container(
        height: resHeight(60),
        width: resWidth(101),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // boxShadow: [BoxShadow(color: Color.fromRGBO(155, 155, 155, 0.2))]
        ),
        // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/images/google.svg"),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildFbButton() {
  return InkWell(
    onTap: () async {
      await FacebookSignInController.login();
      // await AuthController.logoutAll();
    },
    child: Material(
      elevation: 10,
      color: Colors.white,
      shadowColor: const Color.fromRGBO(155, 155, 155, 0.2),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        height: resHeight(60),
        width: resWidth(101),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // boxShadow: [BoxShadow(color: Color.fromRGBO(155, 155, 155, 0.2))]
        ),
        // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/images/bxl_facebook.svg"),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildAppleButton() {
  return InkWell(
    onTap: () async {
      await AppleSignInController.signInWithApple();
    },
    child: Material(
      elevation: 10,
      color: Colors.white,
      shadowColor: const Color.fromRGBO(155, 155, 155, 0.2),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        height: resHeight(60),
        width: resWidth(101),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // boxShadow: [BoxShadow(color: Color.fromRGBO(155, 155, 155, 0.2))]
        ),
        // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/images/apple.svg"),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildCrownAvatar(String imgPath) {
  return SizedBox(
    width: resWidth(55),
    height: resHeight(50),
    child: Stack(
      children: [
        Container(
          width: resWidth(45),
          height: resHeight(45),

          // width: resWidth(65),
          // height: resHeight(50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor1,
                  primaryColor2,
                ],
              ),
              // borderRadius: BorderRadius.circular(12),
              shape: BoxShape.circle),
          margin: const EdgeInsets.only(bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(
                  -202032),
                  // borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.circle
                  // border: selected ? Border.all(color: whiteColorLight) : null
                  ),
              padding: EdgeInsets.all(resWidth(1)),
              child: Center(
                child: SizedBox(
                  width: resWidth(55),
                  height: resHeight(50),
                  child: Image.asset(
                    imgPath,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 0, right: 0, child: Image.asset("assets/images/crown.png")),
      ],
    ),
  );
}

Widget buildSearcherAvatarOutlined(String imgPath) {
  return SizedBox(
    width: resWidth(55),
    height: resHeight(50),
    child: Stack(
      children: [
        Container(
          width: resWidth(45),
          height: resHeight(45),

          // width: resWidth(65),
          // height: resHeight(50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor1,
                  primaryColor2,
                ],
              ),
              // borderRadius: BorderRadius.circular(12),
              shape: BoxShape.circle),
          margin: const EdgeInsets.only(bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(
                      -202032),
                  // borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.circle
                // border: selected ? Border.all(color: whiteColorLight) : null
              ),
              padding: EdgeInsets.all(resWidth(1)),
              child: Center(
                child: SizedBox(
                  width: resWidth(55),
                  height: resHeight(50),
                  child: Image.asset(
                    imgPath,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 0, right: 0, child: Image.asset("assets/images/searcher_glasses.png")),
      ],
    ),
  );
}


///doorbeen
Widget buildSearcherAvatar(String imgPath) {
  return SizedBox(
    width: resWidth(53),
    height: resHeight(53),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Image.asset(
            imgPath,
            width: resWidth(48),
            height: resHeight(48),
          ),
        ),
        // Positioned(
        //     top: 0,
        //     right: 0,
        //     child: SvgPicture.asset("assets/images/searcher_glasses.svg")),
        Positioned(
            top: 0,
            right: 0,
            child: Container(
                color: Colors.white,
                child: Image.asset("assets/images/searcher_glasses.png")))
      ],
    ),
  );
}

Widget buildSearcherAvatarForDialog(String imgPath,
    {int height = 69, int width = 69}) {
  return SizedBox(
    width: resWidth(width),
    height: resHeight(height),
    child: Stack(
      children: [
        Container(
          width: resWidth(width - 5),
          height: resHeight(height - 5),

          // width: resWidth(65),
          // height: resHeight(50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor1,
                  primaryColor2,
                ],
              ),
              // borderRadius: BorderRadius.circular(12),
              shape: BoxShape.circle),
          margin: const EdgeInsets.only(bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.circle
                  // border: selected ? Border.all(color: whiteColorLight) : null
                  ),
              child: Center(
                child: SizedBox(
                  child: Image.asset(
                    imgPath,
                    fit: BoxFit.fill,
                    width: resWidth(width - 30),
                    height: resHeight(height + 10),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //     top: 0,
        //     right: 0,
        //     child: Image.asset("assets/images/crown.png")),
        Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/searcher_glasses.svg',
              color: Colors.red,
            ))
      ],
    ),
  );
}

///For Eliminated Player
Widget buildCrossAvatar(String imgPath) {
  return SizedBox(
    width: resWidth(53),
    height: resHeight(53),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: Image.asset(
                imgPath,
                width: resWidth(48),
                height: resHeight(48),
              ),
            ),
          ),
        ),
        // Positioned(
        //     top: 0,
        //     right: 0,
        //     child: SvgPicture.asset("assets/images/searcher_glasses.svg")),
        Positioned(
            top: 0,
            right: 0,
            child: Container(
                color: Colors.white,
                child: Image.asset("assets/images/cross.png")))
      ],
    ),
  );
}

/// Time in strings and time in minutes
Map<String, int> globalTimeMap = {
  "10 mins": 10,
  "20 mins": 20,
  "30 mins": 30,
  "60 mins": 60,
  "90 mins": 90,
  "1 hours": 60,
  "1h30min": 90,
  "2 hours": 120,
  "unlimited": 999,
};

isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

class CustomGradientContainer extends StatelessWidget {
  CustomGradientContainer(
      {required this.gradient,
      required this.child,
      this.strokeWidth = 1,
      required this.shadow});

  final Widget child;
  final double strokeWidth;
  final bool shadow;

  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final kInnerDecoration =
        BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
      shadow
          ? BoxShadow(
              color: primaryColor1.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          : BoxShadow(color: Colors.transparent),
    ]);
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(strokeWidth),
        child: DecoratedBox(
          decoration: kInnerDecoration,
          child: child,
        ),
      ),
    );
  }
}
