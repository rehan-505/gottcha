import 'dart:async';
import 'package:geofence_service/geofence_service.dart' as gs;
import 'package:geofence_service/models/geofence.dart';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gottcha/non_shrink_mode/BottomBarController.dart';
import 'package:gottcha/screens/home/home.dart';
import 'package:gottcha/utils/NoShrinkModeGlobals.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/customappbar.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wakelock/wakelock.dart';
import '../model/lobbymodel.dart';
import '../model/usermodel.dart';
import 'non_shrink_mode_controller.dart';

class NonShrinkMode extends StatelessWidget {
  bool hiderPage;
  final LobbyModel lobbyModel;
  NonShrinkMode({
    Key? key,
    this.hiderPage = false,
    required this.lobbyModel,
  }) : super(key: key);

  final NonShrinkModeController _controller =
      Get.put(NonShrinkModeController());

  @override
  Widget build(BuildContext context) {
    _controller.latestLobbyModel = lobbyModel;
    _controller.isHider = hiderPage;

    print("no shrink mode game");

    return FutureBuilder(
        future: _controller.setMarkers(),
        builder: (cont, syn) {
          if (syn.connectionState == ConnectionState.waiting ||
              (!(syn.hasData))) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: primaryColor1,
                ),
              ),
            );
          }

          return NoShrinkModeBody(
            lobbyModel: lobbyModel,
            nonShrinkModeController: _controller,
            hiderPage: hiderPage,
          );
        });
  }
}

class NoShrinkModeBody extends StatefulWidget {
  NoShrinkModeBody(
      {Key? key,
      required this.lobbyModel,
      this.hiderPage = false,
      required this.nonShrinkModeController})
      : super(key: key);
  bool hiderPage;
  final LobbyModel lobbyModel;
  final NonShrinkModeController nonShrinkModeController;

  @override
  State<NoShrinkModeBody> createState() => _NoShrinkModeBodyState();
}

