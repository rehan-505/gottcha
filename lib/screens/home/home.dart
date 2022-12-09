import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gottcha/screens/auth/auth_controller.dart';
import 'package:gottcha/screens/creategame/creategame.dart';
import 'package:gottcha/screens/joingame/joingame.dart';
import 'package:gottcha/utils/constants.dart';
import 'package:gottcha/utils/remote_config.dart';
import 'package:gottcha/utils/text_constants.dart';
import 'package:gottcha/widgets/customappbar.dart';

class HomeScreen extends StatelessWidget {
HomeScreen({Key? key}) : super(key: key);
  RemoteConfigService? remoteConfigService;
  Future<bool> initializeRemoteConfig() async {
    try {
      print('remote testing');
      remoteConfigService = await RemoteConfigService.getInstance();
      await remoteConfigService!.initialize();
      print("hidermarkershow=================${remoteConfigService!.hider_marker_show}");
      print("debug=================${remoteConfigService!.debug}");
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: Get.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: SvgPicture.asset(
              "assets/images/homebackground.svg",
              width: Get.width,
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    resHeightBox(30),
                    CustomAppBar(
                      isleading: false,
                      leading: 'assets/images/user.svg',
                      action: 'assets/images/info.svg',
                      actionFunction: () async {

                        await showInfoMenu(context);
                      },
                      leadingFunction: () async {
                        // await showDialog(
                        //     context: context,
                        //     builder: (_) => AlertDialog(
                        //           shape: const RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.all(
                        //                   Radius.circular(32))),
                        //           contentPadding: const EdgeInsets.only(
                        //               top: 15.0, left: 15, right: 15),
                        //           content: Builder(
                        //             builder: (context) {
                        //               return ClipRRect(
                        //                 borderRadius: const BorderRadius.all(
                        //                     Radius.circular(0)),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     resHeightBox(5),
                        //                     Text(
                        //                       'You Want to Logout?',
                        //                       style: blackHeadingStyle32.copyWith(fontSize: 25),
                        //                       textAlign: TextAlign.center,
                        //                     ),
                        //                     resHeightBox(16),
                        //                     Padding(
                        //                       padding: const EdgeInsets.symmetric(vertical: 15.0),
                        //                       child: Row(
                        //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //                         children: [
                        //                           Material(
                        //                             shadowColor: primaryColor1
                        //                                 .withOpacity(0.3),
                        //                             color: Colors.white,
                        //                             elevation: 10,
                        //                             shape: RoundedRectangleBorder(
                        //                                 borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     12)),
                        //                             child: InkWell(onTap: (){Get.back();},
                        //                               child: Container(
                        //                                 padding:
                        //                                 EdgeInsets.symmetric(
                        //                                     vertical:
                        //                                     resHeight(16),
                        //                                     horizontal:
                        //                                     resWidth(16)),
                        //                                 width: resWidth(100),
                        //                                 height: resHeight(56),
                        //                                 child: Text(
                        //                                   'No',
                        //                                   style:
                        //                                   blackHeadingStyle32.copyWith(fontSize: 20,fontWeight: FontWeight.w300),
                        //                                   textAlign:
                        //                                   TextAlign.center,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           Material(
                        //                             shadowColor: primaryColor1
                        //                                 .withOpacity(0.3),
                        //                             color: Colors.white,
                        //                             elevation: 10,
                        //                             shape: RoundedRectangleBorder(
                        //                                 borderRadius:
                        //                                     BorderRadius.circular(
                        //                                         12)),
                        //                             child: InkWell(
                        //                               onTap: () async {
                        //                                 await AuthController().logoutAll();
                        //                               },
                        //                               child: Container(
                        //                                 padding:
                        //                                     EdgeInsets.symmetric(
                        //                                         vertical:
                        //                                             resHeight(16),
                        //                                         horizontal:
                        //                                             resWidth(16)),
                        //                                 width: resWidth(100),
                        //                                 height: resHeight(56),
                        //                                 child: Text(
                        //                                   'Leave Out',
                        //                                   style:
                        //                                       blackHeadingStyle32.copyWith(fontSize: 20),
                        //                                   textAlign:
                        //                                       TextAlign.center,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //           insetPadding: EdgeInsets.symmetric(
                        //               horizontal: resWidth(5)),
                        //           backgroundColor: Colors.white,
                        //         ));

                      },
                    ),
                    buildUpperLayer(),
                    const Spacer(),
                    _buildButtons(),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  buildUpperLayer() {
    return Column(
      children: [
        SvgPicture.asset('assets/images/logowithname.svg'),
        resHeightBox(20),
        Text(
          letPlay,
          style: darkGreyBoldStyle55,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  _buildButtons() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _customButton('assets/images/joinicon.svg', () {
                Get.to(() => JoinGameScreen());
              }, joinGame),
              _customButton('assets/images/creategameicon.svg', () {
                Get.to(() => CreateGameScreen());
              }, createGame),
            ],
          ),
        ),
        resHeightBox(30),
      ],
    );
  }

  _customButton(String img, VoidCallback function, String name) {
    return Column(
      children: [
        GestureDetector(
          onTap: function,
          child: Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(img,height: 120,width: 120,fit: BoxFit.fill,),
            ),
          ),
        ),
        resHeightBox(5),
        Text(
          name,
          style: whiteBoldStyle20,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
