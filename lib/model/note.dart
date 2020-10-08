

//리스트에 사용될 추상클래스가 Note 클래스이다. 파이어베이스 DB 의 id,title,description 이 포함되있다.
class Note {

  String _document_id;

  String _id;
  Map _title;
  String enter_room_time;
  String after_room_time;
  int differ_day;

  //서버에서 받아온 데이터를 담는 list 이다. (각 날짜별로 남은 방,침대의 수)
  static List<Map> day_list = [];

  //서버에서 받아온 데이터의 키값을 document_id, value 값을 날짜로 갖는 Map 이다.
  static Map<String, String> day_docu_id = {};

  // 서버에서 받아온 데이터의 document_id 의 값을 이 list 에 담아준다.
  static List<String> document_id_list = List<String>();

  //Note 클래스의 생성자이다.
  Note(this._document_id,this._title,this.enter_room_time,this.after_room_time,this.differ_day);

  Note.map(dynamic obj) {
    print("Note.map 호출");

    this._document_id=obj['document_id'];
    this._id = obj['id'];
    this._title = obj['xxx'];
  }

  String get document_id => _document_id;
  String get id => _id;
  Map get title => _title;

  // (공홈) dynamic : Dart supports generic types, like List<int> (a list of integers) or List<dynamic> (a list of objects of any type).
  // (공홈)When you want to explicitly say that no type is expected, use the special type dynamic. (이걸 읽을것)
  //이 메소드는 Map 에 사용자의 id, title, description 을 대입한다. 그리고 Map 객체를 리턴한다.
  Map<String, dynamic> toMap(String enter_room_time,String after_room_time,int differ_day) {
    print("toMap 호출");
    var map = new Map<String, dynamic>();

    if (_document_id != null) {
      print("toMap 에서 if 조건문 탐");
      map['document_id'] = _document_id;
    }
    map['enter_room_day'] = enter_room_time.substring(0,10);

    print(enter_room_time);
    print(after_room_time);
    print(differ_day);

    //exit_room_time: _dateTime_exit_room_time.toString().substring(0, 10)

    print("에러찾기1");

    String day=enter_room_time.substring(0,10);
    print(day);

    print("에러찾기2");
    print("에러찾기3");
    map[day] = _title;
    print("에러찾기4");
    return map;
  }

  //이 메소드는 Map 에 사용자의 id, title, description 을 대입한다. 그리고 Map 객체를 리턴한다. 오직 각날짜에대한 정보를 업데이트할때만 쓴다.
  Map<String, dynamic> toMapforUpdate(String enter_room_time,Map map_) {
    print("toMapforUpdate 호출");
    var map = new Map<String, dynamic>();

    print("_title");
    print(_title);
//
//    if (_document_id != null) {
//      print("toMapforUpdate 에서 if 조건문 탐");
//      map['document_id'] = _document_id;
//    }

    print("enter_room_time 의 값 :");
    print(enter_room_time);

    print("map_ 의 값");
    print(map_);

//    print("day_list[idx] 의 값");
//    print(day_list[idx]);

    map[enter_room_time] = map_;
    //map[enter_room_time] = day_list[몇번째 값];
    print("에러찾기4-1");
    return map;
  }

  //이 메소드는 리스트뷰의 아이템을 불러오는 메소드이다. (서버에서 데이터를 불러올 때 쓰는 메소드이다. 데이터 하나하나를 읽어와준다.)
  Note.fromMap(Map<String, dynamic> map,String enter_room_time,String after_room_time,int differ_day) {
    print("fromMap 메소드가 호출됨");
    print(map.keys.toString().substring(1,11));

    //print("this._document_id 의 값 : "+this._document_id);
    print(enter_room_time);
    print(after_room_time);
    print(differ_day);

    var time = DateTime.parse(enter_room_time);
    print(time.toString().substring(0,10));

//    this._title = map['2020-09-12'];
//    print("this._title 의 값 : "+this._title.toString());

    String enter_room_day;

    for(int i=0;i<differ_day;i++){
      print("fromMap 메소드 안에서 for 문 실행됨");

      enter_room_day=map['enter_room_day'];
      this._document_id=map['document_id'];
      print(i);
      print("this._document_id 의 값 : "+this._document_id);
      print("enter_room_day 의 값 : "+enter_room_day);

      day_docu_id[enter_room_day]=this._document_id;

      if(i==differ_day-1){
        print("로그 확인1");
        document_id_list.add(this._document_id);
        print("로그 확인2");
        print(this._document_id);
        print("로그 확인3");
        print(map.keys.toString().substring(1,11));
        print("로그 확인4");

        //day_docu_id[map.keys.toString().substring(1,11)]=this._document_id;

        print("로그 확인5");

      }


      //document_id_list[i]=this._document_id;

      print(time.toString().substring(0,10));
      this._title = map[time.toString().substring(0,10)];
      print(this._title);
      time=time.add(new Duration(days: 1));

      //서버로부터 받아온 데이터가 null 값이 아닌경우 list 에 담기위해서 아래의 코드를 실행한다.
      String data=this._title.toString().substring(0,1);
      if(data=="{"){
        day_list.add(this._title);
        print("list 의 값 (i 의 값:)"+i.toString());
        print(day_list);
      }

  }



  }

}