class _NoShrinkModeBodyState extends State<NoShrinkModeBody>
    with WidgetsBindingObserver {
  late NonShrinkModeController _controller;
  late bool shrinkMode;

  Timer? showHidersTimer;
  Timer? hideHidersTimer;
  StopWatchTimer inBackgroundTimer =
      StopWatchTimer(mode: StopWatchMode.countDown);
  StreamSubscription? backgroundStream;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.paused) {

      inBackgroundTimer.setPresetSecondTime(120);
      inBackgroundTimer.onStartTimer();

      backgroundStream=inBackgroundTimer.secondTime.listen((event) {
        if (event == 1) {
          if (_controller.checkIsHider()) {
            _controller.latestLobbyModel!.hiders!.removeWhere((element) =>
                element.email == FirebaseAuth.instance.currentUser!.email);
            FirebaseFirestore.instance
                .collection('lobbies')
                .doc(_controller.latestLobbyModel!.lobbyId!.toString())
                .update({
              'hiders': _controller.latestLobbyModel!.hiders!
                  .map((i) => i.toJson())
                  .toList(),
              'gameFinished': _controller.latestLobbyModel!.hiders!.isEmpty
            });
          }
          else {
            _controller.latestLobbyModel!.searchers!.removeWhere((element) =>
                element.email == FirebaseAuth.instance.currentUser!.email);
            FirebaseFirestore.instance
                .collection('lobbies')
                .doc(_controller.latestLobbyModel!.lobbyId!.toString())
                .update({
              'searchers': _controller.latestLobbyModel!.searchers!
                  .map((i) => i.toJson())
                  .toList(),
              'gameFinished': _controller.latestLobbyModel!.searchers!.isEmpty
            });
          }
          Get.offAll(()=>HomeScreen());
          return;
        }

      });

    } else if (state == AppLifecycleState.resumed) {
      inBackgroundTimer.onStopTimer();
      inBackgroundTimer.onResetTimer();
      inBackgroundTimer.clearPresetTime();
      backgroundStream?.cancel();
      backgroundStream=null;


    }
  }

  @override
  void initState() {
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(seconds: 3), () async {
      await treePassingDialog();
    });
    if (double.parse(widget.lobbyModel.area!) == 0) {
      Get.offAll(() => HomeScreen());
      Get.snackbar("Error", "AREA IS ZERO");
    }

    _controller = widget.nonShrinkModeController;
    shrinkMode = (widget.lobbyModel.modeType == 'shrink');
    _controller.latestLobbyModel = widget.lobbyModel;

    ///constant
    // _controller.remoteConfigService!.shrink_after = 2;

    _controller.currentCircleArea = double.parse(widget.lobbyModel.area!);
    _controller.originalTotalArea = double.parse(widget.lobbyModel.area!);
    print('area ${double.parse(widget.lobbyModel.area!)}');
    if (shrinkMode) {
      _controller.setShrinkingLimits();
      _controller.manageCircleShrinksInText();
    }

    if(!shrinkMode){
      _controller.geofenceRadiusList = [
        gs.GeofenceRadius(
          id: 'first',
          length: double.parse(_controller.latestLobbyModel!.area!),
        ),
      ];
    }

    _controller.timerSetup(globalTimeMap[widget.lobbyModel.time!] ?? 0);

    // Future.delayed(const Duration(seconds: 5),(){
    //   _controller.setZoomLevels();
    // });

    if (widget.hiderPage) {
      try {
        _controller.myUser = _controller.latestLobbyModel!.hiders!.firstWhere(
            (element) =>
                element.email == FirebaseAuth.instance.currentUser!.email!);
      } catch (e) {
        print("user is not into hiders");
      }
    } else {
      _controller.myUser = _controller.latestLobbyModel!.searchers!.firstWhere(
          (element) =>
              element.email == FirebaseAuth.instance.currentUser!.email!);
    }

    Future.delayed(const Duration(seconds: 5), () {
      _controller.updateMyLocation();
    });

    // if(Platform.isAndroid){
    //   _controller.listenConnectivity();
    // }

    Future.delayed(Duration(seconds: 2), () {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        _controller.checkConnectivity();
      });
    });

    if (shrinkMode) {
      _controller.setZoomLevels();
    }

    if (!widget.hiderPage) {
      showHidersTimer = Timer.periodic(
          Duration(
              seconds: _controller.remoteConfigService!.hider_marker_show * 60),
          (timer) {
        _controller.hidersVisible.value = true;
      });

      Future.delayed(
          Duration(
            seconds: _controller.remoteConfigService!.hider_marker_show_for,
          ), () {
        hideHidersTimer = Timer.periodic(
            Duration(
                seconds: (_controller.remoteConfigService!.hider_marker_show *
                    60)), (timer) {
          _controller.hidersVisible.value = false;
        });
      });
    }

    super.initState();
  }

  bool outOfGameShown = false;

  bool? hidersWon;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    // _controller.timerSetup(2);

    ///showing hiders marker after 10 minutes for 10 seconds

    print("show after minutes:");
    print(_controller.remoteConfigService!.hider_marker_show);

    print("show for seconds:");
    print(_controller.remoteConfigService!.hider_marker_show_for);

    // if (!widget.hiderPage) {
    //    timer= Timer(
    //        Duration(seconds: _controller.hidersVisible.value? _controller.remoteConfigService!.hider_marker_show_for  :  0,minutes:_controller.hidersVisible.value? 0  :  _controller.remoteConfigService!.hider_marker_show),
    //
    //        // Duration(seconds: _controller.hidersVisible.value? 10  :  0,minutes:_controller.hidersVisible.value? 0  :  2),
    //
    //        () {
    //
    //      _controller.hidersVisible.value = !_controller.hidersVisible.value;
    //
    //
    //      if(mounted){
    //
    //       // _controller.hidersVisible.value = !_controller.hidersVisible.value;
    //
    //
    //       // setState(() {
    //       //   print(" into hiders hide or visible");
    //       //   print("setting state ${_controller.hidersVisible.value}");
    //       //   _controller.hidersVisible.value = !(_controller.hidersVisible.value);
    //       //   print('setting state function finished');
    //       //
    //       //
    //       // });
    //     }
    //      else {
    //        // print("not mounted, not setting state gameplay");
    //      }
    //   });    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('lobbies')
            .doc(widget.lobbyModel.lobbyId.toString())
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if ((snapshot.connectionState != ConnectionState.waiting) &&
              snapshot.hasData) {
            _controller.latestLobbyModel =
                LobbyModel.fromJson(snapshot.data!.data()!);
            // print('rebuildedddddddddddddd');
            _controller.updateMarkers();
          }

          if (widget.hiderPage) {
            try {
              _controller.myUser = _controller.latestLobbyModel!.hiders!
                  .firstWhere((element) =>
                      element.email ==
                      FirebaseAuth.instance.currentUser!.email!);
            } catch (e) {
              print("user is not into hiders");
            }
          } else {
            _controller.myUser = _controller.latestLobbyModel!.searchers!
                .firstWhere((element) =>
                    element.email == FirebaseAuth.instance.currentUser!.email!);
          }

          if (!NoShrinkModeGobals.resultDialogsShown) {
            if (widget.hiderPage &&
                _controller.latestLobbyModel!.searchers!.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                NoShrinkModeGobals.showingDialog = true;
                await showGameCrashedSearcherLeft(context);
                NoShrinkModeGobals.showingDialog = false;
              });
            } else if (_controller.latestLobbyModel!.gameFinished) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // print("into post frame call back");
                if (_controller.latestLobbyModel!.gameFinished &&
                    !NoShrinkModeGobals.resultDialogsShown) {
                  print("going to show dialogues");
                  _controller.timer?.cancel();
                  NoShrinkModeGobals.resultDialogsShown = true;
                  _controller.latestLobbyModel!.noOfSecondsGameLasted =
                      _controller.totalSeconds;
                  hidersWon = _controller.latestLobbyModel!.hiders!
                      .any((element) => (element.eliminated == false));

                  if (NoShrinkModeGobals.showingDialog) {
                    Get.back();
                  }

                  if (widget.hiderPage) {
                    if (hidersWon!) {
                      winDialog(context,
                          hiderWon: true,
                          myUser: _controller.myUser!,
                          lobbyModel: _controller.latestLobbyModel!);
                    } else if (!(hidersWon!)) {
                      loseDialog(context,
                          hiderLost: true,
                          myUser: _controller.myUser!,
                          lobbyModel: _controller.latestLobbyModel!);
                    }
                  } else {
                    if (!(hidersWon!)) {
                      winDialog(context,
                          hiderWon: false,
                          myUser: _controller.myUser!,
                          lobbyModel: _controller.latestLobbyModel!);
                    } else if (hidersWon!) {
                      loseDialog(context,
                          hiderLost: false,
                          myUser: _controller.myUser!,
                          lobbyModel: _controller.latestLobbyModel!);
                    }
                  }
                }

                if (_controller.myUser!.eliminated &&
                    !outOfGameShown &&
                    !NoShrinkModeGobals.resultDialogsShown) {
                  showYouHaveBeenFoundDialog();
                }
              });
            }
          }

          return Scaffold(
            body: Container(
              color: backgroundColor,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned.fill(
                    bottom: resHeight(120),
                    child: Obx(() {
                      print("google map obx called");
                      print(
                          "circles set length: ${_controller.circles.length}");

                      if (_controller.circles.length > 1) {
                        print(_controller.circles.first.center);
                        print(_controller.circles.first.radius);
                        print(_controller.circles.first.circleId.value);
                      }

                      return GoogleMap(
                          circles: true
                              ? {
                                  Circle(
                                      circleId: const CircleId("dummy"),
                                      center: LatLng(
                                        _controller.latestLobbyModel!.mapLat!,
                                        _controller.latestLobbyModel!.mapLng!,
                                      ),
                                      radius: 10,
                                      strokeWidth: 1)
                                }
                              : _controller.circles,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          mapType: _controller.hidersVisible.value
                              ? MapType.normal
                              : MapType.normal,
                          initialCameraPosition: const CameraPosition(
                            target:
                                LatLng(37.42796133580664, -122.085749655962),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _onMapCreated(controller);
                          },
                          markers: widget.hiderPage
                              ? (_controller.currentUserEliminated()
                                  ? _controller.markers
                                  : _controller.ownMarker())
                              : (_controller.hidersVisible.value
                                  ? _controller.markers
                                  : _controller.ownMarker())
                          // myLocationButtonEnabled: true,
                          // myLocationEnabled: true,

                          );
                    }),
                  ),
                  Positioned.fill(
                    top: 0,
                    left: 0,
                    child: true
                        ? Image.asset(
                            "assets/images/areaarea2.png",
                            width: Get.width,
                            fit: BoxFit.fill,
                          )
                        : SvgPicture.asset(
                            'assets/images/areaarea2.svg',
                            width: Get.width,
                            fit: BoxFit.fill,
                          ),
                  ),

                  ///Center avatar on map
                  // Positioned(
                  //   top: resHeight(291),
                  //   // left: 0,
                  //   // bottom: 0,
                  //   // right: 0,
                  //   child: Align(child: Image.asset(myUser!.image!)),
                  // ),

                  // Positioned(bottom: resHeight(250), child: _buildContainersRow()),
                  Obx(() {
                    // print("_controller.circleShrinkSecondsLeftText.value ${_controller.circleShrinkSecondsLeftText.value}");
                    return Container(
                      child: (_controller.hidersVisible.value)
                          ? Positioned(
                              right: resWidth(85),
                              left: resWidth(85),
                              bottom: resHeight(210),
                              child: CustomToastContainer(
                                  text: "Hider are visible"))
                          : SizedBox(),
                    );
                  }),
                  Obx(() {
                    print(
                        "_controller.circleShrinkSecondsLeftText.value ${_controller.circleShrinkSecondsLeftText.value}");
                    return Container(
                      child: (_controller.circleShrinkSecondsLeftText.value ==
                                  "" ||
                              _controller.circleShrinkSecondsLeftText.value ==
                                  "00:0")
                          ? SizedBox()
                          : Positioned(
                              right: resWidth(85),
                              left: resWidth(85),
                              bottom: resHeight(240),
                              child: CustomToastContainer(
                                  text:
                                      "Circle shrinks in ${_controller.circleShrinkSecondsLeftText.value}")),
                    );
                  }),

                  Obx(() {
                    return Container(
                      child: (!(_controller.showCircleIsShrinking.value))
                          ? SizedBox()
                          : Positioned(
                              right: resWidth(85),
                              left: resWidth(85),
                              bottom: resHeight(250),
                              child: const CustomToastContainer(
                                  text: "Circle is shrinking")),
                    );
                  }),

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
                            padding: const EdgeInsets.symmetric(vertical: 35),
                            child: CustomAppBar(
                              isActionName: false,
                              isLeadingRec: true,
                              leading: 'assets/images/Vector@2x.svg',
                              action: 'assets/images/info.svg',
                              title: (widget.lobbyModel.time) == 'unlimited'
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Game time',
                                            style: blackNormalStyle16,
                                          ),
                                          Obx(() => Row(
                                                children: [
                                                  Text(
                                                    '${(_controller.timeValueUnlimited.value.seconds).toString().split('.')[0]}',
                                                    style: blackBoldStyle16
                                                        .copyWith(fontSize: 24),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Game ends in',
                                            style: blackNormalStyle16,
                                          ),
                                          Obx(() => Row(
                                                children: [
                                                  Text(
                                                    '${(_controller.timeValue.value.seconds).toString().split('.')[0]}',
                                                    style: blackBoldStyle16
                                                        .copyWith(fontSize: 24),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                              actionFunction: () async {
                                await showInfoMenu(context);
                              },
                              leadingFunction: () async {
                                await menuDialog(
                                  context,
                                  _controller.latestLobbyModel!,
                                  isHider: widget.hiderPage,
                                );

                                // _controller.timerSetup();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: BottomBar(
                        hiderPage: widget.hiderPage,
                        hiders: _controller.latestLobbyModel!.hiders!,
                        myUser: _controller.myUser!,
                        lobbyModel: _controller.latestLobbyModel!,
                        searchers: _controller.latestLobbyModel!.searchers!),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    if (!_controller.controller.isCompleted) {
      _controller.controller.complete(_cntlr);
    }

    _controller.googleMapController = _cntlr;
    // GoogleMapController googleMapController = _cntlr;

    _cntlr.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_controller.latestLobbyModel!.mapLat!,
                _controller.latestLobbyModel!.mapLng!),
            zoom: _controller.latestLobbyModel!.mapZoom!),
        // CameraPosition(target: LatLng(LocationHelper.getPreviousLocationData()!.latitude!, _controller.latestLobbyModel!.mapLat!),zoom: _controller.latestLobbyModel!.mapZoom!),
      ),
    );
  }

  Future<void> showYouHaveBeenFoundDialog() async {
    if (outOfGameShown) {
      return;
    }

    outOfGameShown = true;

    await customDialog(
      context,
      img: 'assets/images/sademoji.svg',
      heading: 'You have been\nfound',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          resHeightBox(10),
          Text(
            'Bad luck, the searcher found you, so you out of a game! You can stay in game or leave the lobby.',
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
                  Get.offAll(HomeScreen());
                },
                child: SizedBox(
                  height: resHeight(43),
                  width: resWidth(120),
                  child: Center(
                      child: gradientNormalStyle("Leave",
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

  timerDialog(BuildContext context) async {
    await customDialog(context,
        function: () {},
        buttonText: 'I got it',
        heading: 'Timer Started',
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'You have 15 minutes to hide from your searchers.',
              style: darkGreyNormalStyle20,
              textAlign: TextAlign.center,
            )));
  }

  blueContainer({bool win = true}) {
    return Container(
      decoration: BoxDecoration(
          color: lightBlue,
          border:
              Border.all(color: Color.fromRGBO(255, 255, 255, 0.44), width: 3),
          borderRadius: BorderRadius.circular(6)),
      padding: EdgeInsets.symmetric(
          horizontal: resWidth(12), vertical: resHeight(12)),
      child: Text(
        win
            ? "Prototype action:\nEnd match (WIN)"
            : "Prototype action:\nEnd match (LOSE)",
        style: whiteMiniText12,
      ),
    );
  }

  _buildContainersRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        blueContainer(),
        resWidthBox(19),
        blueContainer(win: false),
      ],
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
    _controller.locationSubscription?.cancel();
    _controller.timerSubscription?.cancel();
    _controller.unlimitedtimerSubscription?.cancel();
    timer?.cancel();
    _controller.outOfZoneTimeStream?.cancel();
    _controller.connectivitySubscription?.cancel();
    _controller.disconnectTimer?.cancel();
    _controller.zoomTimerListener?.cancel();
    NoShrinkModeGobals.resultDialogsShown = false;
    NoShrinkModeGobals.showingDialog = false;
    _controller.localStream?.cancel();
    showHidersTimer?.cancel();
    hideHidersTimer?.cancel();

    super.dispose();
  }
}

class BottomBar extends StatefulWidget {
  final LobbyModel lobbyModel;
  bool hiderPage;
  final List<UserModel> hiders;
  final List<UserModel> searchers;
  final UserModel myUser;

  BottomBar(
      {Key? key,
      required this.hiderPage,
      required this.hiders,
      required this.myUser,
      required this.lobbyModel,
      required this.searchers})
      : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final Map selectedMap = {};

  BottomBarController bottomBarController = BottomBarController();

  UserModel? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: resWidth(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.hiderPage
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: resHeight(18)),
                  child: Text(
                    "Pick the player you found and press Gottcha! ",
                    style: greyMiniStyle12Color50w500,
                  ),
                ),
          resHeightBox(23),
          SizedBox(
            height: resHeight(80),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.searchers.length + widget.hiders.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < widget.searchers.length) {
                  return selectedAvatar(
                      widget.searchers[index], context, index);
                }

                return selectedAvatar(
                    widget.hiders[index - widget.searchers.length],
                    context,
                    index);
              },
            ),
          ),
          resHeightBox(20),
          widget.hiderPage
              ? SizedBox()
              : Obx(() => Container(
                    child: bottomBarController.loading.value
                        ? SizedBox(
                            height: resHeight(45),
                            width: resHeight(45),
                            child: const CircularProgressIndicator(
                              color: primaryColor1,
                            ),
                          )
                        : CustomButton(
                            onPressed: () async {
                              for (var element in selectedMap.keys) {
                                selectedMap[element] = false;
                              }
                              // print("////////////////////////////////////////////////////");
                              await bottomBarController.gotchaOnPressed(
                                  widget.myUser,
                                  selectedUser!,
                                  widget.lobbyModel,
                                  context);
                              // print("bye");

                              // await cannotStartDialog(context);
                              // await gameCrashedDialog(context);
                              //
                              // await showOutOfGameDialog(context);
                              //
                              // await winDialog(context);
                              // await loseDialog(context);
                            },
                            text: "Gotcha",
                            isDiabled:
                                !(selectedMap.values.toList().contains(true))),
                  )),
          resHeightBox(30),
        ],
      ),
    );
  }

  Widget selectedAvatar(UserModel userModel, BuildContext context, int index) {
    return GestureDetector(
      onTap: (widget.hiderPage ||
              userModel.eliminated ||
              index < widget.searchers.length)
          ? () {}
          : () {
              setState(() {
                bool? value = selectedMap[userModel.email!];

                for (var element in selectedMap.keys) {
                  selectedMap[element] = false;
                }

                if (value == null) {
                  selectedMap[userModel.email!] = true;
                } else {
                  selectedMap[userModel.email!] = !value;
                }

                selectedUser = userModel;
              });
            },
      child: Padding(
        padding: EdgeInsets.only(right: resWidth(14)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            index < widget.searchers.length
                ? buildSearcherAvatarOutlined(userModel.image!)
                : Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey,

                        gradient: ((selectedMap[userModel.email!] ?? false) &&
                                (!userModel.eliminated))
                            ? LinearGradient(
                                colors: [
                                  primaryColor1,
                                  primaryColor2,
                                ],
                              )
                            : null,
                        // borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.circle),
                    // margin: const EdgeInsets.only(bottom: 8),
                    // height: resHeight(64),
                    // width: resWidth(283),
                    child: userModel.eliminated
                        ? buildCrossAvatar(userModel.image!)
                        : SizedBox(
                            width: resWidth(55),
                            height: resHeight(50),
                            child: Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(-202032),
                                    shape: BoxShape.circle
                                    // borderRadius: BorderRadius.circular(12),
                                    // border: selected ? Border.all(color: whiteColorLight) : null
                                    ),
                                // padding:  EdgeInsets.only(left: resWidth(12), right: resWidth(22)),
                                child: Center(
                                  child: userModel.eliminated
                                      ? buildCrossAvatar(userModel.image!)
                                      : CircleAvatar(
                                          backgroundColor: Color(-202032),
                                          backgroundImage: Image.asset(
                                            userModel.image!,
                                            height: 48,
                                            width: 48,
                                          ).image,
                                        ),
                                ),
                              ),
                            ),
                          ),
                  ),
            resHeightBox(6),
            Text(
              userModel.name!,
              style: greyStyle14Darkw600,
            )
          ],
        ),
      ),
    );

    // return Padding(
    //   padding: EdgeInsets.only(right: resWidth(14)),
    //   child: Image.asset(pngPath),
    // );
  }
}
