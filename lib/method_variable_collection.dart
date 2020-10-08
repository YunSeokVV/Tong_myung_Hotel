//이 파일은 프로젝트내에서 사용될 함수를 모아놓은 파일이다.

import 'package:flutter/cupertino.dart';

  double getWidthRatio(double width, context){
    double phonewidth = MediaQuery.of(context).size.width;
    double widthRatio = phonewidth/width;

    return widthRatio;
  }

  double getHeightRatio(double height, context){
    double phoneheight = MediaQuery.of(context).size.height;
    double heightRatio = phoneheight/height;
    return heightRatio;
  }



  class Variable{

    //예약하기기능에서 사용자선택한 숙박방식(호텔식 or 모텔식)
    static String sleep_type="nothing";


    //사용자가 묶을 숙소를 호텔형태로 설정한다.
    void Sleep_Hotel() {
      sleep_type="Hotel";
    }

    //사용자가 묶을 숙소를 모텔형태로 설정한다.
    void Sleep_Guest_house() {
      sleep_type="Guest_House";
    }

  }




