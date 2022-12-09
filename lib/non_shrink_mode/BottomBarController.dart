import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:gottcha/non_shrink_mode/no_shrink_mode.dart';
import '../utils/NoShrinkModeGlobals.dart';
import '../utils/constants.dart';

class BottomBarController extends GetxController{
  Rx<bool> loading = false.obs;


  Future gotchaOnPressed(UserModel myUser,UserModel otherUser,LobbyModel lobbyModel, BuildContext context) async{
    print("into gotcha");

    loading.value = true;
  double distance =  Geolocator.distanceBetween(myUser.latitude!, myUser.longitude!, otherUser.latitude!, otherUser.longitude!);
    int count = 0;

    print("distance $distance");

    if(distance<20){
    lobbyModel.hiders![lobbyModel.hiders!.indexWhere((element) => element.email==otherUser.email)].eliminated=true;
    for (var element in lobbyModel.hiders!) {
      if(!element.eliminated){
        count = count +1;
      }
    }

    await FirebaseFirestore.instance.collection('lobbies').doc(lobbyModel.lobbyId.toString()).update(
      {
        'hiders' : lobbyModel.hiders!.map((i) => i.toJson()).toList(),
        'gameFinished': count==0
      }
    );

    loading.value = false;


    if(!NoShrinkModeGobals.resultDialogsShown){
      NoShrinkModeGobals.showingDialog = true;
      await customDialog(context,
            img: 'assets/images/verified.svg',
            heading: "Success",
            body: Text(
              "You successfully found the player Kevin! Congratulations!\nThere are 4 players left.",
              style: darkGreyNormalStyle16,
              textAlign: TextAlign.center,
            ),
            buttonText: "Wohoo! Continue", function: () {
          Get.back();
          NoShrinkModeGobals.showingDialog = false;
        }, space: 32);
      }
    NoShrinkModeGobals.showingDialog = false;

    }
  else{
      loading.value = false;
      for (var element in lobbyModel.hiders!) {
        if(!element.eliminated){
          count = count +1;
        }
      }


      if(!NoShrinkModeGobals.resultDialogsShown){
        NoShrinkModeGobals.showingDialog = true;

        await customDialog(context,
            img: 'assets/images/errorsvg.svg',
            heading: "Oops",
            body: Text(
              "The players have slipped out of your hands! Try more to catch them.\nThere are $count players left.",
              style: darkGreyNormalStyle16,
              textAlign: TextAlign.center,
            ),
            buttonText: "Continue catching", function: () async {
          Get.back();
          NoShrinkModeGobals.showingDialog = false;
        }, space: 32);
      }

      NoShrinkModeGobals.showingDialog = false;


    }

  }

}