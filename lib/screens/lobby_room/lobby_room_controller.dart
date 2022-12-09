import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';

import '../../model/usermodel.dart';

class LobbyRoomController extends GetxController{
Rx<bool> loading = false.obs;
Rx<bool> applyLoading = false.obs;
Rx<bool> randomLoading = false.obs;
Rx<bool> meReady = false.obs;

TextEditingController randomQuantityController = TextEditingController();

List<UserModel> allUsers = [] ;

Rx<bool> everyoneReady = false.obs;
bool forwarded = false;

LobbyModel newLobbyModel;
LobbyRoomController(this.newLobbyModel);


Future<void> saveChanges( ) async{
  try{

    // LobbyModel lobbyModel = LobbyModel.fromJson((await FirebaseFirestore.instance.collection('lobbies').doc(newLobbyModel.lobbyId.toString()).get()).data()!);

    await FirebaseFirestore.instance.collection('lobbies').doc(newLobbyModel.lobbyId.toString()).set(newLobbyModel.toJson());
  }
  catch(e){
    print(e);
  }

}

Future<void> saveChangesDialog( ) async{
  applyLoading.value = true;
  try{
    await FirebaseFirestore.instance.collection('lobbies').doc(newLobbyModel.lobbyId.toString()).set(newLobbyModel.toJson());
  }
  catch(e){
    print(e);
  }
  applyLoading.value = false;

}

Future<void> selectAndSaveRandom( ) async{
  randomLoading.value = true;

  newLobbyModel.searchers!.clear();
  newLobbyModel.hiders!.clear();

  for (int i=0; i<int.parse(randomQuantityController.text); i++){
    newLobbyModel.searchers!.add(allUsers[Random().nextInt(allUsers.length)]);
  }

  for (var element in allUsers) {
    if(!(newLobbyModel.searchers!.any((user) => user.email==element.email))){
      newLobbyModel.hiders!.add(element);
    }
  }

  print("after randmization searchers length: ${newLobbyModel.searchers!.length}\nhiders length: ${newLobbyModel.hiders!.length} ");

  try{
    await FirebaseFirestore.instance.collection('lobbies').doc(newLobbyModel.lobbyId.toString()).set(newLobbyModel.toJson());
  }
  catch(e){
    print(e);
  }
  randomLoading.value = false;

}




}