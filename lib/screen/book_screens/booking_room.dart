import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tong_myung_hotel/model/note.dart';
import 'package:tong_myung_hotel/service/firebase_firestore_service.dart.dart';

import 'dart:convert';

import 'package:tong_myung_hotel/state/current_State.dart';


class Booking_room extends StatefulWidget {

  String guest_gender;
  String exit_room_time;
  String enter_room_time;
  String room_type;
  String supply;
  int time_differ;

  Booking_room({
    this.guest_gender,
    this.exit_room_time,
    this.enter_room_time,
    this.room_type,
    this.supply,
    this.time_differ,
  });

  @override
  _Booking_roomState createState() => _Booking_roomState();
}

class _Booking_roomState extends State<Booking_room> {

  //Users 컬렉션에 입실시간 데이터를 담기위한 변수다.
  String entime_user_collection;

  //Users 컬렉션에 퇴실시간 데이터를 담기위한 변수다.
  String left_user_collection;

  //Users 컬렉션에 방유형을표현하기위한 변수다.
  String room_type_user_collection;

  //리스트뷰에 들어가는 List 인것같다. 안드로이드 때 RecyclerView 에 넣었던 List 와 유사한것 아닐까?
  List<Note> items;

  //StreamSubscription : A subscription(구독) on events from a [Stream].
  //QuerySnapshot : A QuerySnapshot contains zero or more DocumentSnapshot objects.
  //https://software-creator.tistory.com/9
  //스트림은 데이터나 이벤트가 드나드는 통로라고한다. 스트림을 통해서 비동기작업을 하는데 여기서는 아마 파이어베이스 서버와 데이터를 주고받는 작업을 하는듯 하다.
  StreamSubscription<QuerySnapshot> noteSub;

  //DB에 데이터를 추가하기위해 존재하는 객체이다.
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  Firestore firestore = Firestore.instance;

  //손님의 입실시간을 표현하는 변수다.
  var enter_room_time;

  //손님의 퇴실시간을 표현하는 변수다.
  var after_room_time;

  //서버로부터 데이터 (호텔,모텔에 남은 자리수)를 받아오기위한 코드이다.
  String remain_seat = "";

  //고객이 설정한 방의 타입
  var room_type_image;

  // 호텔,게하에서 남아있는 좌석을 담는 변수이다.
  int update_seat;

  //남,녀 방의유형에 따라 DB에서 불러와야하는 필드가 다르기때문에 아래의 조건문으로 필드의 이름을 설정해준다.
  String field_name;

  //사용자가 게스트하우식을 설정했을때 설정한 사람수이다.
  int supply;

  //DB에 금일날짜가 없는경우 Map 형태로 만들어줘야한다. 서버에 들어갈 map 을 위해 존재하는 변수다.
  String make_map_str;
  var make_map;

  //현재시간을 년,월,일 까지만 포함해주는 변수다.
  String now_time;

  //퇴실시간과 입실시간의 차이가 몇일 차이나는지 담아주는 변수
  int differ_day;
  //위의 녀석을 실수형으로 전환한거
  double differ_day_;

  //사용자가 입실한 시간이다. 조건문안에서 딱 한번 쓰인다.
  var enter_room_time_;

  // 사용자가 선택한 침실의 남은자리수가 0개인지 찾기위해 존재하는 list 이다.
  List<String> check_absent_list = [];

  // 게스트하우스에 유저의 숫자가 0명이하인지 아닌지 체크하기위한 변수
  String check="빈방존재";

  @override
  void initState() {
    super.initState();
    print(widget.time_differ);

    //손님의 입실시간을 표현하는 변수다.
    enter_room_time = DateTime.parse(widget.enter_room_time);

    //손님의 퇴실시간을 표현하는 변수다.
    after_room_time = DateTime.parse(widget.exit_room_time);

    //손님의 퇴실시간을 표현하는 변수다.
    //after_room_time = enter_room_time.add(new Duration(days: differ_day));

    print("booking_room initState 메소드 실행");
    print(enter_room_time.toString().substring(0,10));
    print(after_room_time.toString().substring(0,10));

    entime_user_collection=enter_room_time.toString().substring(0,10);
    left_user_collection=after_room_time.toString().substring(0,10);

    print(after_room_time.difference(enter_room_time));

    var differ=(after_room_time.difference(enter_room_time));
    int data=differ.toString().indexOf(':');
    print(differ.toString().substring(0,data));

    differ_day=int.parse(differ.toString().substring(0,data));

    differ_day=differ_day~/24;

    print(differ_day);

    //listen: Adds a subscription to this stream.
    //내 생각 : 파이어베이스DB 의 데이터를 불러와주는 역할을 해주는 메소드
    noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {

      //documents : Gets a list of all the documents included in this snapshot
      final List<Note> notes = snapshot.documents
          .map((documentSnapshot) => Note.fromMap(documentSnapshot.data,enter_room_time.toString(),after_room_time.toString(),differ_day))

      //toList() : Creates a [List] containing the elements of this [Iterable].
          .toList();

      print("List 의 개수 ");
      print(notes.length);
      print("List 의 개수 2");
      print(Note.document_id_list.length);



      // setState : It is an error to call this method after the framework calls [dispose].
      // 프레임 워크 호출 [dispose] 후에이 메소드를 호출하는 것은 오류입니다.
      setState(() {
        print("setState 함수 호출됨");
        this.items = notes;
      });



    });

