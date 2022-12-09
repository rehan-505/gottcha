// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gottcha/model/lobbymodel.dart';
// import 'package:gottcha/model/usermodel.dart';
// import 'package:gottcha/shrink_mode/shrink_mode_controller.dart';
// import 'package:gottcha/utils/constants.dart';
// import 'package:gottcha/utils/text_constants.dart';
// import 'package:gottcha/widgets/custom_button.dart';
//
// import 'package:gottcha/widgets/customappbar.dart';
//
// import '../non_shrink_mode/no_shrink_mode.dart';
//
// class ShrinkMode extends StatelessWidget {
//   bool hiderPage;
//   ShrinkMode({Key? key, this.hiderPage = false}) : super(key: key);
//
//
//
//   final ShrinkModeController _controller = Get.put(ShrinkModeController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: backgroundColor,
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Positioned.fill(
//               bottom: 0,
//               child: GoogleMap(
//                 zoomGesturesEnabled: true,
//                 zoomControlsEnabled: false,
//                 scrollGesturesEnabled: false,
//                 mapType: MapType.normal,
//                 initialCameraPosition: _controller.kGooglePlex,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.controller.complete(controller);
//                 },
//               ),
//             ),
//             Positioned.fill(
//               top: 0,
//               left: 0,
//               child: true
//                   ? Image.asset(
//                       "assets/images/areaarea3.png",
//                       width: Get.width,
//                       fit: BoxFit.fill,
//                     )
//                   : SvgPicture.asset(
//                       'assets/images/areaarea2.svg',
//                       width: Get.width,
//                       fit: BoxFit.fill,
//                     ),
//             ),
//             // Positioned(
//             //   top: 210,
//             //   // left: 0,
//             //   child: true ? Image.asset("assets/images/Ellipse 6inner_circle.png",
//             //     fit: BoxFit.fill,
//             //   ) : SvgPicture.asset(
//             //     'assets/images/areaarea2.svg',
//             //     width: Get.width,
//             //     fit: BoxFit.fill,
//             //   ),
//             // ),
//             Positioned(
//               top: resHeight(291),
//               // left: 0,
//               // bottom: 0,
//               // right: 0,
//               child: Align(child: Image.asset("assets/images/avatar.png")),
//             ),
//
//             Positioned(
//               top: resHeight(180),
//               left: resWidth(80),
//               // bottom: 0,
//               // right: 0,
//               child: nameAndAvatar("Diana", "assets/images/Group 26map_mark.png"),
//             ),
//
//             Positioned(
//               top: resHeight(180),
//               right: resWidth(80),
//               // bottom: 0,
//               // right: 0,
//               child: nameAndAvatar("Diana", "assets/images/Group 26map_mark.png"),
//             ),
//
//             Positioned(
//               top: resHeight(360),
//               right: resWidth(80),
//               // bottom: 0,
//               // right: 0,
//               child: nameAndAvatar("Dimitri", "assets/images/Group 26map_mark.png"),
//             ),
//
//             Positioned(
//               top: resHeight(350),
//               left: resWidth(70),
//               // bottom: 0,
//               // right: 0,
//               child: nameAndAvatar("Jon", "assets/images/avatar.png"),
//             ),
//
//
//
//
//             Positioned(bottom: resHeight(250), child: _buildContainersRow()),
//             // Positioned(
//             //     right: resWidth(85),
//             //     left: resWidth(85),
//             //     bottom: resHeight(240),
//             //     child: customToastContainer(false
//             //         ? "Make sure that everyone is hidden\nand start the game!"
//             //         : "The game has begun")),
//             Scaffold(
//               backgroundColor: Colors.transparent,
//               body: SizedBox(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: CustomAppBar(
//                         isActionName: false,
//                         isLeadingRec: true,
//                         leading: 'assets/images/Vector@2x.svg',
//                         action: 'assets/images/info.svg',
//                         title: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           padding: EdgeInsets.all(8),
//                           child: Column(
//                             children: [
//                               Text(
//                                 'Hiding Time',
//                                 style: blackNormalStyle16,
//                               ),
//                               Obx(() => Text(
//                                     _controller.timeValue.value <= 60
//                                         ? '00:${_controller.timeValue.value}'
//                                         : '${((_controller.timeValue.value) / 60).toInt()}:${(_controller.timeValue.value) % 60}',
//                                     style: blackBoldStyle16,
//                                   ))
//                             ],
//                           ),
//                         ),
//                         actionFunction: () async {
//                           await customDialog(context,
//                               heading: gameInfo,
//                               body: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     searchers,
//                                     style: darkGreySemiBoldStyle20,
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   resHeightBox(10),
//                                   Text(
//                                     searcherInfo,
//                                     style: darkGreyNormalStyle16,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   resHeightBox(10),
//                                   Text(
//                                     hider,
//                                     style: darkGreySemiBoldStyle20,
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   resHeightBox(10),
//                                   Text(
//                                     hiderInfo,
//                                     style: darkGreyNormalStyle16,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   resHeightBox(10),
//                                 ],
//                               ),
//                               buttonText: infoButtonText, function: () {
//                             Get.back();
//                           });
//                         },
//                         leadingFunction: () async {
//                           // await disConnectGame();
//                           _controller.timerSetup();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               ///Dummy Models Passed
//
//               bottomNavigationBar: BottomBar(
//                 hiderPage: hiderPage,
//                 userModels: [], myUser: UserModel(), lobbyModel: LobbyModel(),
//               ),
//             )
//           ],
//         ),
//       ),
//       // bottomNavigationBar: BottomBar(),
//     );
//   }
//
//
//   timerDialog(BuildContext context) async {
//     await customDialog(context,
//         function: () {},
//         buttonText: 'I got it',
//         heading: 'Timer Started',
//         body: Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               'You have 15 minutes to hide from your searchers.',
//               style: darkGreyNormalStyle20,
//               textAlign: TextAlign.center,
//             )));
//   }
//
//
//
//   blueContainer({bool win = true}) {
//     return Container(
//       decoration: BoxDecoration(
//           color: lightBlue,
//           border:
//               Border.all(color: Color.fromRGBO(255, 255, 255, 0.44), width: 3),
//           borderRadius: BorderRadius.circular(6)),
//       padding: EdgeInsets.symmetric(
//           horizontal: resWidth(12), vertical: resHeight(12)),
//       child: Text(
//         win
//             ? "Prototype action:\nEnd match (WIN)"
//             : "Prototype action:\nEnd match (LOSE)",
//         style: whiteMiniText12,
//       ),
//     );
//   }
//
//   _buildContainersRow() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         blueContainer(),
//         resWidthBox(19),
//         blueContainer(win: false),
//       ],
//     );
//   }
//
//   Widget nameAndAvatar(String name, String pngPath){
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Color.fromRGBO(75, 17, 45, 0.6),
//               borderRadius: BorderRadius.circular(24)
//           ),
//           padding: EdgeInsets.symmetric(horizontal: resWidth(8),vertical: resHeight(4)),
//           child: Text(name, style: whiteText14w600, ),
//         ),
//         SizedBox(height: resHeight(11),),
//         Image.asset(pngPath)
//       ],
//     );
//   }
//
//
// }
