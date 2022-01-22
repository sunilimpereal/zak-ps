import 'package:flutter/material.dart';

extension AddStyle on String {
  Text withStyle(
      {Color color = Colors.black,
      @required TextStyle style,
      bool overflow = false,
      TextAlign textAlign}) {
    return Text(
      this,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          letterSpacing: style.letterSpacing),
      overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }
}
