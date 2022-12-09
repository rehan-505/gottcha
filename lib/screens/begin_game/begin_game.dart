import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gottcha/screens/creategame/creategamesettingcontroller.dart';
import 'package:gottcha/shrink_mode/shrink_mode.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/widgets/customappbar.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../model/usermodel.dart';
import '../../non_shrink_mode/no_shrink_mode.dart';
import '../../widgets/custom_button.dart';
import 'begin_game_controller.dart';

class BeginGameScreen extends StatefulWidget {
  int lobbyId;

  BeginGameScreen({Key? key,required this.lobbyId, required this.lobbyModel}) : super(key: key);

  final LobbyModel lobbyModel;

  @override
  State<BeginGameScreen> createState() => _BeginGameScreenState();
}

class _BeginGameScreenState extends State<BeginGameScreen> {
  final BeginGameController _controller = Get.put(BeginGameController());

  bool confirmed = false;
  bool hidingTimeDialogVisible = false;
  UserModel? myUser;
  @override
  void initState() {

    myUser=widget.lobbyModel.hiders!.where((element) => element.email==FirebaseAuth.instance.currentUser!.email).isEmpty?null:widget.lobbyModel.hiders!.where((element) => element.email==FirebaseAuth.instance.currentUser!.email).first;
   if(myUser==null){
     myUser=widget.lobbyModel.searchers!.firstWhere((element) => element.email==FirebaseAuth.instance.currentUser!.email);}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("begin game");

    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              bottom: 0,
              child: GoogleMap(
                zoomGesturesEnabled: false,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _controller.kGooglePlex,
                onCameraMove: (c) async {
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.controller.complete(controller);
                },
              ),
            ),
            Positioned(
                right: resWidth(15),
                left: resWidth(15),
                top: resHeight(135),
                child: CustomToastContainer(text :_controller.confirmed
                    ? "Make sure that everyone is hidden\nand start the game!"
                    : "Drag the circle to make area\nbigger or smaller")),
            Positioned(
              // top: 0,
              // left: 0,
              // bottom: 0,
              // right: 0,
              child: GestureDetector(
                  onScaleStart: (ScaleStartDetails scaleStartDetails) {
                    if(_controller.confirmed){
                      return;
                    }
                    _controller.minscale=1;
                    _controller.maxscale=1;

                  },
                  onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
                    if(_controller.confirmed){
                      return;
                    }
                    if(scaleUpdateDetails.scale>_controller.maxscale)
                      _controller.maxscale=scaleUpdateDetails.scale;
                    if(scaleUpdateDetails.scale<_controller.minscale)
                      _controller.minscale=scaleUpdateDetails.scale;
                    print(scaleUpdateDetails.scale);
                  },
                  onScaleEnd: (ScaleEndDetails scaleEndDetails) async {
if(_controller.confirmed){
  return;
}
                    GoogleMapController con=await _controller.controller.future;
                    if(_controller.maxscale==1&&_controller.minscale!=1) {
                      con.animateCamera(CameraUpdate.zoomBy(-_controller.maxscale+_controller.minscale));
                      double temp=_controller.maxscale-_controller.minscale;

                      for(int i=0;i<temp.toInt();i++) {
                        print('loop');
                        _controller.scaleFactor /= 2;

                      }
                      double value=temp-temp.toInt();
                      if(value!=0){
                        print('zerovalue'+value.toString());
                        _controller.scaleFactor+=(_controller.scaleFactor-(0.16*_controller.scaleFactor))*(value);
                      }

                    } else if(_controller.maxscale!=1&&_controller.minscale==1) {
                      con.animateCamera(CameraUpdate.zoomBy(_controller.maxscale-_controller.minscale));
                      double temp=_controller.maxscale-_controller.minscale;

                      for(int i=0;i<temp.toInt();i++) {
                        print('loopzoomin');
                        _controller.scaleFactor /= 2;
                      }
                      double value=temp-temp.toInt();
                      if(value!=0){
                        print('zerovaluezoomin'+value.toString());
                        _controller.scaleFactor-=((_controller.scaleFactor*0.55)*(value));
                      }

                    }
                  },
                  child: Image.asset("assets/images/area.png")),
            ),
            // Positioned.fill(
            //   // top: 0,
            //   // left: 0,
            //   // bottom: 0,
            //   // right: 0,
            //   child:
            //   IgnorePointer(child: Image.asset("assets/images/hint to draghands.png")),
            // ),
            Positioned(
              // top: 0,
              // left: 0,
              // bottom: 0,
              // right: 0,
              child:_controller.confirmed?SizedBox():IgnorePointer(
                  child: SvgPicture.asset(
                    "assets/images/hint to draghands.svg",
                  )),
            ),

            Positioned(
              // top: 0,
              // left: 0,
              // bottom: 0,
              // right: 0,
              child:
              IgnorePointer(child: Image.asset(myUser!.image!.replaceAll(RegExp('avatar'), "avatar_pin"),width: 60,height: 60,fit: BoxFit.fill,)),
            ),
            Positioned(
              top: 0,
              left: 0 ,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(top: resHeight(30)),
                child: CustomAppBar(
                  isActionName: false,
                  isLeadingRec: true,
                  leading: 'assets/images/Vector@2x.svg',
                  action: 'assets/images/info.svg',
                  leadingFunction: () async{
                    await menuDialog(context, widget.lobbyModel,isHider: widget.lobbyModel.hiders!.any((element) => element.email==FirebaseAuth.instance.currentUser!.email)
                    );
                  },
                ),
              ),
            ),
            Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                  EdgeInsets.only(left: resWidth(13), right: resWidth(13)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        onPressed: _controller.confirmed
                            ? () async {
                          await FirebaseFirestore.instance.collection("lobbies").doc(widget.lobbyId.toString()).update({
                            "gameStarted":true,'isHidingTime':true
                          });
                          Get.to(() => NonShrinkMode(lobbyModel: widget.lobbyModel,));
                              }
                            : () async {
                          GoogleMapController con=await _controller.controller.future;
                          double zoom=await con.getZoomLevel();
                          await FirebaseFirestore.instance.collection('lobbies').doc(widget.lobbyId.toString()).update({'area':_controller.scaleFactor.toString(),'mapLat':_controller.userLocation!.latitude,'mapLng':_controller.userLocation!.longitude,'mapZoom':zoom});
                          widget.lobbyModel.mapLat = _controller.userLocation!.latitude;
                          widget.lobbyModel.mapLng = _controller.userLocation!.longitude;
                          widget.lobbyModel.mapZoom = zoom;
                          widget.lobbyModel.area = _controller.scaleFactor.toString();


                          setState(() {
                                  _controller.confirmed = !_controller.confirmed;
                                });

                        },
                        text: _controller.confirmed ? "Start Now" : "Confirm play area",
                      ),
                      _controller.confirmed
                          ? Padding(
                        padding: EdgeInsets.only(top: resHeight(8)),
                        child: OutlineGradientButton(
                          backgroundColor: Colors.white,
                          gradient: const LinearGradient(
                            colors: [primaryColor1, primaryColor2],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          ),
                          strokeWidth: 2,
                          radius: const Radius.circular(16),
                          onTap: () async {
                            if (_controller.hidingTimeDialogVisible) {
                              setState(() {
                                _controller.hidingTimeDialogVisible = false;
                              });
                              return;
                            }

                            await setTimer(context);
                          },
                          child: SizedBox(
                            height: resHeight(43),
                            width: resWidth(343),
                            child: Center(
                                child: gradientNormalStyle(
                                    "Start in X minutes",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      )
                          : const SizedBox(),
                    ],
                  ),
                )),
            // Visibility(
            //   visible: hidingTimeDialogVisible,
            //   child: Positioned(
            //     bottom: resHeight(124),
            //     right: resWidth(16),
            //     left: resWidth(16),
            //     // top: 400,
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            //       child: Container(
            //         width: Get.width,
            //         padding: EdgeInsets.symmetric(horizontal: resWidth(30)),
            //         // margin: EdgeInsets.symmetric(horizontal: resWidth(16)),
            //         decoration: const BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(32)),
            //           color: Colors.white,
            //         ),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             resHeightBox(30),
            //             Text(
            //               "Hiding Time!",
            //               style: darkHeadingStyle32,
            //               textAlign: TextAlign.center,
            //             ),
            //             resHeightBox(16),
            //             Padding(
            //               padding:
            //                   EdgeInsets.symmetric(horizontal: resWidth(16)),
            //               child: Text("Wait until everyone has hidden",
            //                   style: greyDarkStyle16w400,
            //                   textAlign: TextAlign.center),
            //             ),
            //             resHeightBox(32),
            //
            //             Obx(() {
            //               print("into obx");
            //               return CircularStepProgressIndicator(
            //                 totalSteps: (selectedMinute * 60) == 0
            //                     ? 60
            //                     : selectedMinute * 60,
            //                 currentStep: _controller.timeValue.value,
            //                 stepSize: 1,
            //                 selectedColor: primaryColor2,
            //                 unselectedColor: Colors.white,
            //                 padding: 0,
            //                 width: 260,
            //                 height: 260,
            //                 selectedStepSize: 15,
            //                 roundedCap: (_, __) => true,
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     resHeightBox(25),
            //
            //                     SvgPicture.asset(
            //                         "assets/images/person_running.svg"),
            //                     resHeightBox(10),
            //                     Text(
            //                       "Remaining time",
            //                       style: greyMiniStyle14Color40,
            //                     ),
            //                     resHeightBox(10),
            //                     // Obx(() => ),
            //                     Text(
            //                       _controller.timeValue.value <= 60
            //                           ? '00:${_controller.timeValue.value}'
            //                           : '${((_controller.timeValue.value) / 60).toInt()}:${(_controller.timeValue.value) % 60}',
            //                       style: greyDarkHeading64w600,
            //                     ),
            //                     resHeightBox(30),
            //                   ],
            //                 ),
            //                 // gradientColor: LinearGradient(
            //                 //   colors: [primaryColor1,primaryColor2],
            //                 // ),
            //               );
            //             } ),
            //
            //             resHeightBox(32),
            //
            //             // CustomButton(onPressed: (){
            //             //   print('hi');
            //             //   // Get.back();
            //             //   _controller.timerSetup(10);
            //             // }, text: "Set and GO",),
            //             resHeightBox(26),
            //
            //             OutlineGradientButton(
            //               backgroundColor: Colors.white,
            //               gradient: const LinearGradient(
            //                 colors: [primaryColor1, primaryColor2],
            //                 // begin: Alignment.topCenter,
            //                 // end: Alignment.bottomCenter,
            //               ),
            //               strokeWidth: 2,
            //               radius: const Radius.circular(16),
            //               onTap: () async {
            //                 setState(() {
            //                   hidingTimeDialogVisible = false;
            //                 });
            //                 // Get.back();
            //               },
            //               child: SizedBox(
            //                 height: resHeight(43),
            //                 width: resWidth(283),
            //                 child: Center(
            //                     child: gradientNormalStyle("Cancel Timer",
            //                         fontSize: 20, fontWeight: FontWeight.w600)),
            //               ),
            //             ),
            //             resHeightBox(40),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  setTimer(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                    // img==null?SizedBox():SvgPicture.asset("assets/images/Frame44.svg"),
                    // SvgPicture.asset("assets/images/verified.svg"),
                    Text(
                      "Set Timer",
                      style: darkHeadingStyle32,
                      textAlign: TextAlign.center,
                    ),
                    resHeightBox(16),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: resWidth(16)),
                      child: Text(
                          "After the time is end the game\nwill begin!",
                          style: greyDarkStyle16w400,
                          textAlign: TextAlign.center),
                    ),
                    resHeightBox(32),

                    true
                        ? Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            // color: Colors.yellow,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: -12.0,
                                  blurRadius: 12.0,
                                ),
                              ]),
                          constraints: BoxConstraints(
                            // Set height to one line, otherwise the whole vertical space is occupied.
                            maxHeight: resHeight(180),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            overAndUnderCenterOpacity: 0.5,
                            diameterRatio: 2,
                            itemExtent: resWidth(90),
                            childDelegate:
                            ListWheelChildLoopingListDelegate(
                              children: List<Widget>.generate(
                                60,
                                    (index) => MinutesText(index: index),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: resWidth(60),
                          top: resHeight(80),
                          child: Text(
                            "m",
                            style: greyDarkStyle24w600,
                          ),
                        )
                      ],
                    )
                        : SizedBox(
                      height: resHeight(264),
                      child: ListWheelScrollView(
                        // diameterRatio: ,
                        // useMagnifier: true,
                          magnification: 1.5,
                          itemExtent: resHeight(85),
                          children: []),
                    ),

                    // Container(
                    //   decoration:  BoxDecoration(
                    //     gradient: const LinearGradient(
                    //       colors: [
                    //         primaryColor1,
                    //         primaryColor2,
                    //       ],
                    //     ) ,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   margin: const EdgeInsets.only(bottom: 0),
                    //   height: resHeight(64),
                    //   width: resWidth(283),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(1.5),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(12),
                    //         // border: selected ? Border.all(color: whiteColorLight) : null
                    //       ),
                    //       padding:  EdgeInsets.only(left: resWidth(12), right: resWidth(22)),
                    //       child: Center(
                    //         child: TextFormField(
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 24,
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //           decoration: const InputDecoration(
                    //             border: InputBorder.none,
                    //
                    //           ),
                    //           keyboardType: TextInputType.number,
                    //           cursorColor: Colors.black,
                    //
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    resHeightBox(32),

                    CustomButton(
                      onPressed: () async {
                        // Get.back();
                        await FirebaseFirestore.instance.collection('lobbies').doc(widget.lobbyId.toString()).update({'hidingTime':selectedMinute,'isHidingTime':true});

                        _controller.timerSetup(selectedMinute,widget.lobbyId,widget.lobbyModel);
                        await showHidingTime(context);
                        Get.back();

                        // setState(() {
                        //   hidingTimeDialogVisible = true;
                        // });

                        // Get.back();
                      },
                      text: "Set and GO",
                    ),
                    resHeightBox(26),

                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: gradientNormalStyle("Cancel",
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    resHeightBox(40),
                  ],
                ),
              );
            },
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
          backgroundColor: Colors.white,
        ));
  }

  showHidingTime(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
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
                    Text(
                      "Hiding Time!",
                      style: darkHeadingStyle32,
                      textAlign: TextAlign.center,
                    ),
                    resHeightBox(16),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: resWidth(16)),
                      child: Text("Wait until everyone has hidden",
                          style: greyDarkStyle16w400,
                          textAlign: TextAlign.center),
                    ),
                    resHeightBox(32),
                    Obx(() {
                      print("into obx");
                      return SizedBox(
                        height: resHeight(264),
                        width: resWidth(264),
                        child: CircularStepProgressIndicator(
                          totalSteps: (selectedMinute * 60) == 0
                              ? 60
                              : selectedMinute * 60,
                          currentStep: _controller.timeValue.value,
                          stepSize: 1,

                          gradientColor: const LinearGradient(
                            colors: [
                              primaryColor1,
                              primaryColor2,
                            ],

                          ),

                          unselectedColor: Colors.white,
                          padding: 0,
                          width: 260,
                          height: 260,
                          selectedStepSize: 20,
                          roundedCap: (_, __) => true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              resHeightBox(25),

                              SvgPicture.asset(
                                  "assets/images/person_running.svg"),
                              resHeightBox(10),
                              Text(
                                "Remaining time",
                                style: greyMiniStyle14Color40,
                              ),
                              resHeightBox(10),
                              // Obx(() => ),
                              Text(
                                _controller.timeValue.value <= 60
                                    ? '00:${_controller.timeValue.value}'
                                    : '${((_controller.timeValue.value) / 60).toInt()}:${(_controller.timeValue.value) % 60}',
                                style: greyDarkHeading64w600,
                              ),
                              resHeightBox(30),
                            ],
                          ),
                          // gradientColor: LinearGradient(
                          //   colors: [primaryColor1,primaryColor2],
                          // ),
                        ),
                      );
                    }),
                    resHeightBox(32),
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
                        await FirebaseFirestore.instance.collection('lobbies').doc(widget.lobbyId.toString()).update({'isHidingTime':false});

                        _controller.stopWatchTimer.dispose();
                        Get.back();
                      },
                      child: SizedBox(
                        height: resHeight(43),
                        width: resWidth(283),
                        child: Center(
                            child: gradientNormalStyle("Cancel Timer",
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    resHeightBox(40),
                  ],
                ),
              );
            },
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
          backgroundColor: Colors.white,
        ));
  }
}

