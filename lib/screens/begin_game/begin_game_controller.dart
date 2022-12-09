import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../model/lobbymodel.dart';
import '../../non_shrink_mode/no_shrink_mode.dart';
import '../../shrink_mode/shrink_mode.dart';
import '../creategame/creategamesettingcontroller.dart';

class BeginGameController extends GetxController{
  var timeValue=0.obs;
  double scaleFactor = 1400;

  bool confirmed = false;
  bool hidingTimeDialogVisible = false;
  double maxscale = 1;
  bool timerStarted=false;
  double minscale=1;
  Position? userLocation;

  // List<Rx<bool>> visibilities = [];

  @override
  Future<void> onInit() async {
userLocation=await _getCurrentPosition();
print(userLocation!.toJson().toString());
if(userLocation==null){
}
else {
  GoogleMapController con=await controller.future;
  con.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    target: LatLng(userLocation!.latitude, userLocation!.longitude),
    zoom: 14,
  )));

}
    // timerSetup();

    // visibilities = List<Rx<bool>>.generate(
    //   60,
    //       (index) => false.obs,
    // );

    // TODO: implement onInit
    super.onInit();
  }
  Completer<GoogleMapController> controller = Completer();
  CameraPosition kGooglePlex=const CameraPosition(
    target: LatLng(31.4933248, 74.3768064),
    zoom: 14,
  ) ;

 late var  stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown
  );

  timerSetup(int minutes,int lobbyId,LobbyModel lobbyData){

    // print("minutes recieved: $minutes");
stopWatchTimer=StopWatchTimer(
    mode: StopWatchMode.countDown
);
    stopWatchTimer.onResetTimer();
    stopWatchTimer.setPresetSecondTime((60*minutes), add: false);

    stopWatchTimer.secondTime.listen((value) async {

      timeValue.value = value;
if(value==60*minutes-1){timerStarted=true;}
      if(value==0&&timerStarted){
        // print("time is up");
        // print("lobby id: $lobbyId");

        await FirebaseFirestore.instance.collection("lobbies").doc(lobbyId.toString()).update({
          "gameStarted":true

        });
        CreateGameSettingController controller =
        Get.find();
        if (controller.gameController.selected.value ==
            1) {
          print(
              controller.gameController.selected.value);
          Get.to(() =>
              NonShrinkMode(lobbyModel: lobbyData,));
        } else {
          print(
              controller.gameController.selected.value);
          Get.to(() =>
              NonShrinkMode(lobbyModel: lobbyData,));
        }
      }
      print(value);
    });
    stopWatchTimer.onStartTimer();
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('','Location services are disabled. Please enable the services', backgroundColor: Colors.white);

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       Get.snackbar('','Location permissions are denied', backgroundColor: Colors.white);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('','Location permissions are permanently denied, we cannot request permissions.', backgroundColor: Colors.white);
       return false;
    }
    return true;
  }
  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    print('////////////////////////////////');
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
