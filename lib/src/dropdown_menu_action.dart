import 'package:flutter/material.dart';
class DropdownMenuAction {
  final String title;
  final Widget icon;
  final TextStyle titleStyle;
  final Function onTap;
  final bool isDivider;

  DropdownMenuAction({
    this.icon,
    this.onTap,
    this.title,
    this.titleStyle,
    this.isDivider = false,
  });
}

