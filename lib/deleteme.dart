// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:gottcha/widgets/custom_button.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
//
// const Color primaryColor1 = Color.fromRGBO(255, 117, 39, 1);
// const Color primaryColor2 = Color.fromRGBO(255, 51, 137, 1);
// const Color backgroundColor = Color.fromRGBO(245, 245, 245, 1.0);
// const Color greyColor = Color.fromRGBO(63, 56, 49, 0.6);
// const Color greyColorDark = Color.fromRGBO(63, 56, 49, 1);
//
// const Color greyColor40 = Color.fromRGBO(63, 56, 49, 0.4);
//
// Widget gradientNormalStyle16(String text){
//   return GradientText(
//     text,
//     style:  TextStyle(
//         fontSize: resWidth(16),
//         fontWeight: FontWeight.w600
//     ),
//     colors: const [
//       primaryColor1,
//       primaryColor2
//     ],
//   );
// }
//
// ///black COlor Style
//
// final TextStyle blackHeadingStyle40 = TextStyle(
//     fontSize: resWidth(40),
//     fontWeight: FontWeight.w800,
//     color: Colors.black
// );
//
// final TextStyle blackHeadingStyle32 = TextStyle(
//     fontSize: resWidth(32),
//     fontWeight: FontWeight.w800,
//     color: Colors.black
// );
//
//
// final TextStyle blackNormalStyle16 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w500,
//     color: Colors.black
// );
// final TextStyle blackBoldStyle16 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w900,
//     color: Colors.black
// );
//
// final TextStyle blackNormalStyle16w400 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w400,
//     color: Colors.black
// );
//
// /// Grey COlor Style
//
// final TextStyle greyNormalStyle16 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w400,
//     color: greyColor
// );
//
// final TextStyle greyBoldStyle16 = TextStyle(
//   fontSize: resWidth(16),
//   fontWeight: FontWeight.w700,
//   color: greyColor,
//   // decoration: TextDecoration.underline,
// );
//
// ///Dark Grey COlor Style
// final TextStyle darkGreyNormalStyle16 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w400,
//     color: greyColorDark
// );
// final TextStyle darkGreyBoldStyle16 = TextStyle(
//     fontSize: resWidth(16),
//     fontWeight: FontWeight.w900,
//     color: greyColorDark
// );
//
// final TextStyle darkGreyNormalStyle20 = TextStyle(
//     fontSize: resWidth(20),
//     fontWeight: FontWeight.w400,
//     color: greyColorDark
// );
// final TextStyle darkGreySemiBoldStyle20 = TextStyle(
//     fontSize: resWidth(20),
//     fontWeight: FontWeight.w700,
//     color: greyColorDark
// );
// final TextStyle darkGreyBoldStyle45 = TextStyle(
//     fontSize: resWidth(45),
//     fontWeight: FontWeight.w900,
//     color: greyColorDark
// );
// final TextStyle darkGreyBoldStyle55 = TextStyle(
//     fontSize: resWidth(55),
//     fontWeight: FontWeight.w900,
//     color: greyColorDark
// );
//
//
//
// ///white COlor Style
//
// final TextStyle whiteBoldStyle20 = TextStyle(
//   fontSize: resWidth(20),
//   fontWeight: FontWeight.w900,
//   color: Colors.white,
//   // decoration: TextDecoration.underline,
// );
// final TextStyle whiteBoldStyle24 = TextStyle(
//   fontSize: resWidth(24),
//   fontWeight: FontWeight.w900,
//   color: Colors.white,
//   // decoration: TextDecoration.underline,
// );
//
// final TextStyle whiteNormalStyle20 = TextStyle(
//   fontSize: resWidth(20),
//   fontWeight: FontWeight.w400,
//   color: Colors.white,
//   // decoration: TextDecoration.underline,
// );
// final TextStyle whiteNormalStyle16 = TextStyle(
//   fontSize: resWidth(16),
//   fontWeight: FontWeight.w400,
//   color: Colors.white,
//   // decoration: TextDecoration.underline,
// );
// final TextStyle whiteBoldStyle16 = TextStyle(
//   fontSize: resWidth(16),
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
//   // decoration: TextDecoration.underline,
// );
//
//
// const BoxDecoration defaultCurveBoxDecoration = BoxDecoration(
//   color: Colors.white,
//   borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
// );
//
//
//
//
// double resWidth(int width){
//   return Get.width*(width/375);
// }
//
// SizedBox resWidthBox(int width){
//   return SizedBox(width: Get.width*(width/375),);
// }
//
// double resHeight(int height){
//   return Get.height*(height/812);
// }
//
// SizedBox resHeightBox(int height){
//   return SizedBox(
//     height: Get.height*(height/812),
//   );
//
// }
//
//
//
// cutsomDialog(BuildContext context, {String? img,String? buttonText,VoidCallback? function, required String heading, required Widget body}) async {
//   await showDialog(
//       context: context,
//       builder: (_) =>  AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(32))
//         ),
//         content: Builder(
//           builder: (context) {
//             return ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(32)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   resHeightBox(30),
//                   img==null?SizedBox():SvgPicture.asset(img),
//                   // SvgPicture.asset("assets/images/verified.svg"),
//                   Text(heading, style: blackHeadingStyle32, textAlign: TextAlign.center,),
//                   resHeightBox(16),
//                   body,
//                   buttonText==null?SizedBox():Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: CustomButton(
//                       onPressed: function!,
//                       text: buttonText,
//                     ),
//                   )
//
//                 ],
//               ),
//             );
//           },
//         ),
//         insetPadding: EdgeInsets.symmetric(horizontal: resWidth(16)),
//         backgroundColor: Colors.white,
//
//       )
//   );
// }