import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:gottcha/screens/creategame/creategamecontroller.dart';
import 'package:gottcha/screens/lobby_room/lobby_room.dart';

class CreateGameSettingController extends GetxController {
  var loading= false.obs;

  ///Dont Change these strings or change the strings in constants also
  List<String> time = [
    '30 mins',
    '60 mins',
    '90 mins',

  ];

  Rx<String> selectedTime = '0'.obs;
  Rx<String> tempSelectedTime = '0'.obs;
  List<String> area = ['1 Km', '2 Km', '5 Km', '10 Km', '15 Km', '20 Km'];
  Rx<String> selectedArea = '0'.obs;
  Rx<String> tempSelectedArea = '0'.obs;
  List<String> avatar = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png'
  ];

  Rx<String> tempSelectedAvatar = '0'.obs;
  Rx<String> selectedAvatar = 'assets/images/avatar1.png'.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController customArea = TextEditingController();
  var customAreaValue=''.obs;
  CreateGameController gameController = Get.put(CreateGameController());
  var shrinked = false.obs;
  var selected = 0.obs;
  @override
  void onInit() {
    selected.value = gameController.selected.value;
    shrinked.value = gameController.selected.value == 1 ? true : false;
    super.onInit();
  }

  createGame() async {
    loading.value=true;
    if (selectedTime.value == '0') {
      Get.snackbar('Error', 'Please select time', backgroundColor: Colors.white);
    }  else if (formKey.currentState!.validate()) {
      print( gameController.selected.value );
      UserModel myUser = UserModel(
          name: userNameController.text,
          image: selectedAvatar.value,
          email: FirebaseAuth.instance.currentUser!.email,
      isReady: false,);
      LobbyModel lobby = LobbyModel(
          time: selectedTime.value,
          area: selectedArea.value,
          searchers: [],
          hiders: [myUser],
          lobbyId: (10000000 + Random().nextInt(99999999 - 10000000)),
          modeType:
              gameController.selected.value == 1 ? 'shrink' : 'nonshrink');
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(lobby.lobbyId.toString())
          .set(lobby.toJson());
      Get.to(() => LobbyRoomScreen(lobbyModel: lobby,myUser: myUser,));
    }

    loading.value=false;
  }
}