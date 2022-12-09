import 'dart:async';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:ui' as ui;
import '../../model/lobbymodel.dart';
import '../../model/usermodel.dart';
import 'package:location/location.dart';

import '../../utils/constants.dart';

class HiderGameSettingController extends GetxController {
  var timeValue = 0.obs;
  bool setMap = false;
  bool setTimer=false;
  List<Marker> markers = <Marker>[].obs;

  LobbyModel? data;
  StreamSubscription? streamSubscription;
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  Completer<GoogleMapController> controller = Completer();
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );
  final stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown
  );

  timerSetup(int minutes,BuildContext context) async {
    stopWatchTimer.setPresetSecondTime((60 * minutes));
    stopWatchTimer.secondTime.listen((value) {
      timeValue.value = value;
      // print(value);
    });
    stopWatchTimer.onStartTimer();
    // await timerDialog(context, minutes);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
          '', 'Location services are disabled. Please enable the services', backgroundColor: Colors.white);

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location permissions are denied', backgroundColor: Colors.white);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('',
          'Location permissions are permanently denied, we cannot request permissions.', backgroundColor: Colors.white);
      return false;
    }
    return true;
  }

  Future<bool> setMarkers() async {
    markers.clear();
    print('///////////////////////////');
    UserModel? userData = data!.hiders!.where((element) =>
    element.email == FirebaseAuth.instance.currentUser!.email).isEmpty
        ? null
        : data!.hiders!.firstWhere((element) =>
    element.email == FirebaseAuth.instance.currentUser!.email);
    if (userData != null) {
      final BitmapDescriptor markerIcon = await createCustomMarkerBitmap('you',path:
          userData.image!.replaceAll(RegExp('avatar'), "avatar_pin"), );
      print('markerrrrrrrrr');
      markers.add(
          Marker(
            markerId: MarkerId("user"),
            position: LatLng(userData.latitude!, userData.longitude!),
            icon:markerIcon,
            infoWindow: InfoWindow(title: "You")
          ));

    }


    return true;

  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer
        .asUint8List();
  }
  Future<BitmapDescriptor> createCustomMarkerBitmap(String title,
      {required String path,
        }) async {
    TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.red, fontSize: 25,),
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
    ui.Codec codec = await ui.instantiateImageCodec(
        dataimg.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo fi=await codec.getNextFrame();
    canvas.drawImage( fi.image,Offset(0, 55),Paint());

    ui.Picture p = pictureRecorder.endRecording();

    ByteData? pngBytes = await (await p.toImage(
        painter.width.toInt() + 100, painter.height.toInt() + 140))
        .toByteData(format: ui.ImageByteFormat.png);
    Uint8List data = Uint8List.view(pngBytes!.buffer);
    return BitmapDescriptor.fromBytes(data);
  }










  Future<void> updateMyLocation() async {
    print("hider location updated");
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Req Failed", "Location Service Not Enabled", backgroundColor: Colors.white);
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar("Req Failed", "Location Permission Not Granted", backgroundColor: Colors.white);
        return;
      }
    }


    // googleMapController ??= await controller.future;

    location.changeSettings(interval: 10000,);
    LocationData? locationData;

    streamSubscription = location.onLocationChanged.listen((location) async {

      if (cancelStream){
        await streamSubscription?.cancel();
        return;
      }


      locationData = location;
      if (checkIsHider()) {
        // int i = latestLobbyModel!.hiders!.indexWhere((element) => element.email==FirebaseAuth.instance.currentUser!.email);


        for (var element in data!.hiders!) {
          if (element.email == FirebaseAuth.instance.currentUser!.email) {
            element.latitude = location.latitude;
            element.longitude = location.longitude;
            break;
          }
        }
      }
      else {
        for (var element in data!.searchers!) {
          if (element.email == FirebaseAuth.instance.currentUser!.email) {
            element.latitude = location.latitude;
            element.longitude = location.longitude;
            break;
          }
        }
      }

      if (checkIsHider()) {
        await FirebaseFirestore.instance.collection('lobbies').doc(
            data!.lobbyId!.toString()).update(
            {
              'hiders': data!.hiders!.map((i) => i.toJson())
                  .toList()
            }
        );
      }
      else {
        await FirebaseFirestore.instance.collection('lobbies').doc(
            data!.lobbyId!.toString()).update(
            {
              'searchers':data!.searchers!.map((i) => i.toJson())
                  .toList()
            }
        );
      }
    }, cancelOnError: false, onError: (v) {
      print("error in location update");
      print(v);
    });
  }

  bool checkIsHider(){
    return data!.hiders!.any((element) => element.email==FirebaseAuth.instance.currentUser!.email);
  }
  timerDialog(BuildContext context,int minutes) async {
    await customDialog(context,
        function: () {},
        buttonText: 'I got it',
        heading: 'Timer Started',
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'You have $minutes minutes to hide from your searchers.',
              style: darkGreyNormalStyle20,
              textAlign: TextAlign.center,
            )));
  }

  bool cancelStream = false;


  GoogleMapController? mapController;

  moveMap() async {
    print(data!.toJson().toString());
    // GoogleMapController con=await controller.future;
    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(data!.mapLat!, data!.mapLng!),
      zoom: data!.mapZoom!,
    )));
  }

  @override
  void dispose() async{
    await streamSubscription!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

}

