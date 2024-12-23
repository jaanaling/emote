import 'package:flutter/cupertino.dart';



double getWidth(double percent, BuildContext context){
  return MediaQuery.of(context).size.width * percent;
}

double getHeight(double percent, BuildContext context){
  return MediaQuery.of(context).size.height * percent;
}

bool isIpad (BuildContext context){
  return MediaQuery.of(context).size.shortestSide >= 600;
}