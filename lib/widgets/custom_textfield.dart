
import 'package:flutter/material.dart';
import 'package:gottcha/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key,this.error=null, required this.hintText, required this.headingText, this.suffixIconData, this.validator,  this.textEditingController, this.obscureText = false, this.onSuffixIconTap, this.keyboardType}) : super(key: key);

  final IconData? suffixIconData;
  final String hintText;
  final String headingText;
  final String? Function(String?) ? validator;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final void Function()? onSuffixIconTap;
  final TextInputType? keyboardType;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Color.fromRGBO(63, 56, 49, 0.2)
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(headingText,style: blackNormalStyle16,),
          resHeightBox(12),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            cursorColor:primaryColor1.withOpacity(0.5) ,
            decoration: InputDecoration(
              errorText: error,

              suffixIcon: suffixIconData==null ? null : InkWell(
                onTap: onSuffixIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(suffixIconData, size: resWidth(24), color: greyColor40,),
                ),
              ),
              hintText: hintText,
              hintStyle: greyNormalStyle16,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(63, 56, 49, 0.2),
                  width: 1,
                )
              ),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:  primaryColor1.withOpacity(0.5),
                    width: 1,
                  )
              ),
              
              contentPadding: const EdgeInsets.only(left: 20, top: 13, bottom: 13),
            ),
            controller: textEditingController,
          ),
        ],
      ),
    );
  }
}
