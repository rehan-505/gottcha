import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gottcha/screens/auth/auth_controller.dart';
import 'package:gottcha/screens/auth/forgot_password.dart';
import 'package:gottcha/screens/auth/login.dart';
import 'package:flutter/services.dart';
import 'package:gottcha/screens/auth/sign_up.dart';
import 'package:gottcha/screens/begin_game/begin_game.dart';
import 'package:gottcha/screens/home/home.dart';
import 'package:gottcha/utils/location_helper.dart';
import 'package:location/location.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // LocationData? locationData = await LocationHelper.getLatestLocationData();

  // if(locationData!=null) {
  //   runApp(const MyApp());
  // }

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: 'Gottcha',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        scaffoldBackgroundColor: Color.fromRGBO(255, 247, 236, 1)

      ),
      home: authWrapper(),
    );
  }
}

Widget authWrapper() {
  AuthController _con=Get.put(AuthController());
  print("current user id: ${FirebaseAuth.instance.currentUser?.uid}");
  if(FirebaseAuth.instance.currentUser==null) {
   _con.signInAnonymously();
    return HomeScreen();
  }
  else{
    return HomeScreen();
  }
}
