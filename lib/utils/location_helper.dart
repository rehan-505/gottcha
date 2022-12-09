import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationHelper{
  static Location location = Location();
  static Position? _locationData;


  static Future<Position?> getLatestLocationData()async{
    print("into getLatestLocationData");
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    print("checking if service enabled");


    serviceEnabled = await location.serviceEnabled();

    print("service enabled fetched");

    if (!serviceEnabled) {
      print("service not enabled, requesting service");

      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Req Failed", "Location Service Not Enabled", backgroundColor: Colors.white);
        print("service not enabled");

        return null;
      }
    }

    print("service enabled, checking permission");


    permissionGranted = await location.hasPermission();

    print("permission status fetched");

    if (permissionGranted == PermissionStatus.denied) {
      print("dont have permission, requesting permission");

      permissionGranted = await location.requestPermission();
      print("permission requested");

      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar("Req Failed", "Location Permission Not Granted", backgroundColor: Colors.white);
        print("location permission not given");

        return null;
      }
    }

    print("fetching latest location data");
 _locationData= await Geolocator.getCurrentPosition();
   
    print("latest location data fetched");

    return _locationData;
  }

  static Position? getPreviousLocationData(){
    return _locationData;
  }

}