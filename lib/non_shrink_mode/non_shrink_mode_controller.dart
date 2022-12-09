import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofence_service/geofence_service.dart' as gs;
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:gottcha/non_shrink_mode/no_shrink_mode.dart';
import 'package:gottcha/screens/home/home.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/location_helper.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:math';
import '../utils/NoShrinkModeGlobals.dart';
import '../utils/remote_config.dart';

class NonShrinkModeController extends GetxController {
  var timeValue = 0.obs;
  var timeValueUnlimited= 0.obs;
  Set<Marker> markers = {};

  RxSet<Circle> circles = <Circle>{}.obs;

  Rx<bool> hidersVisible = false.obs;
  RemoteConfigService? remoteConfigService;

  Rx<bool> circleShrinkingText = false.obs;
  Rx<String> circleShrinkSecondsLeftText = "".obs;
  int circleShrinkSecondsLeftInt = 60;

  StopWatchTimer circleShrinkingTimer =
      StopWatchTimer(mode: StopWatchMode.countDown);

  int circleShrinkingLimit = 0;
  int currentCircleShrinkingShownCount = 0;

  double currentMapValueShown = 1;

  ///for showing shrinking text
  setShrinkingLimits() {
    if (globalTimeMap[latestLobbyModel!.time] == 999 ||
        globalTimeMap[latestLobbyModel!.time] == null) {
      circleShrinkingLimit = 12;
    } else {
      circleShrinkingLimit =
          (((globalTimeMap[latestLobbyModel!.time])! / 10) - 1).toInt();
    }
  }

  StreamSubscription? localStream;

  _startUpdatingText(int minutes) {
    circleShrinkSecondsLeftText.value = "";

    print("into updating text");
    print("minutes recieved : $minutes");

    int totalSeconds = minutes * 60;

    circleShrinkSecondsLeftInt = 60;

    circleShrinkingTimer.setPresetSecondTime(totalSeconds);
    circleShrinkingTimer.onStartTimer();
    localStream = circleShrinkingTimer.secondTime.listen((seconds) {
      print("localstream seconds: $seconds");
      print("local stream minutes: ${seconds ~/ 60} ");

      if (seconds == 0 || seconds == totalSeconds) {
        print("0 or 1800 seconds so returning");
        return;
      }

      if (((seconds / 60) % remoteConfigService!.shrink_after) == 1) {

        ///setting circleSet
        circles.clear();
        if((currentCircleShrinkingShownCount+1) <= circleShrinkingLimit){
          circles.add(Circle(
              circleId: CircleId(
                  "innerCircle${currentCircleShrinkingShownCount + 1}"),
              radius: getInnerArea(),
              center:
                  LatLng(latestLobbyModel!.mapLat!, latestLobbyModel!.mapLng!),
              strokeWidth: 2,
              strokeColor: primaryColor1));
        }

        currentCircleShrinkingShownCount = currentCircleShrinkingShownCount + 1;
        circleShrinkSecondsLeftInt = 60;
      }

      if (((((seconds ~/ 60) + 1) % remoteConfigService!.shrink_after) == 1)) {
        if ((currentCircleShrinkingShownCount <= circleShrinkingLimit)) {
          circleShrinkSecondsLeftInt = circleShrinkSecondsLeftInt - 1;
          circleShrinkSecondsLeftText.value = "00:$circleShrinkSecondsLeftInt";

          if(circleShrinkSecondsLeftInt==1){
            circles.clear();
          }

        } else {
          print("limit exceeded");
        }
      }



    });
  }


  StopWatchTimer innerCircleTimer =
  StopWatchTimer(mode: StopWatchMode.countDown);


  StreamSubscription? innerCircleStream;


  _startUpdatingInnerCircles(int minutes) {

    int totalSeconds = minutes * 60;

    circleShrinkingTimer.setPresetSecondTime(totalSeconds);
    circleShrinkingTimer.onStartTimer();

    innerCircleStream = circleShrinkingTimer.secondTime.listen((seconds) {
      print("localstream seconds: $seconds");
      print("local stream minutes: ${seconds ~/ 60} ");

      if (seconds == 0 || seconds == totalSeconds) {
        print("0 or 1800 seconds so returning");
        return;
      }

      if (((seconds / 60) % remoteConfigService!.shrink_after) == 1) {
        // circles = {
        //   Circle(circleId: const CircleId("center"),center: LatLng(latestLobbyModel!.mapLat!, latestLobbyModel!.mapLng!), radius: getInnerArea(part))
        // };
      }

      if (((((seconds ~/ 60) + 1) % remoteConfigService!.shrink_after) == 1)) {
        if ((currentCircleShrinkingShownCount <= circleShrinkingLimit)) {
          circleShrinkSecondsLeftInt = circleShrinkSecondsLeftInt - 1;
          circleShrinkSecondsLeftText.value = "00:$circleShrinkSecondsLeftInt";
        } else {
          print("limit exceeded");
        }
      }
    });
  }

