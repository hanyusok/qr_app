import 'package:flutter/material.dart';

class CustomStyle {
  /* 커스텀 ElevatedBtn 스타일*/
  ButtonStyle myBtnStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(350, 50),
      elevation: 2.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      )
  );

}