    //이 조건문은 사용자가 선택한 방의유형을 초기화해준다.
    if (widget.room_type == "0") {
      room_type_image = "1호관1유형";
    } else if (widget.room_type == "1") {
      room_type_image = "1호관2유형";
    } else if (widget.room_type == "2") {
      room_type_image = "2호관1유형";
    } else if (widget.room_type == "3") {
      room_type_image = "2호관2유형";
    }

    //이 조건문은 사용자가 예약을할 때 필요한 정보들(호텔,게스트 하우스식, 성별, 인원수 등등)을 초기화해주는 조건문이다.
    if (Variable.sleep_type == "Hotel") {
      //이 조건문은 사용자의 성별을 초기화해준다.
      if (widget.guest_gender == "여자") {
        widget.guest_gender = "여자";
      } else if (widget.guest_gender != null) {
        widget.guest_gender = "남자";
      }

      if (widget.guest_gender == "남자") {
        field_name = "man";

        if (widget.room_type == "0") {
          field_name = field_name + '_three_hotel';
        } else if (widget.room_type == "1") {
          field_name = field_name + '_two_hotel';
        }
      } else if (widget.guest_gender == "여자") {
        field_name = "woman";

        if (widget.room_type == "1" || widget.room_type == "2") {
          field_name = field_name + '_two_hotel';
        } else if (widget.room_type == "0") {
          field_name = field_name + '_three_hotel';
        } else if (widget.room_type == "3") {
          field_name = field_name + '_four_hotel';
        }
      }
    } else if (Variable.sleep_type == "Guest_House") {
      //이 조건문은 사용자의 성별을 초기화해준다.
      if (widget.guest_gender == "여자") {
        widget.guest_gender = "여자";
      } else if (widget.guest_gender != null) {
        widget.guest_gender = "남자";
      }

      if (widget.guest_gender == "남자") {
        field_name = "man";

        if (widget.room_type == "0") {
          field_name = field_name + '_three_guesthouse';
        } else if (widget.room_type == "1") {
          field_name = field_name + '_two_guesthouse';
        }
      } else if (widget.guest_gender == "여자") {
        field_name = "woman";

        if (widget.room_type == "1" || widget.room_type == "2") {
          field_name = field_name + '_two_guesthouse';
        } else if (widget.room_type == "0") {
          field_name = field_name + '_three_guesthouse';
        } else if (widget.room_type == "3") {
          field_name = field_name + '_four_guesthouse';
        }
      }
    }

    //현재시간을 표현하는 변수이다.
    var now=DateTime.now();
    String now_=now.toString();
    now_=now_.substring(0,10);

    now_time=now_;