  final List<double> thirtyMinutesShrinkValues = [0.55,0.15];
  final List<double> sixtyMinutesShrinkValues = [0.8,0.55,0.4,0.3,0.15];
  final List<double> ninetyMinutesShrinkValues = [0.8,0.65,0.55,0.45,0.35,0.3,0.25,0.15];
  final List<double> unlimitedMinutesShrinkValues = [0.8,0.65,0.55,0.45,0.35,0.25,0.15,0.1,0.05,0.03,0.02,0.01];


  ///part value will be less than 1
  double getInnerArea(){

    if(globalTimeMap[latestLobbyModel!.time]==999){
      return originalTotalArea*unlimitedMinutesShrinkValues[currentCircleShrinkingShownCount];
    }
    else if(globalTimeMap[latestLobbyModel!.time]==90){
      return originalTotalArea*ninetyMinutesShrinkValues[currentCircleShrinkingShownCount];
    }
    else if(globalTimeMap[latestLobbyModel!.time]==60){
      return originalTotalArea*sixtyMinutesShrinkValues[currentCircleShrinkingShownCount];
    }
    else {
      return originalTotalArea*(thirtyMinutesShrinkValues[currentCircleShrinkingShownCount]);
    }

  }


  ///insert geofence radius in list for all upcoming circles for shrink mode
  void insertGeoFenceRadiuses(List<double> list){
    geofenceRadiusList.clear();
    geofenceRadiusList.add(GeofenceRadius(id: '1', length: originalTotalArea));
    for (var element in list) {
      geofenceRadiusList.add(GeofenceRadius(id: element.toString(), length: originalTotalArea*element));
    }
  }

  manageCircleShrinksInText() async {
    _startUpdatingText(
        ((globalTimeMap[latestLobbyModel!.time!]!.toInt() == 999) ||
                (latestLobbyModel!.time! == "unlimited"))
            ? 120
            : globalTimeMap[latestLobbyModel!.time!]!.toInt());
  }

  Rx<bool> showCircleIsShrinking = false.obs;

  StreamSubscription<Position>? locationSubscription;
  StreamSubscription? timerSubscription;
  StreamSubscription? unlimitedtimerSubscription;

  LobbyModel? latestLobbyModel;
  bool? isHider;

