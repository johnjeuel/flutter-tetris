import 'package:flutter/material.dart';

class SubBlock {
  int? x;
  int? y;
  Color? color;
  SubBlock(this.x, this.y, [Color color = Colors.transparent]) {
    this.color = color;
}
}