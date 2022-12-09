import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {Key? key,
      this.leading,
      this.action,
      this.isActionName = true,
      this.isLeadingRec = false,
        this.isleading=true,
      this.actionFunction,
        this.title,
      this.leadingFunction})
      : super(key: key);
  Widget? title;
  String? leading;
  String? action;
  bool isActionName;
  bool isLeadingRec;
  bool isleading;
  VoidCallback? leadingFunction;
  VoidCallback? actionFunction;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isleading?Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: leadingFunction,
            child: Material(
              shadowColor: primaryColor1.withOpacity(0.3),
              color: Colors.white,
              elevation: 10,
              shape: isLeadingRec
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))
                  : const CircleBorder(),
              child: Container(

                padding:  EdgeInsets.symmetric(vertical: resHeight(16),horizontal: resWidth(16)),
                width: resWidth(56),
                height: resHeight(56),
                child: SvgPicture.asset(leading!),
              ),
            ),
          ),
        ):SizedBox(),
        title==null?SizedBox():title!,
        action == null
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    isActionName?Text(
                      'Game info',
                      style: darkGreyBoldStyle16,
                    ):SizedBox(),
                    resWidthBox(10),
                    GestureDetector(
                      onTap: actionFunction,
                      child: Material(
                        color: Colors.white,

                        shadowColor: primaryColor1.withOpacity(0.3),
                        elevation: 10,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(

                          padding:  EdgeInsets.symmetric(vertical: resHeight(10),horizontal: resWidth(10)),
                          width: resWidth(56),
                          height: resHeight(56),
                          child: SvgPicture.asset(action!),
                        ),
                      ),
                    )
                  ],
                ),
              )
      ],
    );
  }
}
