//사용자가 방을 예약하기위해 자신이 원하는 옵션을 고르는 기능을 할 수 있는 화면이다.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/screen/book_screens/booking_room.dart';

////PageController 를 사용하기위해 import 한 녀석들이다.////
import '../../widgets/slide_item.dart';
import '../../model/slide.dart';
import '../../widgets/slide_dots.dart';
////PageController 를 사용하기위해 import 한 녀석들이다.////


//남녀성별을 선택하는 체크박스 기능을 구현하기위해 추가한 코드
enum Gender {MAN, WOMEN}

class Book_room_stls extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Book_room_stful(),
    );
  }
}

class Book_room_stful extends StatefulWidget {
  String type;

  Book_room_stful({
    this.type,
  });



  @override
  _Book_room_stfulState createState() => _Book_room_stfulState();
}

class _Book_room_stfulState extends State<Book_room_stful> {

  //edit this
  bool selected = true;


  //사용자가 설정하는 퇴실날짜 시간이다.
  DateTime _dateTime_exit_room_time;

  //사용자가 설정하는 입실날짜 시간이다.
  DateTime _dateTime_enter_room_time;

  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////

  int _counter=0;
  var _isChecked=false;

  //현재 사용자의 성별 체크박스에서 사용한다.
  Gender _gender =Gender.MAN;

  //고객이 설정한 성별이다.
  String gender;

  Object get type => null;

  void _incrementCounter(){
    setState((){

      _counter++;

    });
  }

  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////



  /////////////////////   스피너 버튼 예제를 활용하기위해 존재하는 변수들이다.   /////////////////////

  //방에 들어갈 인원수를 표현하기위한 코드들이다.
  //초기값
  String dropdownValue = '1명';

  List <String> spinnerItems = [
    '1명',
    '2명',
    '3명',
    '4명',
  ] ;

  //여기서부터는 소비자가 방의 유형을 선택하기위한 스피너 버튼 코드들이다.dynamic
  //초기값
  String dropdownValue_room_type = '1유형';

  List <String> spinnerItems_room_type = [
    '1유형',
    '2유형',
    '3유형',
    '4유형',
  ] ;


  /////////////////////   스피너 버튼 예제를 활용하기위해 존재하는 변수들이다.   /////////////////////


  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  //최근 페이지를 의미한다.
  int _currentPage = 0;

