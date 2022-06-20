import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

const kPrimaryColor = Color.fromRGBO(57, 127, 199, 1.0);
const kPrimaryLightColor = Color.fromRGBO(226, 237, 255, 1.0);
const kIconsTextColor = Color(0xFF5D4037);
const List<BoxShadow> shadow = [ BoxShadow(color: Colors.black26, offset: Offset(0,2), blurRadius: 2, spreadRadius: 0) ];

enum AccTypeEnum { client , worker }

enum CustomPickerFor {
  signUp,
  updateAcc,
  filterRes,
}

class TextsMenu {
  static const List items = <String>[home, logout,];
  static const String home = 'الرئيسية';
  static const String logout = 'تسجيل الخروج';
}

class IconsMenu {
static const items = <IconMenu>[home, logout,];
static const home = IconMenu(text: 'الرئيسية', icon: AntDesign.home,);
static const logout = IconMenu(text: 'تسجيل الخروج', icon: AntDesign.logout,);
}

class IconMenu {
  final String text;
  final IconData icon;
  const IconMenu({required this.text, required this.icon,});
}

BoxDecoration gradientBack(){
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromRGBO(36, 49, 120, 1.0), Color.fromRGBO(
          48, 129, 210, 1.0),],
      begin: FractionalOffset.bottomCenter,
      end: FractionalOffset.topCenter,
    ),
  );
}