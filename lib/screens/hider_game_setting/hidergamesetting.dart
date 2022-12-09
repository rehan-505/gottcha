import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/non_shrink_mode/no_shrink_mode.dart';
import 'package:gottcha/screens/hider_game_setting/hidergamesetting.dart';
import 'package:gottcha/screens/hider_game_setting/hidergamesettingcontroller.dart';
import 'package:gottcha/shrink_mode/shrink_mode.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/customappbar.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';

class HiderGameSetting extends StatefulWidget {
  final LobbyModel lobbyModel;
  const HiderGameSetting({Key? key, required this.lobbyModel}) : super(key: key);

  @override
  State<HiderGameSetting> createState() => _HiderGameSettingState();
}

class _HiderGameSettingState extends State<HiderGameSetting> {

 // @override
 //  initState(){
 //   Future.delayed(const Duration(seconds: 5), () {
 //     Get.to(ShrinkMode(hiderPage: true,));
 //   });
 // }

  final HiderGameSettingController _controller =
  Get.put(HiderGameSettingController());

  bool forwarded = false;
  bool markerSet = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('lobbies').doc(widget.lobbyModel.lobbyId.toString()).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot) {


        if (snapshot.connectionState!=ConnectionState.waiting && snapshot.hasData){
          Future.delayed(Duration(seconds: 5),(){
            _controller.updateMyLocation();
          });
          LobbyModel  lobbyModel = LobbyModel.fromJson(snapshot.data!.data()!);
          _controller.data=lobbyModel;
         if((!_controller.setMap)&&_controller.data!.mapZoom!=null){
           print('zoooooooooooom');
_controller.moveMap();
           _controller.setMap=true;

         }

              _controller.setMarkers();

            if(lobbyModel.gameStarted){
            if(lobbyModel.modeType == 'nonshrink' && !forwarded){
              forwarded = true;
              print("time to move");
              print("into hider, lat: ${lobbyModel.mapLat}, lat: ${lobbyModel.mapLng}, zoom: ${lobbyModel.mapZoom}");
              _controller.streamSubscription?.cancel();
              _controller.cancelStream = true;
              print('canel stream');

              // Future.delayed(Duration(seconds: 5),(){
              //   print('delayeddddddd');
              //   NonShrinkMode(lobbyModel: lobbyModel, hiderPage: true,);
              // });

              Future.delayed(Duration(
                microseconds: 100, ),
                      (){
                    Get.off(()=>NonShrinkMode(lobbyModel: lobbyModel, hiderPage: true,));
                  }

              );



              }
            else{
              Future.delayed(Duration(
                microseconds: 100, ),
                      (){
                    Get.off(()=>NonShrinkMode(lobbyModel: lobbyModel, hiderPage: true,));
                  }

              );
              // Get.off( NonShrinkMode(lobbyModel: lobbyModel, hiderPage: true,));
              // Future.delayed(const Duration(seconds: 1),
              //         () => );
              // Get.off( NonShrinkMode(lobbyModel: lobbyModel, hiderPage: true,));
              // Future.delayed(const Duration(seconds: 5),
              //         () => Get.to( ShrinkMode()));



            }
            }
          if(lobbyModel.isHidingTime!&&lobbyModel.hidingTime!=0&&!_controller.setTimer){
            _controller.timerSetup(lobbyModel.hidingTime!,context);

            _controller.setTimer=true;


          }
          return Container(
            color: backgroundColor,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  bottom: 0,
                  child: Obx(
                    ()=> GoogleMap(
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(_controller.markers),
                      initialCameraPosition: _controller.kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.mapController = controller;
                        if(!_controller.controller.isCompleted) {
                            _controller.controller.complete(controller);
                          }
                        },
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 0,
                  left: 0,
                  child: SvgPicture.asset(
                    'assets/images/hidergamesetting.svg',
                    width: Get.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 100,

                  child: lobbyModel.isHidingTime!?Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(25)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Center(
                        child: Text(
                          'Run & Hide!',
                          style: whiteNormalStyle16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ):Container(),
                ),
                Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: CustomAppBar(
                              isActionName: false,
                              isLeadingRec: true,
                              leading: 'assets/images/Arrow.svg',
                              action: 'assets/images/info.svg',
                              title: lobbyModel.isHidingTime!?Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text('Hiding Time',style: blackNormalStyle16,),
                                    Obx(()=> Text(_controller.timeValue.value<=60?'00:${_controller.timeValue.value}':'${((_controller.timeValue.value)/60).toInt()}:${(_controller.timeValue.value)%60}',style: blackBoldStyle16,))
                                  ],
                                ),
                              ):Container(),
                              actionFunction: () async {
                                await showInfoMenu(context);
                              },
                              leadingFunction: () async {
                                Get.back();
                              },
                            ),
                          ),
                          lobbyModel.isHidingTime!?Container():const GradientProgressIndicator(
                            radius: 35,
                            strokeWidth: 7,
                            gradientStops: [0.3, 0.6, 0.7, 1],
                            duration: 0,
                            gradientColors: [
                              primaryColor1,
                              primaryColor2,
                              primaryColor1_Opacity10,
                              primaryColor2_Opacity10,
                            ],
                            child: SizedBox(
                              height: 100,
                            ),
                          ),
                          lobbyModel.isHidingTime!?Container():Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(25)),
                            padding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Text(
                              waitUntil,
                              style: whiteNormalStyle16,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          );
        }

       return Container(
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: 0,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _controller.kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.controller.complete(controller);
                  },
                ),
              ),
              Positioned.fill(
                top: 0,
                left: 0,
                child: SvgPicture.asset(
                  'assets/images/hidergamesetting.svg',
                  width: Get.width,
                  fit: BoxFit.fill,
                ),
              ),

              Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CustomAppBar(
                            isActionName: false,
                            isLeadingRec: true,
                            leading: 'assets/images/Arrow.svg',
                            action: 'assets/images/info.svg',
                            title: Container(),
                            actionFunction: () async {
                              await showInfoMenu(context);
                            },
                            leadingFunction: () async {
                              Get.back();
                            },
                          ),
                        ),
                        const GradientProgressIndicator(
                          radius: 35,
                          strokeWidth: 7,
                          gradientStops: [0.3, 0.6, 0.7, 1],
                          gradientColors: [
                            primaryColor1,
                            primaryColor2,
                            primaryColor1_Opacity10,
                            primaryColor2_Opacity10,
                          ],
                          child: SizedBox(
                            height: 100,
                          ),
                        ),
SizedBox(height:100)
                      ],
                    ),
                  ))
            ],
          ),
        );
      }
    );
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



  Future<void> futureFunction() async{

  }

}