    //서버로부터 데이터 (호텔,모텔에 남은 자리수)를 받아오기위한 코드이다.
    remain_seat = "";







  }

  @override
  void dispose() {
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    //사용자가 설정한 방의 타입이다.
    var room_type_condtition;

    /////////////////   모든기기에서 위젯들의 크기, 배치가 동일하게 하기위해서 배율을 사용한다.    /////////////////
    //핸드폰 전체크기의 비율값
    double wi = getWidthRatio(360, context);
    double hi = getHeightRatio(640, context);

    double ratio = (hi + wi) / 2;

    /////////////////   모든기기에서 위젯들의 크기, 배치가 동일하게 하기위해서 배율을 사용한다.    /////////////////


    return Scaffold(
        body: // Figma Flutter Generator Group2Widget - GROUP




        Container(
            width: 360 * wi,
            height: 640 * hi,
            child: Stack(children: <Widget>[
              Positioned(
                top: 0 * hi,
                left: 0 * wi,
                child: Container(
                    width: 360 * wi,
                    height: 640 * hi,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Stack(children: <Widget>[
                    Positioned(
                    top: 23 * hi,
                        left: 6 * wi,
                        child: Container(
                            width: 334 * wi,
                            height: 582 * hi,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0 * hi,
                                  left: 0 * wi,
                                  child: Text(
                                    '검색조건과 일치하는 방을 찾았습니다',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1 * hi),
                                  )),

                              Positioned(
                                  top: 40 * hi,
                                  left: 14 * wi,
                                  child: Text(
                                    '검색조건',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1 * hi),
                                  )),

                              //사용자가 이전화면에서 설정한 성별을 표현하는 텍스트이다.
                              Positioned(
                                  top: 63 * hi,
                                  left: 14 * wi,
                                  child: Text(
                                    widget.guest_gender,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1 * hi),
                                  )),

                              Positioned(
                                  top: 110 * hi,
                                  left: 13 * wi,
                                  child: Text(
                                    '입실날짜                              퇴실날짜 ',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Roboto',

                                        //edit this
                                        fontSize: 15,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1 * hi),
                                  )),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (입실시간 날짜)
                              Positioned(
                                top: 145 * hi,
                                left: 14 * wi,
                                child: Container(
                                  width: 120 * wi,
                                  height: 36 * hi,

                                  //사용자가 선택한 날짜를 띄워주는 Text
                                  child: Text(widget.enter_room_time),
                                ),
                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                              Positioned(
                                top: 145 * hi,
                                left: 180 * wi,
                                child: Container(
                                  width: 120 * wi,
                                  height: 36 * hi,

                                  //사용자가 선택한 날짜를 띄워주는 Text
                                  child: Text(widget.exit_room_time),
                                ),
                              ),

                              Positioned(
                                  top: 173 * hi,
                                  left: 16 * wi,
                                  child: Text(
                                    '방의유형',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1 * hi),
                                  )),

                              Positioned(
                                  top: 190 * hi,
                                  left: 14 * wi,
                                  child: Container(
                                    width: 333 * wi,
                                    height: 200 * hi,
                                    child: Image.asset(
                                        "assets/images/$room_type_image.png"),
                                  )),
                            ]))),
                    Positioned(
                        top: 530 * hi,
                        left: 133 * wi,
                        child: RaisedButton(
                            child: Text('예약하기',
                                style: TextStyle(fontSize: 24)),
                            onPressed: () => {

                              print("예약하기 버튼을 누름"),

                            Booking(),



                }

                ),
              ),
              Positioned(
                  top: 591 * hi,
                  left: 0 * wi,
                  child: Container(
                      width: 360 * wi,
                      height: 41 * hi,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(196, 196, 196, 1),
                      ))),
              Positioned(
                top: 596 * hi,
                left: 17 * wi,
              ),
              Positioned(
                  top: 596 * hi,
                  left: 154 * wi,
                  child: Container(
                      width: 26 * wi,
                      height: 21 * hi,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(212, 87, 87, 1),
                      ))),
              Positioned(
                  top: 618 * hi,
                  left: 143 * wi,
                  child: Text(
                    '별점/후기',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1 * hi),
                  )),
              Positioned(
                  top: 617 * hi,
                  left: 275 * wi,
                  child: Text(
                    '마이 페이지',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1 * hi),
                  )),
              Positioned(
                  top: 596 * hi,
                  left: 295 * wi,
                  child: Container(
                      width: 20 * wi,
                      height: 17 * hi,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(148, 232, 134, 1),
                      ))),
            ]))),]
    )
    )
    ,
    );
  }

  //List 안의 데이터를 출력하는 메소드이다.
  void printList(List<String> list) {
    for(var i=0; i< list.length; i++) {
      print(i);
    }
  }

  void _updateEnter(DocumentSnapshot doc){
    Firestore.instance.collection('Users').document(doc.documentID).updateData({'방 유형' : 1});
  }

  void Booking(){

    //손님의 입실시간이다.
    String enter_room_time_str;
    //손님의 퇴실시간이다.
    String after_room_time_str;
    //게스트하우스식에서 사용자가 설정한 인원수
    int supply_;
    // 게스트하우스의 침대개수
    int bed;

    //List 안의 Map 을 잠시담기위한 map
    Map map1;
    //Map 의 value 에 접근하기위해 있는 list
    var list1;
    //호텔의 남은 방의개수이다.
    int remain_room;

    //입실시간
    var time= DateTime.parse(enter_room_time.toString().substring(0,10));

    print(Note.day_docu_id.length);
    Note.day_docu_id.forEach((k,v) => print('${k}: ${v}'));



    //서버에 오늘날짜가 없는경우의 조건이다.

    print("예약하기 버튼 클릭");
    print(Note.day_list.toString());

    //if(Note.day_list.toString()=="[]"){
    if(!Note.day_docu_id.containsKey(enter_room_time.toString().substring(0,10))){
    print("서버에 오늘날짜가 없는경우의 조건");

    print(field_name);

    //사용자가 호텔을 예약했을 때 서버에 만들어지는 map들을 아래 조건문에서 설정한다.
    if(field_name=="man_three_hotel"){
    print("man_three_hotel");

    make_map_str='{"man_three_guesthouse":"264", "man_three_hotel":"88","man_two_guesthouse":"6", "man_two_hotel":"3","woman_four_guesthouse":"80", "woman_four_hotel":"20","woman_three_guesthouse":"117","woman_three_hotel":"38","woman_two_guesthouse":"4","woman_two_hotel":"2"}';
    print("에러로그1");
    //오늘날짜를 필드로 만들어야 한다. map 의 형태로말이다. 예) 필드명 2020-03-01 안에 map 이 있어야함.
    make_map = json.decode(make_map_str);
    print("에러로그2");
    }
    else if(field_name=="man_two_hotel"){
    print("man_two_hotel");
    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'2',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };

    }
    else if(field_name=="woman_four_hotel"){
    print("woman_four_hotel");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'19',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };

    }
    else if(field_name=="woman_three_hotel"){
    print("woman_three_hotel");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'37',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };

    }
    else if(field_name=="woman_two_hotel"){
    print("woman_two_hotel");

    //오늘날짜를 필드로 만들어야 한다. map 의 형태로말이다. 예) 필드명 2020-03-01 안에 map 이 있어야함.
    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'1'
    };
    };


    print(widget.supply);
    supply_=int.parse(widget.supply.substring(0,1));

    print(supply_);

    //check point

    //사용자가 게스트하우스식으로 예약을 했을 때 서버에 저장될 map 의 형태를 설정한다.
    if(field_name=="man_three_guesthouse"){
    bed=264;
    bed=bed-supply_;
    print("man_three_guesthouse");

    make_map = {
    'man_three_guesthouse':'$bed', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };
    }
    else if(field_name=="man_two_guesthouse"){
    bed=6;
    bed=bed-supply_;
    print("man_two_guesthouse");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'$bed', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };
    }
    else if(field_name=="woman_four_guesthouse"){
    bed=80;
    bed=bed-supply_;
    print("woman_four_guesthouse");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'$bed', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };
    }
    else if(field_name=="woman_three_guesthouse"){
    bed=117;
    bed=bed-supply_;
    print("woman_three_guesthouse");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'$bed','woman_three_hotel':'38',
    'woman_two_guesthouse':'4','woman_two_hotel':'2'
    };
    }
    else if(field_name=="woman_two_guesthouse"){
    bed=4;
    bed=bed-supply_;
    print("woman_two_guesthouse");

    make_map = {
    'man_three_guesthouse':'264', 'man_three_hotel':'89',
    'man_two_guesthouse':'6', 'man_two_hotel':'3',
    'woman_four_guesthouse':'80', 'woman_four_hotel':'20',
    'woman_three_guesthouse':'117','woman_three_hotel':'38',
    'woman_two_guesthouse':'$bed','woman_two_hotel':'2'
    };
    };

    for(int i=0;i<differ_day;i++){
    print("for 문 실행됨");
    print(differ_day);
    //String a=enter_room_time.toString().substring(0,10),
    if(i==0){
    print("실행됨");
    enter_room_time_=enter_room_time.add(new Duration(days: 0));
    print(enter_room_time_.toString());
    print(enter_room_time_.toString().substring(0,10));
    db.createNote(make_map,enter_room_time_.toString().substring(0,10),after_room_time_str,0);
    };
    enter_room_time=enter_room_time.add(new Duration(days: 1));
    enter_room_time_str=enter_room_time.toString();
    after_room_time_str=after_room_time.toString();

    print("enter_room_time_str 의 값 :"+enter_room_time_str);
    print("after_room_time_str 의 값 :"+after_room_time_str);

    if(enter_room_time_str!=after_room_time_str){
    db.createNote(make_map,enter_room_time_str,after_room_time_str,1);
    };

    };


    print("CurrentUser.login_user_uid 의 값 서버에 방이없는경우");
    print(CurrentUser.login_user_uid);
    print(enter_room_time.toString().substring(0,10));
    print(after_room_time.toString().substring(0,10));

    if(field_name=="man_three_guesthouse"){
      room_type_user_collection="1";
    }
    else if(field_name=="man_three_hotel"){
      room_type_user_collection="2";
    }
    else if(field_name=="man_two_guesthouse"){
      room_type_user_collection="3";
    }
    else if(field_name=="man_two_hotel"){
      room_type_user_collection="4";
    }
    else if(field_name=="woman_four_guesthouse"){
      room_type_user_collection="5";
    }
    else if(field_name=="woman_four_hotel"){
      room_type_user_collection="6";
    }
    else if(field_name=="woman_three_guesthouse"){
      room_type_user_collection="7";
    }
    else if(field_name=="woman_three_hotel"){
      room_type_user_collection="8";
    }
    else if(field_name=="woman_two_guesthouse"){
      room_type_user_collection="9";
    }
    else if(field_name=="woman_two_hotel"){
      room_type_user_collection="10";
    }

    firestore.collection("Users").document(CurrentUser.login_user_uid).updateData({"입실일":entime_user_collection,"퇴실일":left_user_collection,"방 유형":room_type_user_collection});
    }

    //서버에 오늘날짜가 있는 경우의 조건이다.
    else{
    print("서버에 오늘날짜가 있는 경우");
    print(Note.day_list);

    //아래의 조건문은 DB의 데이터를 수정해주는 역할을 해주는 코드이다. 호텔식은 DB에서 방의개수가 -1되고 게스트하우스식은 사용자가 설정한 인원수만큼 DB에서 데이터가 차감된다.
    if (Variable.sleep_type == "Hotel")
    {
    print("사용자가 설정한 숙박타입이 호텔인경우");
    print(field_name);

    //만약 예약자가 호텔 남자 삼인실을 예약한 경우.
    if(field_name=="man_three_hotel"){


    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['man_three_hotel']);



    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][man_three_hotel]");
      print(Note.day_list[i]["man_three_hotel"]);
      check_absent_list.add(Note.day_list[i]["man_three_hotel"]);
    }

    if(check_absent_list.contains("0")){
    print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
    //메인화면으로 이동시킨다.
    break;
    }
    //만약 남자삼인실 호텔이 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-1;
    print(remain_room);
    Note.day_list[i].update("man_three_hotel", (v) => remain_room.toString());
    print(Note.day_list[i]['man_three_hotel']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);

    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    } //man_three_hotel end

    //만약 예약자가 호텔 남자 이인실을 예약한 경우.
    else if(field_name=="man_two_hotel"){


    //사용자가 설정한 날짜들을 수정하기위해 존재하는 for문이다.
    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['man_two_hotel']);

    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][man_two_hotel]");
      print(Note.day_list[i]["man_two_hotel"]);
      check_absent_list.add(Note.day_list[i]["man_two_hotel"]);
    }

    if(check_absent_list.contains("0")){
      print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
      //메인화면으로 이동시킨다.
      break;
    }

    //만약 남자삼인실 호텔이 아예0 자리일경우
    if(remain_room==0){
    print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
    //메인화면으로 이동시킨다.
    i=differ_day;
    }
    //만약 남자삼인실 호텔이 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-1;
    print(remain_room);
    Note.day_list[i].update("man_two_hotel", (v) => remain_room.toString());
    print(Note.day_list[i]['man_two_hotel']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);


    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    } //man_two_hotel end

    //만약 예약자가 호텔 여자 이인실을 예약한 경우.
    else if(field_name=="woman_two_hotel"){


    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['woman_two_hotel']);

    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][woman_two_hotel]");
      print(Note.day_list[i]["woman_two_hotel"]);
      check_absent_list.add(Note.day_list[i]["woman_two_hotel"]);
    }

    if(check_absent_list.contains("0")){
      print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
      //메인화면으로 이동시킨다.
      break;
    }
    //만약 남자삼인실 호텔이 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-1;
    print(remain_room);
    Note.day_list[i].update("woman_two_hotel", (v) => remain_room.toString());
    print(Note.day_list[i]['woman_two_hotel']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);


    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    } //woman_two_hotel end

    //만약 예약자가 호텔 여자 삼인실을 예약한 경우.
    else if(field_name=="woman_three_hotel"){


    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['woman_three_hotel']);

    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][woman_three_hotel]");
      print(Note.day_list[i]["woman_three_hotel"]);
      check_absent_list.add(Note.day_list[i]["woman_three_hotel"]);
    }

    if(check_absent_list.contains("0")){
      print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
      //메인화면으로 이동시킨다.
      break;
    }

    //만약 남자삼인실 호텔이 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-1;
    print(remain_room);
    Note.day_list[i].update("woman_three_hotel", (v) => remain_room.toString());
    print(Note.day_list[i]['woman_three_hotel']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);


    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    } //woman_three_hotel end

    //만약 예약자가 호텔 여자 사인실을 예약한 경우.
    else if(field_name=="woman_four_hotel"){

    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['woman_four_hotel']);

    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][woman_four_hotel]");
      print(Note.day_list[i]["woman_four_hotel"]);
      check_absent_list.add(Note.day_list[i]["woman_four_hotel"]);
    }

    if(check_absent_list.contains("0")){
      print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
      //메인화면으로 이동시킨다.
      break;
    }
    //만약 남자삼인실 호텔이 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-1;
    print(remain_room);
    Note.day_list[i].update("woman_four_hotel", (v) => remain_room.toString());
    print(Note.day_list[i]['woman_four_hotel']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);


    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    } //woman_four_hotel end

    }   //호텔인 경우

    else if (Variable.sleep_type == "Guest_House")
    {

    print("사용자가 게스트하우스식을 선택했다.");
    print(field_name);
    print("코드의 흐름1");
    print(widget.supply);
    widget.supply=widget.supply.replaceAll('명','');
    supply=int.parse(widget.supply);
    print("supply 의 값");
    print(supply);


    //만약 예약자가 게스트하우스식 남자 이인실을 예약한 경우.
    if(field_name=="man_two_guesthouse"){


    for(int i=0; i<differ_day; i++){
    map1=Note.day_list[i];
    print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

    remain_room=int.parse(Note.day_list[i]['man_two_guesthouse']);

    print("게스트하우스식에서 man_two_guesthouse 에서 남은 침대의 수 ");
    print(remain_room);

    //서버에서 받아온 각 날짜별 게스트하우스의 남은 침대수가 충분한지 판단해주는 반복문이다. 만약 변수 check 가 "빈방없음" 으로 초기화되면 침대수가 모자른것이다.
    for(int i=0;i<differ_day;i++){
      print("Note.day_list[i][man_two_guesthouse]");
      print(Note.day_list[i]["man_two_guesthouse"]);
      check_absent_list.add(Note.day_list[i]["man_two_guesthouse"]);
      int data=int.parse(check_absent_list[i]);
      data-supply<=0;
      if(data-supply<=0){
        check="빈방없음";
      }
    }

    if(check=="빈방없음"){
      print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
      //메인화면으로 이동시킨다.
      break;
    }
    //만약 남자이인실 게스트하우스가 있는경우
    else{
    print("빈방이 있습니다.");
    remain_room=remain_room-supply;
    print(remain_room);
    Note.day_list[i].update("man_two_guesthouse", (v) => remain_room.toString());
    print(Note.day_list[i]['man_two_guesthouse']);

    print(Note.day_list[i]);
    print("로그찍기2");

    print(enter_room_time.toString().substring(0,10));

    //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
    if(i==0){
    print("i가 0일때 "+i.toString());

    print("Note.day_list.length 의 값");
    print(Note.day_list.length);


    db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
    print("Note.day_list.length-1 의 값");
    print(Note.day_list.length-1);
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("날짜");
    print(enter_room_time.toString().substring(0,10));
    print("document id 의 값");
    print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

    //sleep(const Duration(seconds:1)),
    }
    else if(i>=1){
    print("i가 1이상일때 "+i.toString());
    time=time.add(new Duration(days: 1));
    print(time.toString().substring(0,10));
    print("list 의 i 번째 값");
    print(Note.day_list[i]);
    print("document id 의 값");
    print(Note.day_docu_id[time.toString().substring(0,10)]);
    print("날짜");
    print(time.toString().substring(0,10));
    db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
    };


    }   //else end

    };    //for 문 끝

    }; //man_two_guesthouse end

    //만약 예약자가 게스트하우스식 남자 삼인실을 예약한 경우.
    if(field_name=="man_three_guesthouse"){


      for(int i=0; i<differ_day; i++){
        map1=Note.day_list[i];
        print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

        remain_room=int.parse(Note.day_list[i]['man_three_guesthouse']);

        print("게스트하우스식에서 man_three_guesthouse 에서 남은 침대의 수 ");
        print(remain_room);

        //서버에서 받아온 각 날짜별 게스트하우스의 남은 침대수가 충분한지 판단해주는 반복문이다. 만약 변수 check 가 "빈방없음" 으로 초기화되면 침대수가 모자른것이다.
        for(int i=0;i<differ_day;i++){
          print("Note.day_list[i][man_three_guesthouse]");
          print(Note.day_list[i]["man_three_guesthouse"]);
          check_absent_list.add(Note.day_list[i]["man_three_guesthouse"]);
          int data=int.parse(check_absent_list[i]);
          data-supply<=0;
          if(data-supply<=0){
            check="빈방없음";
          }
        }

        if(check=="빈방없음"){
          print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
          //메인화면으로 이동시킨다.
          break;
        }
        //만약 남자이인실 게스트하우스가 있는경우
        else{
          print("빈방이 있습니다.");
          remain_room=remain_room-supply;
          print(remain_room);
          Note.day_list[i].update("man_three_guesthouse", (v) => remain_room.toString());
          print(Note.day_list[i]['man_three_guesthouse']);

          print(Note.day_list[i]);
          print("로그찍기2");

          print(enter_room_time.toString().substring(0,10));

          //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
          if(i==0){
            print("i가 0일때 "+i.toString());

            print("Note.day_list.length 의 값");
            print(Note.day_list.length);


            db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
            print("Note.day_list.length-1 의 값");
            print(Note.day_list.length-1);
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("날짜");
            print(enter_room_time.toString().substring(0,10));
            print("document id 의 값");
            print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

            //sleep(const Duration(seconds:1)),
          }
          else if(i>=1){
            print("i가 1이상일때 "+i.toString());
            time=time.add(new Duration(days: 1));
            print(time.toString().substring(0,10));
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("document id 의 값");
            print(Note.day_docu_id[time.toString().substring(0,10)]);
            print("날짜");
            print(time.toString().substring(0,10));
            db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
          };


        }   //else end

      };    //for 문 끝

    }; //man_three_guesthouse end

    //만약 예약자가 게스트하우스식 여자 이인실을 예약한 경우.
    if(field_name=="woman_two_guesthouse"){


      for(int i=0; i<differ_day; i++){
        map1=Note.day_list[i];
        print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

        remain_room=int.parse(Note.day_list[i]['woman_two_guesthouse']);

        print("게스트하우스식에서 woman_two_guesthouse 에서 남은 침대의 수 ");
        print(remain_room);

        //서버에서 받아온 각 날짜별 게스트하우스의 남은 침대수가 충분한지 판단해주는 반복문이다. 만약 변수 check 가 "빈방없음" 으로 초기화되면 침대수가 모자른것이다.
        for(int i=0;i<differ_day;i++){
          print("Note.day_list[i][woman_two_guesthouse]");
          print(Note.day_list[i]["woman_two_guesthouse"]);
          check_absent_list.add(Note.day_list[i]["woman_two_guesthouse"]);
          int data=int.parse(check_absent_list[i]);
          data-supply<=0;
          if(data-supply<=0){
            check="빈방없음";
          }
        }

        if(check=="빈방없음"){
          print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
          //메인화면으로 이동시킨다.
          break;
        }
        //만약 남자이인실 게스트하우스가 있는경우
        else{
          print("빈방이 있습니다.");
          remain_room=remain_room-supply;
          print(remain_room);
          Note.day_list[i].update("woman_two_guesthouse", (v) => remain_room.toString());
          print(Note.day_list[i]['woman_two_guesthouse']);

          print(Note.day_list[i]);
          print("로그찍기2");

          print(enter_room_time.toString().substring(0,10));

          //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
          if(i==0){
            print("i가 0일때 "+i.toString());

            print("Note.day_list.length 의 값");
            print(Note.day_list.length);


            db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
            print("Note.day_list.length-1 의 값");
            print(Note.day_list.length-1);
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("날짜");
            print(enter_room_time.toString().substring(0,10));
            print("document id 의 값");
            print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

            //sleep(const Duration(seconds:1)),
          }
          else if(i>=1){
            print("i가 1이상일때 "+i.toString());
            time=time.add(new Duration(days: 1));
            print(time.toString().substring(0,10));
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("document id 의 값");
            print(Note.day_docu_id[time.toString().substring(0,10)]);
            print("날짜");
            print(time.toString().substring(0,10));
            db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
          };


        }   //else end

      };    //for 문 끝

    }; //woman_two_guesthouse end

    //만약 예약자가 게스트하우스식 여자 삼인실을 예약한 경우.
    if(field_name=="woman_three_guesthouse"){


      for(int i=0; i<differ_day; i++){
        map1=Note.day_list[i];
        print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

        remain_room=int.parse(Note.day_list[i]['woman_three_guesthouse']);

        print("게스트하우스식에서 woman_three_guesthouse 에서 남은 침대의 수 ");
        print(remain_room);

        //서버에서 받아온 각 날짜별 게스트하우스의 남은 침대수가 충분한지 판단해주는 반복문이다. 만약 변수 check 가 "빈방없음" 으로 초기화되면 침대수가 모자른것이다.
        for(int i=0;i<differ_day;i++){
          print("Note.day_list[i][woman_three_guesthouse]");
          print(Note.day_list[i]["woman_three_guesthouse"]);
          check_absent_list.add(Note.day_list[i]["woman_three_guesthouse"]);
          int data=int.parse(check_absent_list[i]);
          data-supply<=0;
          if(data-supply<=0){
            check="빈방없음";
          }
        }

        if(check=="빈방없음"){
          print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
          //메인화면으로 이동시킨다.
          break;
        }
        //만약 남자이인실 게스트하우스가 있는경우
        else{
          print("빈방이 있습니다.");
          remain_room=remain_room-supply;
          print(remain_room);
          Note.day_list[i].update("woman_three_guesthouse", (v) => remain_room.toString());
          print(Note.day_list[i]['woman_three_guesthouse']);

          print(Note.day_list[i]);
          print("로그찍기2");

          print(enter_room_time.toString().substring(0,10));

          //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
          if(i==0){
            print("i가 0일때 "+i.toString());

            print("Note.day_list.length 의 값");
            print(Note.day_list.length);


            db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
            print("Note.day_list.length-1 의 값");
            print(Note.day_list.length-1);
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("날짜");
            print(enter_room_time.toString().substring(0,10));
            print("document id 의 값");
            print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

            //sleep(const Duration(seconds:1)),
          }
          else if(i>=1){
            print("i가 1이상일때 "+i.toString());
            time=time.add(new Duration(days: 1));
            print(time.toString().substring(0,10));
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("document id 의 값");
            print(Note.day_docu_id[time.toString().substring(0,10)]);
            print("날짜");
            print(time.toString().substring(0,10));
            db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
          };


        }   //else end

      };    //for 문 끝

    }; //woman_three_guesthouse end

    //만약 예약자가 게스트하우스식 여자 사인실을 예약한 경우.
    if(field_name=="woman_four_guesthouse"){


      for(int i=0; i<differ_day; i++){
        map1=Note.day_list[i];
        print("booking_room 에서 for 문안에서 i 의 값 :"+i.toString());

        remain_room=int.parse(Note.day_list[i]['woman_four_guesthouse']);

        print("게스트하우스식에서 woman_four_guesthouse 에서 남은 침대의 수 ");
        print(remain_room);

        //서버에서 받아온 각 날짜별 게스트하우스의 남은 침대수가 충분한지 판단해주는 반복문이다. 만약 변수 check 가 "빈방없음" 으로 초기화되면 침대수가 모자른것이다.
        for(int i=0;i<differ_day;i++){
          print("Note.day_list[i][woman_four_guesthouse]");
          print(Note.day_list[i]["woman_four_guesthouse"]);
          check_absent_list.add(Note.day_list[i]["woman_four_guesthouse"]);
          int data=int.parse(check_absent_list[i]);
          data-supply<=0;
          if(data-supply<=0){
            check="빈방없음";
          }
        }

        if(check=="빈방없음"){
          print("빈방이 없습니다. 라는 내용을 토스트메세지로 띄워준다.");
          //메인화면으로 이동시킨다.
          break;
        }
        //만약 남자이인실 게스트하우스가 있는경우
        else{
          print("빈방이 있습니다.");
          remain_room=remain_room-supply;
          print(remain_room);
          Note.day_list[i].update("woman_four_guesthouse", (v) => remain_room.toString());
          print(Note.day_list[i]['woman_four_guesthouse']);

          print(Note.day_list[i]);
          print("로그찍기2");

          print(enter_room_time.toString().substring(0,10));

          //이제 만들어진 map 을 기반으로 Firestore에 업데이트해야함.
          if(i==0){
            print("i가 0일때 "+i.toString());

            print("Note.day_list.length 의 값");
            print(Note.day_list.length);


            db.updateNote(Note(Note.day_docu_id[enter_room_time.toString().substring(0,10)],Note.day_list[Note.day_list.length-1],"a","b",1),enter_room_time.toString().substring(0,10),Note.day_list[i]);
            print("Note.day_list.length-1 의 값");
            print(Note.day_list.length-1);
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("날짜");
            print(enter_room_time.toString().substring(0,10));
            print("document id 의 값");
            print(Note.day_docu_id[enter_room_time.toString().substring(0,10)]);

            //sleep(const Duration(seconds:1)),
          }
          else if(i>=1){
            print("i가 1이상일때 "+i.toString());
            time=time.add(new Duration(days: 1));
            print(time.toString().substring(0,10));
            print("list 의 i 번째 값");
            print(Note.day_list[i]);
            print("document id 의 값");
            print(Note.day_docu_id[time.toString().substring(0,10)]);
            print("날짜");
            print(time.toString().substring(0,10));
            db.updateNote(Note(Note.day_docu_id[time.toString().substring(0,10)],Note.day_list[i],"a","b",1),time.toString().substring(0,10),Note.day_list[i]);
          };


        }   //else end

      };    //for 문 끝

    }; //woman_four_guesthouse end

    }

    if(field_name=="man_three_guesthouse"){
      room_type_user_collection="1";
    }
    else if(field_name=="man_three_hotel"){
      room_type_user_collection="2";
    }
    else if(field_name=="man_two_guesthouse"){
      room_type_user_collection="3";
    }
    else if(field_name=="man_two_hotel"){
      room_type_user_collection="4";
    }
    else if(field_name=="woman_four_guesthouse"){
      room_type_user_collection="5";
    }
    else if(field_name=="woman_four_hotel"){
      room_type_user_collection="6";
    }
    else if(field_name=="woman_three_guesthouse"){
      room_type_user_collection="7";
    }
    else if(field_name=="woman_three_hotel"){
      room_type_user_collection="8";
    }
    else if(field_name=="woman_two_guesthouse"){
      room_type_user_collection="9";
    }
    else if(field_name=="woman_two_hotel"){
      room_type_user_collection="10";
    }

    print("CurrentUser.login_user_uid 의 값 서버에 방이 있는경우");
    print(CurrentUser.login_user_uid);
    firestore.collection("Users").document(CurrentUser.login_user_uid).updateData({"입실일":entime_user_collection,"퇴실일":left_user_collection,"방 유형":room_type_user_collection});
    };

    Navigator.pop(context);
    //현재 화면을 스택에서 제거한다.
    Navigator.pop(context);
  }

}
