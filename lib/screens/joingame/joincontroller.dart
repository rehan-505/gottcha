import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gottcha/model/lobbymodel.dart';
import 'package:gottcha/model/usermodel.dart';
import 'package:gottcha/screens/lobby_room/lobby_room.dart';

class JoinGameSettingController extends GetxController{
  List<String> avatar=['assets/images/avatar1.png','assets/images/avatar2.png','assets/images/avatar3.png','assets/images/avatar4.png','assets/images/avatar5.png','assets/images/avatar6.png','assets/images/avatar7.png','assets/images/avatar8.png',];
  Rx<String> selectedAvatar='assets/images/avatar1.png'.obs;
  final GlobalKey<FormState> formIdKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formNameKey = GlobalKey<FormState>();
  TextEditingController lobbyId=TextEditingController();
  TextEditingController lobbyName=TextEditingController();
  var loading=false.obs;
  LobbyModel? lobbyModel;
  var error=false.obs;

  Future<void> enterLobby() async {
    print("entered into lobby function");
    loading.value=true;
    if(formIdKey.currentState!.validate() && formNameKey.currentState!.validate()){
      UserModel myUser=UserModel(
        name: lobbyName.text,
        image: selectedAvatar.value,
        email: FirebaseAuth.instance.currentUser!.email,
        isReady: false,

      );

      print("updating document hiders array");
      print(lobbyId.text);

      await FirebaseFirestore.instance.collection('lobbies').doc(lobbyId.text).update({"hiders": FieldValue.arrayUnion([myUser.toJson()])});
      print("success, returning");


      loading.value=false;
      Get.to(()=>LobbyRoomScreen(lobbyModel: lobbyModel!,myUser: myUser,join:true));
      return;
    }
    loading.value=false;
    return;
  }

  Future<bool> checkIfDocExists() async {
    loading.value=true;
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('lobbies');
      print(lobbyId.text);

      DocumentSnapshot<Map<String,dynamic>> doc = await collectionRef.doc(lobbyId.text).get();

      print("document fetched");

      if (doc.exists) {
        print("document exists");

        lobbyModel=LobbyModel.fromJson(doc.data()!);
        loading.value=false;
        print("returning");

        return true;
      }
      else {
        loading.value=false;
        return false;
      }

    } catch (e) {
      loading.value=false;
      throw e;
    }
  }
}
