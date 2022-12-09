import 'package:flutter/material.dart';
import 'package:gottcha/utils/constants.dart';



class CustomButton extends StatelessWidget {
   const CustomButton({Key? key,this.isDiabled=false, required this.onPressed, this.text, this.child, this.textStyle, this.textColor, this.expanded = true, this.horMargin, this.height, this.backColor, this.width, this.borderSide,this.isDisabledOnPressed=false}) : super(key: key);

  final void Function() onPressed;
  final String? text;
  final Widget? child;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backColor;
  final bool isDiabled;

  final bool expanded;
  final double? horMargin;
  final double? height;
  final double? width;
  final BorderSide? borderSide;
  final bool isDisabledOnPressed;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horMargin ?? 0),
      child: Container(
        height: height ?? (expanded? resHeight(60) : resHeight(50)),
        width: width ?? (expanded ? double.infinity : resWidth(180)),
        color: isDiabled ? Colors.white : null,
        child: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(colors: [(isDiabled?primaryColor1.withOpacity(0.6):primaryColor1),isDiabled?primaryColor2.withOpacity(0.6):primaryColor2]),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: primaryColor1.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: ElevatedButton(

              onPressed: isDisabledOnPressed ? onPressed : (isDiabled?(){}:onPressed),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
                // backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                // side: borderSide,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
              )


            ),
              child: child ?? Text(text ?? "button text missing", style: textStyle ?? TextStyle(color: textColor ??(isDiabled?Colors.white.withOpacity(0.6): Colors.white), fontSize: resWidth(20), fontWeight: FontWeight.w600, ),),
          ),
        ),
      ),
    );
  }
}

