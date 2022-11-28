import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grapher_user_draw/draw_tools/path_tool.dart';

class DrawToolTester extends PathTool {
  @override
  int maxLength = 3;

  @override
  Paint paint = Paint()
    ..color = Colors.lightBlue
    ..strokeWidth = 2;

  DrawToolTester();
}