  //PageController : A controller for [PageView].
  //내 생각 : 한장씩 바뀌는 페이지를 표현해주는 코드인듯 하다. 가장 첫페이지는 PageController의 생성자를 통해서 0으로 설정되있다.
  final PageController _pageController = PageController(initialPage: 0);

  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  @override
  void initState() {
    super.initState();

    //한페이지가 얼만큼 머루를것인지 시간을 설정해주는 코드인듯 하다.
    //Timer : Creates a new repeating timer. (periodic : 반복되는)

    //"만약 5초의 시간이 흐른다면" 을 표현하는 코드인듯. 사진이 한번씩 바뀌는 시간주기이다.
    Timer.periodic(Duration(seconds: 50000), (Timer timer) {

      //animateToPage : Animates(만화영화로 만들다) the controlled [PageView] from the current page to the given page.
      _pageController.animateToPage(
        _currentPage,

        // The animation lasts for the given duration and follows the given curve.
        // 애니메이션이 주어진 시간동안 유지되고 주어진 curve에 따른다.
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  //페이지가 바뀔 때 마다 호출되는 메소드이다. 현재 몇번째 페인지 변수로 알 수 있다.
  _onPageChanged(int index) {


    setState(() {
      if(index==2){
        _currentPage=3;
        print("_currentPage1");
        print(_currentPage);
      }
      else{
        _currentPage = index;
        print("_currentPage2");
        print(_currentPage);
      }

    });

  }

  @override
  Widget build(BuildContext context) {



    //핸드폰 전체크기의 비율값
    double width=getWidthRatio(360,context);
    double height=getHeightRatio(640,context);

    double phone_avg=(width+height)/2;

    //사용자가 묶을 방의형태에 따라 인원수를 설정하는 스피너는 보일 수 도 있고 안보일 수 도 있다. 스피너유무를 설정해주는 변수이다.
    var spinner_condition;

    if(Variable.sleep_type=="Hotel"){
      spinner_condition=false;
    }
    else if(Variable.sleep_type=="Guest_House"){
      spinner_condition=true;
    }

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다.
    String time_differ;

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다. (int 형)
    int time_differ_Integer;

    // 사용자가 몇일이나 묶는지 확인할 때 조건문에 필요한 변수
    int idx;
    String gap;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
        child: Stack(

            children: <Widget>[

              Positioned(
                //top 과 left 가 존재하지 않는 이유는 Figma 에서 가져올 때 Group 형태로 가져오지 않고 Frame 그 자체로 가져왔기 떄문이다. 따라서 여백이 없다.

                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    // Figma Flutter Generator Android1Widget - FRAME
                    Container(
                      width: 360*width,
                      height: 640*height,
                      decoration: BoxDecoration(
                        color : Color.fromRGBO(255, 255, 255, 1),
                      ),

                      child: Stack(
                        children: <Widget>[



                          Positioned(
                              top: 25*height,
                              left: 6*width,
                              child: Text('예약하기', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Roboto',

                                  //edit this : 호민이말대로 가로세로의 평균을 해서 글자크기를 지정해봤는데 그닥 차이가 없었음. 곱하거나 더할때나 마찬가지.
                                  //fontSize: 15*phone_avg,
                                  fontSize: 15+12.0,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1*height
                              ),)
                          ),Positioned(
                              top: 219*height,
                              left: 13*width,
                              child: Text('인원수', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Roboto',

                                  //edit this
                                  fontSize: 15,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1*height
                              ),)
                          ),Positioned(
                              top: 267*height,
                              left: 13*width,
                              child: Text('방의유형', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Roboto',

                                  //edit this
                                  fontSize: 15,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1*height
                              ),)
                          ),Positioned(

                              top: 60*height,
                              left: 13*width,
                              child: Text('성별', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Roboto',

                                  //edit this
                                  fontSize: 15+12.0,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1*height
                              ),)
                          ),

                          Positioned(

                              top: 121*height,
                              left: 13*width,
                              child: Text('입실날짜                               퇴실날짜', textAlign: TextAlign.left, style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Roboto',

                                  //edit this
                                  fontSize: 15,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1*height
                              ),)
                          ),

                          //성별선택에서 남자 체크박스
                          Positioned(
                              top: 75*height,
                              left: 14*width,
                              child: Container(
                                width: 140*width,
                                height: 41*height,
                                child: RadioListTile(
                                  title : Text('남자'),
                                  value: Gender.MAN,
                                  groupValue: _gender,
                                  onChanged: (value){
                                    setState((){


                                      _gender=value;
                                      gender="남자";

                                    });
                                  },
                                ),
                              )
                          ),

                          //성별선택에서 여자 체크박스
                          Positioned(
                              top: 75*height,
                              left: 140*width,

                              child: Container(
                                width: 140*width,
                                height: 41*height,
                                child: RadioListTile(
                                  title : Text('여자'),

                                  value: Gender.WOMEN,
                                  groupValue: _gender,
                                  onChanged: (value){
                                    setState((){


                                      _gender=value;
                                      gender="여자";

                                    });
                                  },
                                ),
                              )
                          ),

                          //사용자가 설정한 날짜가 텍스트에 출력된다. (입실시간 날짜)
                          Positioned(
                            top: 145*height,
                            left: 14*width,

                            child: Container(
                              width: 120*width,
                              height: 36*height,

                              //사용자가 선택한 날짜를 띄워주는 Text
                              child : Text(_dateTime_enter_room_time == null ? '' : _dateTime_enter_room_time.toString().substring(0,10)),

                            ),
                          ),

                          //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                          Positioned(
                            top: 145*height,
                            left: 220*width,

                            child: Container(
                              width: 120*width,
                              height: 36*height,

                              //사용자가 선택한 날짜를 띄워주는 Text
                              child : Text(_dateTime_exit_room_time == null ? '' : _dateTime_exit_room_time.toString().substring(0,10)),

                            ),
                          ),

                          //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                          Positioned(
                            top: 180*height,
                            left: 14*width,

                            child: Container(
                                width: 120*width,
                                height: 36*height,

                                //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                child: RaisedButton(
                                  child: Text('날짜 선택'),
                                  onPressed: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: _dateTime_enter_room_time == null ? DateTime.now() : _dateTime_enter_room_time,

                                        //달력내에서 선택할 수 있는 첫 년도이다.
                                        firstDate: DateTime(2020),

                                        //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                        lastDate: DateTime(2024)
                                    ).then((date){
                                      setState((){
                                        _dateTime_enter_room_time=date;
                                        print("입실날짜 "+_dateTime_enter_room_time.toString());

                                      });
                                    });
                                  },
                                )

                            ),
                          ),

                          //사용자가 퇴실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                          Positioned(
                            top: 180*height,
                            left: 220*width,

                            child: Container(
                                width: 120*width,
                                height: 36*height,

                                //사용자가 퇴실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                child: RaisedButton(
                                  child: Text('날짜 선택'),
                                  onPressed: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: _dateTime_exit_room_time == null ? DateTime.now() : _dateTime_exit_room_time,


                                        //달력내에서 선택할 수 있는 첫 년도이다.
                                        firstDate: DateTime(2020),

                                        //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                        lastDate: DateTime(2024)
                                    ).then((date){
                                      setState((){
                                        _dateTime_exit_room_time=date;
                                        print("퇴실날짜 "+_dateTime_exit_room_time.toString());

                                      });
                                    });
                                  },
                                )

                            ),
                          ),


                          //인원수 밑에있는 회색네모박스
                          Positioned(
                              top: 233*height,
                              left: 18*width,



                                  //사용자가 호텔식, 게스트하우스식 무엇을 선택하냐에 따라서 보여지는 UI가 다르다.
                                  child: spinner_condition == true ? new

                                  //드랍다운 버튼을 표현하는 Container 이다. 게스트하우스식을 사용자가 선택하면 이 UI 를 보여준다.
                                  Container(
                                    width: 110*width,
                                    height: 39*height,
                                    child: DropdownButton<String>(

                                      value: dropdownValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.blueAccent,
                                      ),
                                      onChanged: (String data) {
                                        setState(() {
                                          dropdownValue = data;
                                        });
                                      },
                                      items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                        //만약 사용자가 게스트하우스식을 선택했다면 인원수를 설정할 수 있는 UI가 보인다.
                                        if(Variable.sleep_type=="Guest_House"){
                                        }
                                        //만약 사용자가 호텔식을 선택했다면 인원수를 설정할 수 있는 UI가 보이지 않는다.
                                        else{

                                        }
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),


                                  )


                                      //사용자가 호텔식을 선택했을 때 보여질 UI 이다. 인원수가 최대4인까지 선택 가능하다.
                                      : new Container(
                                    width: 120*width,
                                    height: 36*height,


                                    child : Text("최대 4인까지 가능"),
                                  )




                          ),

                          //방의유형을 표현하는 PageController 이다.
                          Positioned(
                              top: 290*height,
                              left: 14*width,
                              child: SingleChildScrollView(
                                  child: Container(
                                  width: 333*width,
                                  height: 200*height,

                                  child: Expanded(
                                      child: Stack(
                                        alignment: AlignmentDirectional.bottomCenter,
                                        children: <Widget>[

                                          //방의 유형을 판별해주는 조건문이다.
                                          _gender.toString() == "Gender.MAN" ?

                                      //움직이는 페이지를 표현한다. (남자 손님들이 봐야하는 페이지)
                                      new PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                        controller: _pageController,
                                        onPageChanged: _onPageChanged,

                                        itemCount: man_type.length,
                                        //itemCount: woman_type.length,
                                        itemBuilder: (ctx, i) => SlideItem(i),
                                      ) :

                                          //움직이는 페이지를 표현한다. (여자 손님들이 봐야하는 페이지)
                                          new PageView.builder(
                                            scrollDirection: Axis.horizontal,
                                            controller: _pageController,
                                            onPageChanged: _onPageChanged,
                                            //check point

                                            itemCount: woman_type.length,
                                            //itemCount: man_type.length,
                                            itemBuilder: (ctx, i) => SlideItem(i),
                                          ),

                                      Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: <Widget>[


                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[


                      ],
                    )

                  ],
          )
        ],
      ),
    ),

                              )),
                          ),

                          Positioned(
                              top: 540*height,
                              left: 230*width,
                              child:
                              RaisedButton(
                                child: Text('검색하기', style: TextStyle(fontSize: 24)),
                                onPressed: () =>
                                {
                                time_differ=_dateTime_exit_room_time.difference(_dateTime_enter_room_time).toString(),
                                  print(time_differ),
                                 idx = time_differ.indexOf(":"),
                                 gap = time_differ.substring(0, idx),
                              time_differ_Integer=int.parse(gap),
                                time_differ_Integer=time_differ_Integer~/24,
                                print("퇴실일과 입실일의 차이"),
                                print(time_differ_Integer),



                                Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) =>




                                      Booking_room(

                                          search_condition: widget.type,
                                          guest_gender: _gender.toString(),
                                          exit_room_time: _dateTime_exit_room_time.toString().substring(0, 10),
                                          enter_room_time: _dateTime_enter_room_time.toString().substring(0, 10),
                                          room_type: _currentPage.toString(),
                                          supply: dropdownValue,
                                          time_differ: time_differ_Integer)),
                                ),

                                }

                              ),

                              
                          ),

                        ],
                      ),
                    ),

                  ],
                ),

              )


            ],
          )


      ),

        ),),);
  }
}

