import 'package:flutter/material.dart';

extension ChuChuCommonWidget on Widget {
  Widget setPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget setPaddingOnly({
    num left = 0.0,
    num top = 0.0,
    num right = 0.0,
    num bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: top.toDouble(),
        bottom: bottom.toDouble(),
        left: left.toDouble(),
        right: right.toDouble(),
      ),
      child: this,
    );
  }
}