//이 파일은 사용자가 호텔식으로 예약할지 모텔식으로 예약할지 선택할 수 있게끔 해주는 UI와 기능을 제공해주는 파일이다.

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';
import 'package:tong_myung_hotel/screen/book_screens/select_booking_condition.dart';
import 'dart:convert';

class Hotel_motel_choice extends StatelessWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  const Hotel_motel_choice(
      {Key key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      home: Hotel_motel_choice_(),
    );
  }
}

class Hotel_motel_choice_ extends StatefulWidget {

  @override
  _Hotel_motel_choice_State createState() => _Hotel_motel_choice_State();
}

class _Hotel_motel_choice_State extends State<Hotel_motel_choice_> {
  Variable variable=new Variable();

  @override
  void initState() {
    super.initState();

    print("initState 메소드 호출");
//    String myName = "domanokz";
//    String newName = myName.substring(0,4)+'x'+myName.substring(5);
//    print(myName);
//    print(newName);

//    final Map<String, String> someMap = {
//
//    };
//
//    someMap["a"] = "1";
//    someMap["b"] = "2";
//    someMap["c"] = "3";



//    print("시발");
//    print(someMap.length);
//    print("시발2");
//    someMap.forEach((k,v) => print('${k}: ${v}'));
//    print("시발3");



//    List<String> list = ["1","2"];
//    list.add("3");
//    print(list);
//   // print(list[2]);
//
//    if(list.contains("ㅋㅋ")){
//      print("이새기 있다");
//    }
//    else{
//      print("이새기 없다");
//    }

  }


  @override
  Widget build(BuildContext context) {

    Book_room_stful book_room;

    //어떤 핸드폰에서든지 위젯의 위치가 똑같은 위치에 보이게끔 구현하기위해서 각 위젯들의 위치를 핸드폰의 전체비율에 따라 설정하기위해 아래 두 변수는 존재한다.
    double wi = MediaQuery.of(context).size.width;//핸드폰의 너비 Get
    double hi = MediaQuery.of(context).size.height;//핸드폰의 높이 Get


    double a=wi*1.4388888;
    double b=hi/2.9606299;

    //전체 Container
    double width=getWidthRatio(360,context);
    double height=getHeightRatio(752,context);


    return
      SingleChildScrollView(
      child:SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child : Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            //호텔식에대한 이미지이다.
            Positioned(
                top: 0*height,
                left: 5*width,
                child: Container(
                    width: 249*width,
                    height: 243*height,

                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => Book_room_stful(type:"hotel",),
                      ));//버튼이 눌리는 이벤트 발생 시, 다음 페이지에서 전달 받을 string 변수와 value('SecondRoute_Delivered')값을 직접 전달

                      variable.Sleep_Hotel();

                      },
                    child: Image.asset("assets/images/hotel.png"),
                  ),

                )

            ),


            //호텔식에대한 설명을 하는 Text 이다.
            Positioned(
                top: 165*height,
                left: 56*width,
                child: Text('호텔형식으로 예약하기는 가족, 친구끼리 오신분들에게 추천드립니다. \n 같이온 일행들과 함께 방을 사용합니다.', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),
                )
            ),


            //게스트하우스식에대한 이미지이다.
            Positioned(
                top: 120*height,
                left: 5*width,
                child: Container(
                    width: 249*width,
                    height: 243*height,

                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                        builder: (context) => Book_room_stful(type:"guest_house",),
                      ));//버튼이 눌리는 이벤트 발생 시, 다음 페이지에서 전달 받을 string 변수와 value('SecondRoute_Delivered')값을 직접 전달

                      variable.Sleep_Guest_house();

                    },
                    child: Image.asset("assets/images/guest_house.jpg"),
                  ),

                )

            ),

            //게스트하우스식에대한 설명을 하는 Text 이다.
            Positioned(
                top: 165*height,
                left: 56*width,
                child: Text('게스트하우스형식으로 예약하기 혼자서 오신분, 새로운 친구들을 원하시는 분들에게 추천드립니다. \n 새로운 사람들과 함께 여행을 즐겨보세요.', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),
                )
            ),


          ],
        ),
      ),

            ),), );
  }

}


