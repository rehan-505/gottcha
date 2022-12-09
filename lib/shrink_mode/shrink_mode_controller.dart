// import 'dart:async';
//
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
//
// class ShrinkModeController extends GetxController{
//   var timeValue=0.obs;
//
//   void onInit() {
//
//     // TODO: implement onInit
//     super.onInit();
//   }
//   Completer<GoogleMapController> controller = Completer();
//   final CameraPosition kGooglePlex = const CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14,
//   );
//   final stopWatchTimer = StopWatchTimer(
//       mode: StopWatchMode.countDown
//   );
//
//   timerSetup(){
//     stopWatchTimer.setPresetSecondTime((60*10));
//     stopWatchTimer.secondTime.listen((value) {
//       timeValue.value = value;
//       // print(value);
//     });
//     stopWatchTimer.onStartTimer();
//   }
//
// }