int selectedMinute = 0;
double lastMinuteVisibility = 0;

class MinutesText extends StatefulWidget {
  const MinutesText({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<MinutesText> createState() => _MinutesTextState();
}

class _MinutesTextState extends State<MinutesText> {
  int? visibility;

  BeginGameController beginGameController = Get.find();

  @override
  Widget build(BuildContext context) {
    // print(object)

    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;
        visibility = visiblePercentage.toInt();
        debugPrint('Widget ${info.key} is ${visiblePercentage}% visible');
        if (visiblePercentage > lastMinuteVisibility) {
          selectedMinute = widget.index;
          // for (var element in beginGameController.visibilities) {element.value = false;}
          // beginGameController.visibilities[widget.index].value = true;


          print("new selected minute is: $selectedMinute");
        }
      },
      key: Key((widget.index + 1).toString()),
      child: minutesText(widget.index + 1),
    );
  }

  Widget minutesText(int no) {
    print("into minutes text, index: ${widget.index} visibility: $visibility");
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          no < 10 ? "0$no" : no.toString(),
          style: greyDarkHeading64w600,
        ),
        // resWidthBox(4),
        // (visibility ?? 94) > 95
        //     ? Padding(
        //         padding: EdgeInsets.only(left: resWidth(4)),
        //         child: Text(
        //           "m",
        //           style: greyDarkStyle24w600,
        //         ),
        //       )
        //     : SizedBox()
      ],
    );
  }
}
