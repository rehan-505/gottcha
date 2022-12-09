import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:gottcha/screens/begin_game/begin_game.dart';
import 'package:gottcha/screens/hider_game_setting/hidergamesetting.dart';
import 'package:gottcha/screens/lobby_room/lobby_room_controller.dart';
import 'package:gottcha/widgets/custom_button.dart';
import 'package:gottcha/widgets/customappbar.dart';
import 'package:location/location.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

import '../../utils/constants.dart';
import '../../utils/location_helper.dart';
import '../../utils/text_constants.dart';

class LobbyRoomScreen extends StatefulWidget {
  LobbyRoomScreen(
      {Key? key,
        required this.lobbyModel,
        required this.myUser,
        this.join = false})
      : super(key: key);
  // bool hider;
  final LobbyModel lobbyModel;
  final UserModel myUser;
  final join;
  @override
  State<LobbyRoomScreen> createState() => _LobbyRoomScreenState();
}

class _LobbyRoomScreenState extends State<LobbyRoomScreen> {
  // late LobbyModel newLobbyModel;
  late LobbyRoomController lobbyRoomController =
  Get.put(LobbyRoomController(widget.lobbyModel));
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool snackbar = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.myUser.email!);
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("lobbies")
              .doc(widget.lobbyModel.lobbyId.toString())
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            print("into lobbyroom stream builder");

            if ((!(snapshot.connectionState == ConnectionState.waiting)) &&
                snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>> doc = snapshot.data!;
              lobbyRoomController.newLobbyModel =
                  LobbyModel.fromJson(doc.data()!);

              lobbyRoomController.everyoneReady.value = (lobbyRoomController
                  .newLobbyModel.hiders!
                  .every((element) => element.isReady!) &&
                  lobbyRoomController.newLobbyModel.searchers!
                      .every((element) => element.isReady!));

              if (lobbyRoomController.everyoneReady.value &&
                  (!(lobbyRoomController.forwarded))) {
                if (lobbyRoomController.newLobbyModel.hiders!.isNotEmpty &&
                    lobbyRoomController.newLobbyModel.searchers!.isNotEmpty) {
                  if (lobbyRoomController.newLobbyModel.hiders!
                      .any((element) => element.email == widget.myUser.email)) {
                    Future.delayed( const Duration(milliseconds: 500), () {
                      Get.off(HiderGameSetting(
                        lobbyModel: lobbyRoomController.newLobbyModel,
                      ));
                      lobbyRoomController.forwarded = true;
                    });
                  }
                  else {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      lobbyRoomController.forwarded = true;

                      Get.off(BeginGameScreen(
                        lobbyModel: lobbyRoomController.newLobbyModel,
                        lobbyId: lobbyRoomController.newLobbyModel.lobbyId!,
                      ));
                    });
                  }
                } else if (!widget.join && snackbar) {
                  snackbar = false;

                  Future.delayed(const Duration(seconds: 1), () {
                    lobbyRoomController.forwarded = false;

                    Get.snackbar("Error", "Their must be 1 Hider & 1 Searcher",
                        backgroundColor: Colors.white);
                  }).then((value) => snackbar = true);
                }
              }
            }
            // print("hiders: ");

            // for (var element in lobbyRoomController.newLobbyModel.hiders!) {print(element.email);}
            // print(lobbyRoomController.newLobbyModel.hiders);

            // print("searchers: ");
            // for (var element in lobbyRoomController.newLobbyModel.searchers!) {print(element.email);}

            if (lobbyRoomController.newLobbyModel.hiders!
                .any((element) => element.email == widget.myUser.email)) {
              List<UserModel> dummyList = lobbyRoomController
                  .newLobbyModel.hiders!
                  .where((element) => element.email == widget.myUser.email)
                  .toList();

              lobbyRoomController.newLobbyModel.hiders!.removeWhere(
                      (element) => element.email == widget.myUser.email);

              lobbyRoomController.newLobbyModel.hiders!.insert(0, dummyList[0]);
            } else if (lobbyRoomController.newLobbyModel.searchers!
                .any((element) => element.email == widget.myUser.email)) {
              List<UserModel> dummyList = lobbyRoomController
                  .newLobbyModel.searchers!
                  .where((element) => element.email == widget.myUser.email)
                  .toList();

              lobbyRoomController.newLobbyModel.searchers!.removeWhere(
                      (element) => element.email == widget.myUser.email);

              lobbyRoomController.newLobbyModel.searchers!
                  .insert(0, dummyList[0]);
            }

            return Stack(
              children: <Widget>[
                // SvgPicture.asset("assets/images/bg1.svg",
                //   fit: BoxFit.cover,
                //   width: MediaQuery.of(context).size.width,
                //
                //
                // ),

                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg1.png"),fit: BoxFit.cover)),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize:   MainAxisSize.min,
                        children: [


                          // CustomAppBar(leading: "assets/images/Arrow.svg", action: "assets/images/info.svg",),



                          resHeightBox(182),
                          Padding(
                            padding: EdgeInsets.only(left: resWidth(18),right: 3),
                            child: Row(
                              children: [
                                Text(widget.lobbyModel.modeType!.toUpperCase(),
                                    style: whiteHeadingStyle40.copyWith(
                                        fontSize: 30)),
                                resWidthBox(23),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset(
                                          "assets/images/Game time.svg"),
                                      resWidthBox(4),
                                      Text(
                                        widget.lobbyModel.time!,
                                        style: whiteMiniText12,
                                      ),
                                      resWidthBox(15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          resHeightBox(20),

                          Container(
                            constraints: BoxConstraints(minHeight: resHeight((Get.height*0.75).toInt())),
                            // height: Get.height,
                            decoration: defaultCurveBoxDecoration,
                            padding: EdgeInsets.symmetric(
                                horizontal: resWidth(4), vertical: 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                resHeightBox(20),
                                _buildNumberContainer(),
                                resHeightBox(23),
                                _buildSearchersContainer(
                                    context,
                                    lobbyRoomController
                                        .newLobbyModel.searchers!.length),
                                resHeightBox(16),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: resWidth(12),
                                          vertical: resHeight(8)),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: greyLight20, width: 1)
                                        // gradient: LinearGradient(colors: [primaryColor1_Opacity10,primaryColor2_Opacity10]),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          headingHiders((lobbyRoomController
                                              .newLobbyModel.hiders!.length)
                                              .toString()),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemCount: (lobbyRoomController
                                                .newLobbyModel.hiders!.length),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // if (index == 0){
                                              //   return headingHiders((lobbyRoomController.newLobbyModel.hiders!.length ).toString());
                                              // }
                                              // if (index == 0){
                                              //   UserModel user;
                                              //   for (int i= 0; i<lobbyRoomController.newLobbyModel.hiders!.length; i++) {
                                              //     if (lobbyRoomController.newLobbyModel.hiders![i].email == widget.myUser.email){
                                              //       foundInHider = true;
                                              //       foundInHider = true;
                                              //       user = lobbyRoomController.newLobbyModel.hiders![i];
                                              //       return personRow(user);
                                              //     }
                                              //   }
                                              //
                                              // }

                                              return personRow(
                                                  lobbyRoomController
                                                      .newLobbyModel
                                                      .hiders![index],
                                                  last: index ==
                                                      (lobbyRoomController
                                                          .newLobbyModel
                                                          .hiders!
                                                          .length -
                                                          1));
                                            },
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 35,)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 27,
                    left: 0,
                    right: 0,
                    child: CustomAppBar(
                      leading: 'assets/images/Arrow.svg',
                      action: 'assets/images/info.svg',
                      isLeadingRec: true,
                      isActionName: false,
                      actionFunction: () async {
                        await showInfoMenu(context);
                      },
                      leadingFunction: () {
                        Get.back();
                      },
                    ),),
                Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: resWidth(13), right: resWidth(13)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => (lobbyRoomController.everyoneReady.value &&
                              (lobbyRoomController
                                  .newLobbyModel.hiders!.isNotEmpty &&
                                  lobbyRoomController
                                      .newLobbyModel.searchers!.isNotEmpty))
                              ? SvgPicture.asset("assets/images/Status.svg")
                              : Material(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius:
                                  BorderRadius.circular(25)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 25),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 25,width: 25,

                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  resWidthBox(20),
                                  Text(
                                    'Waiting all players',
                                    style: whiteNormalStyle20,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          resHeightBox(16),
                          Obx(() => Container(
                            child: lobbyRoomController.loading.value
                                ? SizedBox(
                              height: resHeight(45),
                              width: resHeight(45),
                              child: const CircularProgressIndicator(
                                color: primaryColor1,
                              ),
                            )
                                : CustomButton(
                              onPressed: lobbyRoomController.meReady.value ?
                                  () async{
                                lobbyRoomController.loading.value =
                                true;

                                lobbyRoomController.newLobbyModel =
                                    LobbyModel.fromJson(
                                        (await FirebaseFirestore
                                            .instance
                                            .collection('lobbies')
                                            .doc(
                                            lobbyRoomController
                                                .newLobbyModel
                                                .lobbyId
                                                .toString())
                                            .get())
                                            .data()!);

                                for (int i = 0;
                                i <
                                    lobbyRoomController
                                        .newLobbyModel
                                        .hiders!
                                        .length;
                                i++) {
                                  if (lobbyRoomController
                                      .newLobbyModel
                                      .hiders![i]
                                      .email ==
                                      widget.myUser.email) {

                                    lobbyRoomController
                                        .newLobbyModel
                                        .hiders![i]
                                        .isReady = false;
                                    lobbyRoomController
                                        .meReady.value = false;
                                    break;
                                  }
                                }


                                for (int i = 0;
                                i <
                                    lobbyRoomController
                                        .newLobbyModel
                                        .searchers!
                                        .length;
                                i++) {
                                  if (lobbyRoomController
                                      .newLobbyModel
                                      .searchers![i]
                                      .email ==
                                      widget.myUser.email) {

                                    lobbyRoomController
                                        .newLobbyModel
                                        .searchers![i]
                                        .isReady = false;
                                    lobbyRoomController
                                        .meReady.value = false;
                                    break;
                                  }
                                }

                                await lobbyRoomController
                                    .saveChanges();

                                if (mounted){
                                  setState(() {});
                                }

                                lobbyRoomController.loading.value =
                                false;


                              }
                                  : () async {
                                lobbyRoomController.loading.value =
                                true;
                                print(
                                    "lobby room on pressed loading started");
                                Position? locationData =
                                await LocationHelper
                                    .getLatestLocationData();
                                print("location fetched");

                                lobbyRoomController.newLobbyModel =
                                    LobbyModel.fromJson(
                                        (await FirebaseFirestore
                                            .instance
                                            .collection('lobbies')
                                            .doc(
                                            lobbyRoomController
                                                .newLobbyModel
                                                .lobbyId
                                                .toString())
                                            .get())
                                            .data()!);

                                print("latest lobby model fetched");

                                if (locationData != null) {
                                  for (int i = 0;
                                  i <
                                      lobbyRoomController
                                          .newLobbyModel
                                          .hiders!
                                          .length;
                                  i++) {
                                    if (lobbyRoomController
                                        .newLobbyModel
                                        .hiders![i]
                                        .email ==
                                        widget.myUser.email) {
                                      lobbyRoomController
                                          .newLobbyModel
                                          .hiders![i]
                                          .longitude =
                                          locationData.longitude;

                                      lobbyRoomController
                                          .newLobbyModel
                                          .hiders![i]
                                          .latitude =
                                          locationData.latitude;

                                      lobbyRoomController
                                          .newLobbyModel
                                          .hiders![i]
                                          .isReady = true;
                                      lobbyRoomController
                                          .meReady.value = true;
                                      break;
                                    }
                                  }

                                  for (int i = 0;
                                  i <
                                      lobbyRoomController
                                          .newLobbyModel
                                          .searchers!
                                          .length;
                                  i++) {
                                    if (lobbyRoomController
                                        .newLobbyModel
                                        .searchers![i]
                                        .email ==
                                        widget.myUser.email) {
                                      lobbyRoomController
                                          .newLobbyModel
                                          .searchers![i]
                                          .longitude =
                                          locationData.longitude;

                                      lobbyRoomController
                                          .newLobbyModel
                                          .searchers![i]
                                          .latitude =
                                          locationData.latitude;

                                      lobbyRoomController
                                          .newLobbyModel
                                          .searchers![i]
                                          .isReady = true;
                                      lobbyRoomController
                                          .meReady.value = true;
                                      break;
                                    }
                                  }

                                  await lobbyRoomController
                                      .saveChanges();
                                  lobbyRoomController.loading.value =
                                  false;
                                  if (mounted) {
                                    setState(() {
                                      print('setting state lobby room');
                                    });
                                  }
                                } else {
                                  lobbyRoomController.loading.value =
                                  false;
                                  print("location data is null");
                                }
                              },
                              text: lobbyRoomController
                                  .everyoneReady.value
                                  ? null
                                  : "Press Ready",
                              isDiabled:
                              lobbyRoomController.meReady.value,
                              isDisabledOnPressed: true,
                              child: lobbyRoomController.meReady.value
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  resWidthBox(16),
                                  Text(
                                    "I'm Ready",
                                    style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.9),
                                      fontSize: resWidth(20),
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  )
                                ],
                              )
                                  : null,
                            ),
                          )),
                        ],
                      ),
                    ))
              ],
            );
          }),
    );
  }

  Widget headingHiders(String length) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hiders,
              style: blackStyle24w700,
            ),
            resWidthBox(6),
            Padding(
              padding: EdgeInsets.only(bottom: resHeight(3)),
              child: Text(
                length,
                style: greyBoldStyle16,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        resHeightBox(10),
      ],
    );
  }

  Widget headingSearchers(String length) {
    return Row(
      children: [
        Text(
          searchersLobby,
          style: blackStyle24w700,
        ),
        resWidthBox(6),
        Text(
          length.toString(),
          style: greyBoldStyle20,
        ),
        const Spacer(),
        widget.join
            ? SizedBox()
            : InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(32))),
                  content: Builder(
                    builder: (context) {
                      lobbyRoomController.allUsers.clear();
                      lobbyRoomController.allUsers.addAll(
                          lobbyRoomController
                              .newLobbyModel.searchers!);
                      lobbyRoomController.allUsers.addAll(
                          lobbyRoomController.newLobbyModel.hiders!);

                      return ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(32)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            resHeightBox(10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
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
                                      color: Color.fromRGBO(
                                          63, 56, 49, 1.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // img==null?SizedBox():SvgPicture.asset("assets/images/Frame44.svg"),
                            // SvgPicture.asset("assets/images/verified.svg"),
                            Text(
                              "Pick Searchers",
                              style: darkHeadingStyle32,
                              textAlign: TextAlign.center,
                            ),
                            resHeightBox(16),
                            Text(
                              "Tap people who will search others",
                              style: greyDarkStyle16w400,
                            ),
                            resHeightBox(32),

                            SizedBox(
                              height: resHeight(300),
                              width: resWidth(300),
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: lobbyRoomController
                                      .allUsers.length,
                                  itemBuilder: (context, index) {
                                    return DialogPersonBox(
                                        userModel: lobbyRoomController
                                            .allUsers[index]);
                                  }),
                            ),

                            resHeightBox(32),

                            OutlineGradientButton(
                              gradient: const LinearGradient(
                                colors: [
                                  primaryColor1,
                                  primaryColor2
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                              strokeWidth: 2,
                              child: Container(
                                height: resHeight(40),
                                width: resWidth(283),
                                child: Center(
                                    child: gradientNormalStyle(
                                        "Random",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                              radius: Radius.circular(16),
                              onTap: () async {
                                Get.back();
                                await showQuantityDialog(
                                  context,
                                );
                              },
                            ),

                            resHeightBox(32),

                            Obx(() => Container(
                              child: lobbyRoomController
                                  .applyLoading.value
                                  ? SizedBox(
                                height: resHeight(45),
                                width: resHeight(45),
                                child:
                                const CircularProgressIndicator(
                                  color: primaryColor1,
                                ),
                              )
                                  : CustomButton(
                                onPressed: () async {
                                  await lobbyRoomController
                                      .saveChangesDialog();
                                  print("hi");
                                  Get.back();
                                },
                                text: "Apply",
                              ),
                            )),
                            resHeightBox(0),

                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SizedBox(
                                  height: resHeight(60),
                                  width: Get.width,
                                  child: Center(
                                    child: gradientNormalStyle(
                                      'Cancel',
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                  insetPadding:
                  EdgeInsets.symmetric(horizontal: resWidth(16)),
                  backgroundColor: Colors.white,
                ));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                addSearchers,
                style: greyMiniStyle14,
              ),
              resWidthBox(8),
              SvgPicture.asset("assets/images/charm_pencil.svg"),
            ],
          ),
        ),
      ],
    );
  }

  Widget personRow(UserModel userModel, {bool last = false}) {
    print("${userModel.name} ${userModel.isReady}");

    bool you = false;
    if (userModel.email == widget.myUser.email) {
      you = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        resHeightBox(2),
        Row(
          children: [
            // SvgPicture.asset(svgPath),
            you
                ? buildCrownAvatar(userModel.image!)
                : CircleAvatar(
             backgroundColor: Color(
    -202032),
                  backgroundImage: Image.asset(
              userModel.image!,
              width: resWidth(45),
              height: resHeight(45),
            ).image,
                ),
            resWidthBox(10),
            Text(
              userModel.name!,
              style: greyDarkStyle16,
            ),
            you
                ? Padding(
              padding: EdgeInsets.only(left: resWidth(6)),
              child: Text(
                "(you)",
                style: greyNormalStyle16,
              ),
            )
                : SizedBox(),
            const Spacer(),
            userModel.isReady!
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color: Color(0xff7ec056),
                ),
                resWidthBox(7),
                Text(
                  "Ready",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w400,
                      fontSize: resWidth(14)),
                )
              ],
            )
                : const SizedBox(),
          ],
        ),
        last
            ? SizedBox()
            :resHeightBox(10),
        last
            ? SizedBox()
            : const Divider(
          color: greyColor40,
          height: 15,
        ),
      ],
    );
  }

  Widget _buildNumberContainer() {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(
            ClipboardData(text: widget.lobbyModel.lobbyId.toString()));
        Get.snackbar("Success", "GameId Copied", backgroundColor: Colors.white);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                  colors: [primaryColor1_Opacity10, primaryColor2_Opacity10]),
            ),
            height: resHeight(64),
            width: resWidth(233),
            child: Center(
              child: gradientNormalStyle(widget.lobbyModel.lobbyId.toString(),
                  fontSize: 36, fontWeight: FontWeight.w700),
            ),
          ),
          resHeightBox(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copy,
                size: 13.33,
              ),
              resWidthBox(13),
              Text(
                tapToCopy,
                style: greyMiniStyle14,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchersContainer(BuildContext context, int count) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: resWidth(12), vertical: resHeight(10)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: whiteColorLight,
          border: Border.all(color: greyLight20, width: 1)
        // gradient: LinearGradient(colors: [primaryColor1_Opacity10,primaryColor2_Opacity10]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          headingSearchers(count.toString()),
          ListView.builder(
            padding: EdgeInsets.zero,

            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: lobbyRoomController.newLobbyModel.searchers!.length,
            itemBuilder: (context, index) {
              return personRow(
                  lobbyRoomController.newLobbyModel.searchers![index],
                  last: index ==
                      lobbyRoomController.newLobbyModel.searchers!.length - 1);
            },
          ),
        ],
      ),
    );
  }

  Future<void> showQuantityDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          content: Builder(
            builder: (context) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      resHeightBox(10),
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
                      // img==null?SizedBox():SvgPicture.asset("assets/images/Frame44.svg"),
                      // SvgPicture.asset("assets/images/verified.svg"),
                      Text(
                        "Searchers\nquantity",
                        style: darkHeadingStyle32,
                        textAlign: TextAlign.center,
                      ),
                      resHeightBox(16),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: resWidth(16)),
                        child: Text(
                            "How many searchers do you want to choose",
                            style: greyDarkStyle16w400,
                            textAlign: TextAlign.center),
                      ),
                      resHeightBox(32),

                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              primaryColor1,
                              primaryColor2,
                            ],
                          ),
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
                            padding: EdgeInsets.only(
                                left: resWidth(12), right: resWidth(22)),
                            child: Center(
                              child: TextFormField(
                                controller: lobbyRoomController
                                    .randomQuantityController,
                                validator: (value) {
                                  // if(value == null || value.isEmpty){
                                  //   return "Field Required";
                                  // }
                                },
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

                      Obx(() => Container(
                        child: lobbyRoomController.randomLoading.value
                            ? SizedBox(
                          height: resHeight(45),
                          width: resHeight(45),
                          child: const CircularProgressIndicator(
                            color: primaryColor1,
                          ),
                        )
                            : CustomButton(
                          onPressed: () async {
                            if (lobbyRoomController
                                .allUsers.length ==
                                1) {
                              Get.snackbar("Req Failed",
                                  "Minimum 2 users Required to play the game",
                                  backgroundColor: Colors.white);
                            } else if (int.parse(
                                lobbyRoomController
                                    .randomQuantityController
                                    .text) >
                                (lobbyRoomController
                                    .allUsers.length -
                                    1)) {
                              Get.snackbar("Req Failed",
                                  "Quantity can't be greater than ${lobbyRoomController.allUsers.length - 1}",
                                  backgroundColor: Colors.white);
                            } else {
                              await lobbyRoomController
                                  .selectAndSaveRandom();
                              Get.back();
                            }
                          },
                          text: "Apply",
                        ),
                      )),
                      resHeightBox(0),

                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SizedBox(
                            height: resHeight(60),
                            width: Get.width,
                            child: Center(
                              child: gradientNormalStyle(
                                'Cancel',
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
          backgroundColor: Colors.white,
        ));
  }
}

class DialogPersonBox extends StatefulWidget {
  const DialogPersonBox({required this.userModel});

  final UserModel userModel;

  @override
  State<DialogPersonBox> createState() => _DialogPersonBoxState();
}

class _DialogPersonBoxState extends State<DialogPersonBox> {
  LobbyRoomController lobbyRoomController = Get.find();
  bool selected = false;

  @override
  void initState() {
    selected = lobbyRoomController.newLobbyModel.searchers!
        .any((element) => element.email == widget.userModel.email);

    // widget.userModel.

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // selected = lobbyRoomController.newLobbyModel.searchers!.any((element) => element.email==widget.userModel.email);

        if (selected) {
          lobbyRoomController.newLobbyModel.searchers!.removeWhere(
                  (element) => element.email == widget.userModel.email);
          lobbyRoomController.newLobbyModel.hiders!.add(widget.userModel);
        } else {
          lobbyRoomController.newLobbyModel.searchers!.add(widget.userModel);
          lobbyRoomController.newLobbyModel.hiders!.removeWhere(
                  (element) => element.email == widget.userModel.email);
        }

        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: (!selected) ? greyLight20 : null,
          gradient: selected
              ? const LinearGradient(
            colors: [
              primaryColor1,
              primaryColor2,
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 8),
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
            padding: EdgeInsets.only(left: resWidth(12), right: resWidth(22)),
            child: Center(
              child: Row(
                children: [
                  // SvgPicture.asset(svgPath),
                  selected
                      ? buildSearcherAvatar(widget.userModel.image!)
                      : Image.asset(
                    widget.userModel.image!,
                    height: resHeight(48),
                    width: resWidth(48),
                  ),

                  resWidthBox(12),
                  Text(widget.userModel.name!),
                  Spacer(),
                  Image.asset(
                    selected
                        ? "assets/images/checked.png"
                        : "assets/images/unchecked.png",
                    height: resHeight(16),
                    width: resWidth(16),
                  )
                  // SvgPicture.asset("assets/images/checked.svg")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