  Completer<GoogleMapController> controller = Completer();
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countDown);
  final stopWatchTimerUnlimted = StopWatchTimer(mode: StopWatchMode.countUp);

  UserModel? myUser;

  int totalSeconds = 0;
  Timer? timer;

  timerSetup(int minutes) async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalSeconds = totalSeconds + 1;
    });

    if (remoteConfigService!.debug) {
      minutes = 1;
    }


    if (minutes == 999) {
print("unlimited time check");
      unlimitedtimerSubscription = stopWatchTimerUnlimted.secondTime.listen((value) async {

        // totalSeconds = totalSeconds + 1;
        timeValueUnlimited.value = value;
        print("utlimted"+timeValueUnlimited.value.toString());

        // print(value);
      });
      stopWatchTimerUnlimted.onStartTimer();

    }

    else{
      if (remoteConfigService!.debug) {
        minutes = 1;
      }

      ///Comment These Three Lines
      // minutes = 1;
      // print("hi");
      // stopWatchTimer.onResetTimer();
      stopWatchTimer.setPresetSecondTime((60 * minutes).toInt());
      timerSubscription = stopWatchTimer.secondTime.listen((value) async {
        // totalSeconds = totalSeconds + 1;
        timeValue.value = value;
        // print(timeValue.value);

        if (latestLobbyModel?.gameFinished ?? false) {
          stopWatchTimer.onStopTimer();
          return;
        }

        if (value == 1) {
          print("Timer Finished");

          await FirebaseFirestore.instance
              .collection('lobbies')
              .doc(latestLobbyModel!.lobbyId.toString())
              .update({'gameFinished': true});
          stopWatchTimer.onStopTimer();
        }
        // print(value);
      });
      stopWatchTimer.onStartTimer();
    }
  }

  Location location = Location();

  int counter = 0;

  late List<Geofence> geofenceList;
  List<GeofenceRadius> geofenceRadiusList = [];

  Future<void> updateMyLocation() async {
    if ((myUser?.eliminated ?? false) && locationSubscription != null) {
      await locationSubscription?.cancel();
      locationSubscription = null;
      return;
    }


    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Req Failed", "Location Service Not Enabled",
            backgroundColor: Colors.white);
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar("Req Failed", "Location Permission Not Granted",
            backgroundColor: Colors.white);
        return;
      }
    }

    Position? locationData;

    bool geoFenceSetupDone = false;

    locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      distanceFilter: 1,
      // timeLimit: Duration(seconds: 20)
    )).listen(
        (location) async {
          // print(latestLobbyModel?.lobbyId);
          // print('locationUpdated $counter');
          counter = counter + 1;

          locationData = location;

          ///

          print("updated distance ${getDistance(LatLng(latestLobbyModel!.mapLat!, latestLobbyModel!.mapLng!), LatLng(locationData!.latitude, locationData!.longitude))}");

          if (checkIsHider()) {
            // int i = latestLobbyModel!.hiders!.indexWhere((element) => element.email==FirebaseAuth.instance.currentUser!.email);

            for (var element in latestLobbyModel!.hiders!) {
              if (element.email == FirebaseAuth.instance.currentUser!.email) {
                element.latitude = location.latitude;
                element.longitude = location.longitude;
                break;
              }
            }
          } else {
            for (var element in latestLobbyModel!.searchers!) {
              if (element.email == FirebaseAuth.instance.currentUser!.email) {
                element.latitude = location.latitude;
                element.longitude = location.longitude;
                break;
              }
            }
          }

          ///Updating Location
          if (checkIsHider()) {
            await FirebaseFirestore.instance
                .collection('lobbies')
                .doc(latestLobbyModel!.lobbyId!.toString())
                .update({
              'hiders':
                  latestLobbyModel!.hiders!.map((i) => i.toJson()).toList()
            });
          } else {
            await FirebaseFirestore.instance
                .collection('lobbies')
                .doc(latestLobbyModel!.lobbyId!.toString())
                .update({
              'searchers':
                  latestLobbyModel!.searchers!.map((i) => i.toJson()).toList()
            });
          }

          if ( (!geoFenceSetupDone)) {

            print('geo fence');
            final geofenceService = gs.GeofenceService.instance.setup(
              // accuracy:1 ,
              // interval: 1000,
              // loiteringDelayMs: 60000,
              // statusChangeDelayMs: 10000,
            );


            // Create a [Geofence] list.
            geofenceList = <Geofence>[
              gs.Geofence(
                id: 'place_1',
                latitude: latestLobbyModel!.mapLat!,
                longitude: latestLobbyModel!.mapLng!,
                radius: geofenceRadiusList,
              ),
            ];

            await geofenceService.start(geofenceList);
            for (var element in geofenceList) {
              print("radius length");
              print(element.radius.first.length);
            }
            geofenceService.addGeofenceStatusChangeListener(
                    (geofence, geofenceRadius,gs.GeofenceStatus geofenceStatus, locati){
                  print("geofence status changed called");
                  print(geofenceStatus == gs.GeofenceStatus.ENTER);
                  print(geofenceRadius.length);
                  print(geofenceRadius.data);
                  print(geofence.data);
                  print(geofence.radius.length.toString());
                  return _onGeofenceStatusChanged(
                      geofence, geofenceRadius, geofenceStatus, locati);
                }
            );
            geoFenceSetupDone = true;
          }
          else{
            print("Geofence setup already done, not doing again.");
          }
        },
        cancelOnError: false,
        onError: (v) {
          print("error in location update");
          print(v);
        });

    /// Create a [GeofenceService] instance and set options.


  }

  late GoogleMapController? googleMapController;

  final double zoomValueForOneMeterArea = 0.0014285714;

  double getZoomByArea(double area) {
    print("area: $area");
    double zoom = (log(11468800 / area) / log(2)) + 1;
    print("zoom new value: $zoom");

    return zoom;
  }

  StopWatchTimer zoomTimer = StopWatchTimer(mode: StopWatchMode.countDown);

  late double originalTotalArea;

  Future<void> setZoomLevels() async {
    ///Unlimited Time

    if (((globalTimeMap[latestLobbyModel!.time!] ?? 999) == 999) ||
        latestLobbyModel!.time! == "unlimited") {
      await _unlimitedTimeZoneShrinking();
      return;
    }

    ///30 minutes
    if ((globalTimeMap[latestLobbyModel!.time!] ?? 999) == 30) {
      await thirtyMinsZoneShrinking();
      return;
    }

    ///60 minutes
    if ((globalTimeMap[latestLobbyModel!.time!] ?? 999) == 60) {
      await sixtyMinsZoneShrinking();
      return;
    }

    ///90 minutes
    if ((globalTimeMap[latestLobbyModel!.time!] ?? 999) == 90) {
      await ninetyMinsZoneShrinking();
      return;
    }
  }

  StreamSubscription? zoomTimerListener;

  Future<void> _unlimitedTimeZoneShrinking() async {

    insertGeoFenceRadiuses(unlimitedMinutesShrinkValues);


    zoomTimer.setPresetMinuteTime(120);
    zoomTimer.onStartTimer();

    // Get.snackbar("Update", "Zone Shrinking");
    zoomTimerListener = zoomTimer.minuteTime.listen((value) async {
      ///After 1st 10 minutes
      if (value == (119 - remoteConfigService!.shrink_after)) {
        shrinkCircleInPhases(nextMapValueShown: 0.80);

      } else if (value == (119 - remoteConfigService!.shrink_after*2)) {
        shrinkCircleInPhases(nextMapValueShown: 0.65);

      } else if (value == (119 - remoteConfigService!.shrink_after*3)) {
        shrinkCircleInPhases(nextMapValueShown: 0.55);

      } else if (value == (119 - remoteConfigService!.shrink_after*4)) {
        shrinkCircleInPhases(nextMapValueShown: 0.45);

      } else if (value == (119 - remoteConfigService!.shrink_after*5)) {
        shrinkCircleInPhases(nextMapValueShown: 0.35);

      } else if (value == (119 - remoteConfigService!.shrink_after*6)) {
        shrinkCircleInPhases(nextMapValueShown: 0.25);
      } else if (value == (119 - remoteConfigService!.shrink_after*7)) {
        shrinkCircleInPhases(nextMapValueShown: 0.15);

      } else if (value == (119 - remoteConfigService!.shrink_after*8)) {
        shrinkCircleInPhases(nextMapValueShown: 0.1);

      } else if (value == (119 - remoteConfigService!.shrink_after*9)) {
        shrinkCircleInPhases(nextMapValueShown: 0.05);

      } else if (value == (119 - remoteConfigService!.shrink_after*10)) {
        shrinkCircleInPhases(nextMapValueShown: 0.03);

      } else if (value == (119 - remoteConfigService!.shrink_after*11)) {
        shrinkCircleInPhases(nextMapValueShown: 0.02);

      }

      ///After 119 minutes
      else if (value == (119 - ((remoteConfigService!.shrink_after*12) - 2))) {
        shrinkCircleInPhases(nextMapValueShown: 0.01);


        zoomTimer.onStopTimer();
      }
    });
  }

  Future<void> thirtyMinsZoneShrinking() async {

    insertGeoFenceRadiuses(thirtyMinutesShrinkValues);

    zoomTimer.setPresetMinuteTime(30);
    zoomTimer.onStartTimer();

    ///Zoom Timer on minute starts from 0,30,   29
    ///so it starts from 29 actually

    // Get.snackbar("Update", "Zone Shrinking 30 mins");

    ///Uncomment it Just For Testing
    // zoomTimer.minuteTime.listen((value) async{
    //   // print("zoom minute value: $value");
    //   // print("zoom minutes passed: ${30 - value}");
    //   if (value == (28)) {
    //
    //     await shrinkCircleInPhases(0.55);
    //
    //   } else if (value == (27)) {
    //
    //     await shrinkCircleInPhases(0.15);
    //
    //   }
    //
    // });

    ///actual timer, uncomment it

    zoomTimer.minuteTime.listen((value) async {
      if (value == (29 - remoteConfigService!.shrink_after*1)) {
        await shrinkCircleInPhases(nextMapValueShown: 0.55);

      } else if (value == (29 - remoteConfigService!.shrink_after*2)) {
        await shrinkCircleInPhases(nextMapValueShown: 0.15);

        zoomTimer.onStopTimer();
      }
    });

    return;
  }

  Future<void> sixtyMinsZoneShrinking() async {
    insertGeoFenceRadiuses(sixtyMinutesShrinkValues);

    zoomTimer.setPresetMinuteTime(60);
    zoomTimer.onStartTimer();

    // Get.snackbar("Update", "Zone Shrinking 30 mins");
    zoomTimer.minuteTime.listen((value) async {
      if (value == (59 - remoteConfigService!.shrink_after*1)) {
        shrinkCircleInPhases(nextMapValueShown: 0.80);

      } else if (value == (59 - remoteConfigService!.shrink_after*2)) {
        shrinkCircleInPhases(nextMapValueShown: 0.55);

      } else if (value == (59 - remoteConfigService!.shrink_after*3)) {
        shrinkCircleInPhases(nextMapValueShown: 0.40);

      } else if (value == (59 - remoteConfigService!.shrink_after*4)) {
        shrinkCircleInPhases(nextMapValueShown: 0.30);
      } else if (value == (59 - remoteConfigService!.shrink_after*5)) {
        shrinkCircleInPhases(nextMapValueShown: 0.15);

        zoomTimer.onStopTimer();
      }
    });
    return;
  }

  Future<void> ninetyMinsZoneShrinking() async {
    insertGeoFenceRadiuses(ninetyMinutesShrinkValues);

    zoomTimer.setPresetMinuteTime(90);
    zoomTimer.onStartTimer();

    // Get.snackbar("Update", "Zone Shrinking 30 mins");
    zoomTimer.minuteTime.listen((value) async {
      if (value == (89 - remoteConfigService!.shrink_after*1)) {
        shrinkCircleInPhases(nextMapValueShown: 0.80);

      } else if (value == (89 - remoteConfigService!.shrink_after*2)) {
        shrinkCircleInPhases(nextMapValueShown: 0.65);

      } else if (value == (89 - remoteConfigService!.shrink_after*3)) {
        shrinkCircleInPhases(nextMapValueShown: 0.55);

      } else if (value == (89 - remoteConfigService!.shrink_after*4)) {
        shrinkCircleInPhases(nextMapValueShown: 0.45);

      } else if (value == (89 - remoteConfigService!.shrink_after*5)) {
        shrinkCircleInPhases(nextMapValueShown: 0.35);

      } else if (value == (89 - remoteConfigService!.shrink_after*6)) {
        shrinkCircleInPhases(nextMapValueShown: 0.30);

      } else if (value == (89 - remoteConfigService!.shrink_after*7)) {
        shrinkCircleInPhases(nextMapValueShown: 0.25);

      } else if (value == (89 - remoteConfigService!.shrink_after*8)) {
        shrinkCircleInPhases(nextMapValueShown: 0.15);

        zoomTimer.onStopTimer();
      }
    });
    return;
  }

  Future<void> shrinkCircleInPhases({required double nextMapValueShown}) async {
    showCircleIsShrinking.value = true;

    double diff = currentMapValueShown - nextMapValueShown;
    double eachPhaseArea = diff / 3;

    double phase1 = originalTotalArea * (currentMapValueShown - eachPhaseArea);
    double phase2 =
        originalTotalArea * (currentMapValueShown - (eachPhaseArea * 2));
    double phase3 =
        originalTotalArea * (currentMapValueShown - (eachPhaseArea * 3));

    (await controller.future)
        .animateCamera(CameraUpdate.zoomTo(getZoomByArea(phase1)));
    await Future.delayed(Duration(seconds: 2));

    (await controller.future)
        .animateCamera(CameraUpdate.zoomTo(getZoomByArea(phase2)));
    await Future.delayed(Duration(seconds: 2));

    (await controller.future).animateCamera(
      CameraUpdate.zoomTo(
        getZoomByArea(phase3),
      ),
    );

    currentMapValueShown = nextMapValueShown;
    currentCircleArea = currentMapValueShown*originalTotalArea;
    showCircleIsShrinking.value = false;
  }

  bool outOfCircleDeathShown = false;
  late double currentCircleArea;
  StreamSubscription<int>? outOfZoneTimeStream;

  StopWatchTimer timerToEnter = StopWatchTimer(mode: StopWatchMode.countDown);

  ///geofencing testing left just and some modifications in below function

  /// This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      gs.Geofence geofence,
      gs.GeofenceRadius geofenceRadius,
      gs.GeofenceStatus geofenceStatus,
      gs.Location location) async {

    print("on status changed called");
    print("inside");

    if(checkIsHider()){
      if ((!(checkMyUserEliminated())) &&
          latestLobbyModel!.modeType == 'nonshrink') {
        if (geofenceStatus == gs.GeofenceStatus.ENTER) {

          print("user came back in the area!");

          timerToEnter.onStopTimer();
          timerToEnter.onResetTimer();
          outOfZoneTimeStream?.cancel();
          return;
        }

        if (geofenceStatus == gs.GeofenceStatus.EXIT) {
          timerToEnter.setPresetSecondTime(30);
          timerToEnter.onStartTimer();

          showOutOfGameDialog();

          outOfZoneTimeStream = timerToEnter.secondTime.listen((value) async {
            if (value == 1 && !outOfCircleDeathShown) {
              outOfCircleDeathShown = true;

              List<UserModel> hiders = List.from(latestLobbyModel!.hiders!);
              for (var element in hiders) {
                if (element.email == FirebaseAuth.instance.currentUser!.email) {
                  element.eliminated = true;
                  break;
                }
              }


              bool finished =
                  hiders.any((element) => element.eliminated == false);

              await FirebaseFirestore.instance
                  .collection('lobbies')
                  .doc(latestLobbyModel!.lobbyId.toString())
                  .update({
                'hiders': hiders.map((i) => i.toJson()).toList(),
                'gameFinished': finished
              });

              await outOfZoneDeath();
            }
          });
        }
      }

      ///For Shrink Mode
      else if ((!(checkMyUserEliminated())) &&
          latestLobbyModel!.modeType == 'shrink') {
        if(geofenceRadius.length == currentCircleArea){
          if (geofenceStatus == gs.GeofenceStatus.ENTER) {
            print("user came back in the area!");

            timerToEnter.onStopTimer();
            timerToEnter.onResetTimer();
            outOfZoneTimeStream?.cancel();
            return;
          } else if (geofenceStatus == gs.GeofenceStatus.EXIT) {
            timerToEnter.setPresetSecondTime(30);
            timerToEnter.onStartTimer();

            showOutOfGameDialog();

            outOfZoneTimeStream = timerToEnter.secondTime.listen((value) async {
              if (value == 1 && !outOfCircleDeathShown) {
                outOfCircleDeathShown = true;

                List<UserModel> hiders = List.from(latestLobbyModel!.hiders!);
                for (var element in hiders) {
                  if (element.email ==
                      FirebaseAuth.instance.currentUser!.email) {
                    element.eliminated = true;
                    break;
                  }
                }

                bool finished =
                    hiders.any((element) => element.eliminated == false);

                await FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(latestLobbyModel!.lobbyId.toString())
                    .update({
                  'hiders': hiders.map((i) => i.toJson()).toList(),
                  'gameFinished': finished
                });

                await outOfZoneDeath();
              }
            });
          }
        }
        else {
          print("geofence status changed but not for latest circle");
        }
      }

    }
  }

  bool checkMyUserEliminated(){
   UserModel user = latestLobbyModel!.hiders!.firstWhere((element) => element.email==FirebaseAuth.instance.currentUser!.email);
   return user.eliminated;
  }

  bool checkIsHider() {
    return latestLobbyModel!.hiders!.any(
        (element) => element.email == FirebaseAuth.instance.currentUser!.email);
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(
    String title, {
    required String path,
  }) async {
    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.red,
        fontSize: 25,
      ),
      text: title,
    );

    TextPainter painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    painter.text = TextSpan(
      text: title.toString(),
      style: TextStyle(color: Colors.white, fontSize: 25),
    );

    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    painter.layout();
    painter.paint(canvas, const Offset(40, 10.0));
    int textWidth = painter.width.toInt();
    int textHeight = painter.height.toInt();
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, 0, textWidth + 60, textHeight + 20,
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10)),
        Paint()..color = Colors.black87.withOpacity(0.5));
    painter.layout();
    painter.paint(canvas, const Offset(30.0, 10.0));

    ByteData dataimg = await rootBundle.load(path);
    ui.Codec codec = await ui
        .instantiateImageCodec(dataimg.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();
    canvas.drawImage(fi.image, Offset(0, 55), Paint());

    ui.Picture p = pictureRecorder.endRecording();

    ByteData? pngBytes = await (await p.toImage(
            painter.width.toInt() + 100, painter.height.toInt() + 140))
        .toByteData(format: ui.ImageByteFormat.png);
    Uint8List data = Uint8List.view(pngBytes!.buffer);
    return BitmapDescriptor.fromBytes(data);
  }

  Future<bool> setMarkers() async {
    bool yes = true;
    markers.clear();

    // print("hiders length: ${latestLobbyModel!.hiders!.length}");
    //
    // print("setting markers");

    // print('into markers');

    int s = 0;

    for (var element in latestLobbyModel!.hiders!) {
      print("adding a hider $s");
      s = s + 1;
      final BitmapDescriptor markerIcon = await createCustomMarkerBitmap(
          element.email == FirebaseAuth.instance.currentUser!.email
              ? 'you'
              : element.name ?? '',
          path: element.image!.replaceAll(RegExp('avatar'), "avatar_pin"));

      markers.add(
        Marker(

            markerId: MarkerId(element.email!),
            position: LatLng(element.latitude!, element.longitude!),
            icon: markerIcon),
      );
    }
    for (var element in latestLobbyModel!.searchers!) {
      final BitmapDescriptor markerIcon = await createCustomMarkerBitmap(
          element.email == FirebaseAuth.instance.currentUser!.email
              ? 'you'
              : element.name ?? '',
          path: element.image!.replaceAll(RegExp('avatar'), "avatar_pin"));

      markers.add(
        Marker(
            markerId: MarkerId(element.email!),
            position: LatLng(element.latitude!, element.longitude!),
            icon: markerIcon),
      );
    }

    // print("markers array length: ${markers.length}");
    // print("markers.first.visible ${markers.first.visible}");
    // print("${markers.first.position.latitude}  ${markers.first.position.longitude}");
    // print("${LocationHelper.getPreviousLocationData()!.latitude}  ${LocationHelper.getPreviousLocationData()!.longitude}");

    // print("marker ids:");
    markers.forEach((element) {
      // print(element.markerId.value);
    });
    await initializeRemoteConfig();
    // print("All Markers Set");

    return yes;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  ///Show Just Own Marker

  Set<Marker> ownMarker() {
    // print("markers length total ${this.markers.length}");
    // this.markers.forEach((element) {
    //   print(element.markerId.value);
    // });

    Set<Marker> markers = Set.from(this.markers);
    markers.retainWhere((element) =>
        element.markerId.value == FirebaseAuth.instance.currentUser!.email);
    // print("own markers: ");
    // print(markers.length);

    // print(
    //     "${markers.first.position.latitude}  ${markers.first.position.longitude}");
    // print(
    //     "${LocationHelper.getPreviousLocationData()!.latitude}  ${LocationHelper.getPreviousLocationData()!.longitude}");

    return markers;
  }

  void updateMarkers() {
    try {
      // print("updating markers");

      // for (var element in markers) {
      //   if (latestLobbyModel!.hiders!
      //       .any((hider) => hider.email == element.markerId.value)) {
      //     int i = latestLobbyModel!.hiders!
      //         .indexWhere((hider) => hider.email == element.markerId.value);
      //     element = Marker(
      //         markerId: element.markerId,
      //         icon: element.icon,
      //         position: LatLng(latestLobbyModel!.hiders![i].latitude!,
      //             latestLobbyModel!.hiders![i].longitude!));
      //     print("successfully updated hider position");
      //
      //     print("element value:");
      //     print(element.position.latitude);
      //
      //
      //   }
      // }

      markers = markers.map((element) {
        if (latestLobbyModel!.searchers!
            .any((searcher) => searcher.email == element.markerId.value)) {
          int i = latestLobbyModel!.searchers!.indexWhere(
              (searcher) => searcher.email == element.markerId.value);
          return Marker(
              markerId: element.markerId,
              icon: element.icon,
              position: LatLng(latestLobbyModel!.searchers![i].latitude!,
                  latestLobbyModel!.searchers![i].longitude!));
        }
        return element;
      }).toSet();

      markers = markers.map((Marker element) {
        if (latestLobbyModel!.hiders!
            .any((hider) => hider.email == element.markerId.value)) {
          int i = latestLobbyModel!.hiders!
              .indexWhere((hider) => hider.email == element.markerId.value);
          return Marker(

              markerId: element.markerId,
              icon: element.icon,
              position: LatLng(latestLobbyModel!.hiders![i].latitude!,
                  latestLobbyModel!.hiders![i].longitude!));
        }
        return element;
      }).toSet();

      // print("array element value:");

      // print(markers.first.position.latitude);

      if (markers.isNotEmpty) {
        // print("before updating searcher, marker latitude");
        print(markers.elementAt(0).position.latitude);
      }

      if (markers.isNotEmpty) {
        // print("after updating searcher, marker latitude");
        // print(markers.elementAt(0).position.latitude);
      }
    } catch (e) {
      print("errors in update markers");
      print(e);
    }
  }

  bool currentUserEliminated() {
    int i = latestLobbyModel!.hiders!.indexWhere(
        (element) => element.email == FirebaseAuth.instance.currentUser!.email);

    if (latestLobbyModel!.hiders![i].eliminated) {
      return true;
    }
    return false;
  }

  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  // final Stopwatch disconnectTimer = Stopwatch();

  Timer? disconnectTimer;
  int secondsDisconnected = 0;

  _listenConnectivity() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        secondsDisconnected = 0;
        disconnectTimer?.cancel();
        disconnectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          secondsDisconnected = secondsDisconnected + 1;
        });

        print("resetting timer");
        // disconnectTimer.reset();
        // disconnectTimer.start();
        // Future.delayed(Duration(seconds: 5), (){
        //   print("after 5 seconds");
        //   print(disconnectTimer.elapsed.inSeconds);
        // });

        ///showing win/lose dialog
        if (NoShrinkModeGobals.showingDialog &&
            latestLobbyModel!.gameFinished) {
          return;
        }

        ///showing Game Crash Dialog or Disconnect Dialog
        if (NoShrinkModeGobals.showingDialog &&
            !(latestLobbyModel!.gameFinished)) {
          Get.back();
        }

        ///show disconnect dialog
        NoShrinkModeGobals.showingDialog = true;
        await disConnectGame(() async {
          if (await Connectivity().checkConnectivity() ==
              ConnectivityResult.none) {
            Get.snackbar("Request Failed", "No internet Connection",
                backgroundColor: Colors.white);
          } else {
            if (latestLobbyModel!.gameFinished) {
              Get.snackbar("Request Failed", "Match finished",
                  backgroundColor: Colors.white);
              NoShrinkModeGobals.showingDialog = false;
              Get.offAll(() =>  HomeScreen());
            }

            ///Change to 300
            else if (secondsDisconnected > 30) {
              LobbyModel lobbyModel = latestLobbyModel!;

              ///if hider
              if (latestLobbyModel!.hiders!.any((element) =>
                  element.email == FirebaseAuth.instance.currentUser!.email)) {
                lobbyModel.hiders!.removeWhere((element) =>
                    element.email == FirebaseAuth.instance.currentUser!.email);
                FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(lobbyModel.lobbyId!.toString())
                    .update({
                  'hiders': lobbyModel.hiders!.map((i) => i.toJson()).toList(),
                  'gameFinished': lobbyModel.hiders!.isEmpty
                });
              } else {
                lobbyModel.searchers!.removeWhere((element) =>
                    element.email == FirebaseAuth.instance.currentUser!.email);
                FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(lobbyModel.lobbyId!.toString())
                    .update({
                  'searchers':
                      lobbyModel.searchers!.map((i) => i.toJson()).toList(),
                  'gameFinished': lobbyModel.searchers!.isEmpty
                });
              }

              Get.snackbar("Timeout", "You are eliminated",
                  backgroundColor: Colors.white);
              NoShrinkModeGobals.showingDialog = false;
              Get.offAll(() =>  HomeScreen());
            }

            ///return to game
            else {
              print("disconnected time: $secondsDisconnected");
              Get.back();
            }
          }
        });
        NoShrinkModeGobals.showingDialog = false;
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print("before stopping ${secondsDisconnected}");
        disconnectTimer?.cancel();
        // if(secondsDisconnected < 30) {
        //   disconnectTimer.reset();
        // }
      }

      // Got a new connectivity status!
    });
  }

  checkConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      secondsDisconnected = 0;
      disconnectTimer?.cancel();
      disconnectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        secondsDisconnected = secondsDisconnected + 1;
      });

      print("resetting timer");

      ///showing win/lose dialog
      if (NoShrinkModeGobals.showingDialog && latestLobbyModel!.gameFinished) {
        return;
      }

      ///showing Game Crash Dialog or Disconnect Dialog
      if (NoShrinkModeGobals.showingDialog &&
          !(latestLobbyModel!.gameFinished)) {
        return;
        // Get.back();
      }

      ///show disconnect dialog
      NoShrinkModeGobals.showingDialog = true;
      await disConnectGame(() async {
        if (await Connectivity().checkConnectivity() ==
            ConnectivityResult.none) {
          Get.snackbar("Request Failed", "No internet Connection",
              backgroundColor: Colors.white);
        } else {
          if (latestLobbyModel!.gameFinished) {
            Get.snackbar("Request Failed", "Match finished",
                backgroundColor: Colors.white);
            NoShrinkModeGobals.showingDialog = false;
            Get.offAll(() =>  HomeScreen());
          } else if (secondsDisconnected > 300) {
            LobbyModel lobbyModel = latestLobbyModel!;

            ///if hider
            try {
              if (latestLobbyModel!.hiders!.any((element) =>
                  element.email == FirebaseAuth.instance.currentUser!.email)) {
                lobbyModel.hiders!.removeWhere((element) =>
                    element.email == FirebaseAuth.instance.currentUser!.email);
                FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(lobbyModel.lobbyId!.toString())
                    .update({
                  'hiders': lobbyModel.hiders!.map((i) => i.toJson()).toList(),
                  'gameFinished': lobbyModel.hiders!.isEmpty
                });
              } else {
                lobbyModel.searchers!.removeWhere((element) =>
                    element.email == FirebaseAuth.instance.currentUser!.email);
                FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(lobbyModel.lobbyId!.toString())
                    .update({
                  'searchers':
                      lobbyModel.searchers!.map((i) => i.toJson()).toList(),
                  'gameFinished': lobbyModel.searchers!.isEmpty
                });
              }
            } catch (e) {
              print(e);
            }
            Get.snackbar("Timeout", "You are eliminated",
                backgroundColor: Colors.white);
            NoShrinkModeGobals.showingDialog = false;
            Get.offAll(() =>  HomeScreen());
          }

          ///return to game
          else {
            print("disconnected time: $secondsDisconnected");
            Get.back();
          }
        }
      });
      NoShrinkModeGobals.showingDialog = false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      print("before stopping $secondsDisconnected");
      disconnectTimer?.cancel();
    }
  }

  Future<bool> initializeRemoteConfig() async {
    try {
      print('remote testing');
      remoteConfigService = await RemoteConfigService.getInstance();
      await remoteConfigService!.initialize();
      print("hidermarkershow=================${remoteConfigService!.hider_marker_show}");
      print("debug=================${remoteConfigService!.debug}");
      print("shrink after: ${remoteConfigService!.shrink_after}");
      print("hider_marker_show_for: ${remoteConfigService!.hider_marker_show_for}");
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    return true;
  }

  double getDistance(LatLng l1,LatLng l2){
   return Geolocator.distanceBetween(l1.latitude, l1.longitude, l2.latitude, l2.longitude);
  }

  @override
  void dispose() async {
    print('DISPOSE CALLED');
    await locationSubscription?.cancel();
    await timerSubscription?.cancel();
    timer!.cancel();

    // TODO: implement dispose
    super.dispose();
  }
}
