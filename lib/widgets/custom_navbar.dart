// import 'package:gottcha/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class CustomNavBar extends StatefulWidget {
//   const CustomNavBar({Key? key}) : super(key: key);
//
//   @override
//   State<CustomNavBar> createState() => _CustomNavBarState();
// }
//
// class _CustomNavBarState extends State<CustomNavBar> {
//
//   int currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 65,
//       // color: greyColor,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//         color: greyColor
//       ),
//       child: Padding(
//         padding:  EdgeInsets.only(left: resWidth(23), right: resWidth(23), bottom: resHeight(20), top: resHeight(20)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Icon(Icons.home, size: 35,),
//             Icon(Icons.chat_bubble, size: 32),
//             Icon(Icons.search, size: 35),
//             Icon(Icons.notifications, size: 35),
//             Icon(Icons.person, size: 35)
//             // SvgPicture.asset("assets/icons/home.svg", color: currentIndex==0 ? secondaryColor : null,),
//             // SvgPicture.asset("assets/icons/Chat.svg", color: currentIndex==1 ? secondaryColor : null),
//             // SvgPicture.asset("assets/icons/search.svg", color: currentIndex==2 ? secondaryColor : null),
//             // SvgPicture.asset("assets/icons/bell.svg", color: currentIndex==3 ? secondaryColor : null),
//             // SvgPicture.asset("assets/icons/person.svg", color: currentIndex==4 ? secondaryColor : null),
//           ],
//         ),
//       ),
//     );
//   }
// }
