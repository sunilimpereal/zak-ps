import 'package:flutter/material.dart';
import 'package:zak_mobile_app/constants.dart';
import 'package:zak_mobile_app/utility/colors.dart';

class ZAKTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final int maximumCharacters;
  final Function onChanged;
  final Color backgroundColor;
  final int maxLines;
  final Function validator;
  final bool isPhoneNumberField;
  final String information;
  final bool isOTP;
  final bool readOnly;
  final Function onTap;

  ZAKTextField({
    @required this.hintText,
    @required this.obscureText,
    this.keyboardType,
    @required this.controller,
    this.maximumCharacters,
    this.readOnly,
    this.onChanged,
    this.backgroundColor,
    this.maxLines,
    this.validator,
    this.isPhoneNumberField,
    this.information,
    this.onTap,
    this.isOTP = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ZAKGreen,
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: isOTP ? TextAlign.center : TextAlign.left,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines != null ? 3 : 1,
      validator: (text) {
        if (validator == null) {
          if (text.isEmpty) {
            return 'This field cannot be empty';
          } else {
            final numericRegularExpression = phoneNumberRegExp;
            if (isPhoneNumberField != null && isPhoneNumberField) {
              if (text.length != 10 ||
                  !numericRegularExpression.hasMatch(text)) {
                return 'Please enter a valid mobile number';
              }
            }
          }
        } else {
          return validator(text);
        }
        return null;
      },
      maxLength: isPhoneNumberField == null ? maximumCharacters ?? 250 : 10,
      controller: controller,
      readOnly: readOnly ?? false,
      obscureText: obscureText,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          errorStyle: TextStyle(fontSize: 13),
          contentPadding: EdgeInsets.all(0),
          focusColor: ZAKGreen,
          hoverColor: ZAKGreen,
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: ZAKGrey,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: ZAKGreen,
            ),
          ),
          errorMaxLines: 3),
    );
  }
}
