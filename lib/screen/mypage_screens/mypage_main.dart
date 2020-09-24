import 'dart:ui';
import 'package:firebase_image/firebase_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/state/authentication.dart';
import 'package:tong_myung_hotel/screen/sign_screens/sign_main.dart';
import 'package:tong_myung_hotel/state/auth_services.dart';
import 'package:tong_myung_hotel/state/current_State.dart';


class MyPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const MyPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  void initState(){
      super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isEnabled = false;

//  Future<String> getUserData() async {
//    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
//  setState(() {
//   user = userData;
//    return user.displayName;
//  });
//  }
  String _uid;
  String _name; // auth 이름
  String _fieldName; // Users의 필드 항목에서 이름
  String _password;
  String _checkIn;
  String _checkOut;
  String _people;
  String _email;
  String _phone;
  String _book; // 방 유형 숫자
  String _imageUrl; // 방 사진 url
  String _roomName; // 방 이름
  Color green1 = Color.fromRGBO(133, 192, 64, 100);
  Color green2 =  Color.fromRGBO(57, 103, 66, 10);



  getRoomImage(var imageNum) async {
  var iN;
  String url_real;
  iN = imageNum;
  if(iN == '1'|| iN=='2' || iN=='7'|| iN=='8'){
    final ref = FirebaseStorage.instance.ref().child('room_type/three_room.png');
       dynamic url = await ref.getDownloadURL();
       print(url);
    url_real = url;
  }
  else if(iN == '3'||iN == '4'||iN == '9'||iN == '10'){
    final ref = FirebaseStorage.instance.ref().child('room_type/two_room.png');
    dynamic url = await ref.getDownloadURL();
    url_real = url;
  }
  else if(iN == '5'||iN =='6'){
    final ref = FirebaseStorage.instance.ref().child('room_type/four_room.png');
      dynamic url = await ref.getDownloadURL();
    url_real = url;
  }
  return url_real;

//
//
//    switch(image_name){
//      case '1':
//        final ref = FirebaseStorage.instance.ref().child('room_type/four_room.png');
//        var url = await ref.getDownloadURL();
//        return url;
//        break;
//      case 'room_type/three_room.png':
//        final ref = FirebaseStorage.instance.ref().child('room_type/three_room.png');
////        var url = await ref.getDownloadURL();
////        return url;
////        break;
//      case 'room_type/two_room.png':
//        final ref = FirebaseStorage.instance.ref().child('room_type/two_room.png');
//        var url = await ref.getDownloadURL();
//        return url;
//        break;
//    }
  }

  Future deleteUser() async {
    //회원탈퇴
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
    Firestore.instance.collection('Users').document(_uid).delete();
  }

  Future updateUser(String email, String name) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUpdateInfo = UserUpdateInfo();
    user.updateEmail(email);
    userUpdateInfo.displayName = name;
    Firestore.instance
        .collection('Users')
        .document(_uid)
        .updateData({'name': name, 'email': email});
    await user.updateProfile(userUpdateInfo);
    await user.reload();
  }


  @override
  Widget build(BuildContext context) {
//    setState(() { // get phoneNumber
//      Firestore.instance.collection('Users').document(_uid).get().then((DocumentSnapshot ds){
//        _phone = ds.data['phone'];
//      });
//    });

    FirebaseAuth auth;
    FirebaseUser user;

    FirebaseAuth _auth = FirebaseAuth.instance;



    var height = MediaQuery.of(context).size.height;

    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            _uid = snapshot.data.uid;
            _name = snapshot.data.displayName;
            _email = snapshot.data.email;

            Firestore.instance
                .collection('Users')
                .document(_uid)
                .get()
                .then((DocumentSnapshot ds) {
              _fieldName = ds.data['name'];
              _book = ds.data['방 유형'];
              _checkIn = ds.data['입실일'];
              _checkOut = ds.data['퇴실일'];
              _phone  = ds.data['phone'];
              if(_book=='1' || _book=='2'|| _book=='7'|| _book=='8') // 방 유형 번호에 따른 사진출력
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/three_room.png';
              else if(_book =='3'||_book=='4'||_book=='9'||_book=='10')
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/two_room.png';
              else if(_book =='5'||_book=='6')
                _imageUrl = 'gs://tu-domi.appspot.com/room_type/four_room.png';

              switch(_book) { // 방 유형 번호에 따른 방 이름 지정
                case '1':
                  _roomName = '남성 3인 도미토리';
                  break;
                case '2':
                  _roomName = '남성 3인실';
                  break;
                case '3':
                  _roomName = '남성 2인 도미토리';
                  break;
                case '4':
                  _roomName = '남성 2인실';
                  break;
                case '5':
                  _roomName = '여성 4인 도미토리';
                  break;
                case '6':
                  _roomName = '여성 4인실';
                  break;
                case '7':
                  _roomName = '여성 3인 도미토리';
                  break;
                case '8':
                  _roomName = '여성 3인실';
                  break;
                case '9':
                  _roomName = '여성 2인 도미토리';
                  break;
                case '10':
                  _roomName = '여성 2인실';
                  break;
              }




                }


            );
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MyPage',
                    style: TextStyle(fontSize: 60),
                  ),
                  SizedBox(height: height / 20),
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => setState(() {
                        _isEnabled = !_isEnabled;
//
//                      if(_isEnabled){
//                        FirebaseUser currentUser;
//                        UserUpdateInfo user = UserUpdateInfo();
//                        user.displayName = _usernameController.text;
//                        currentUser.updateProfile(user);
//                        currentUser.reload();
//                      }
                      }),
                      icon: Icon(Icons.border_color),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '이름',
                      )),
                  TextFormField(
                    controller: _usernameController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
                      ),
                      hintText: '$_name',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: height / 30),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '이메일',
                      )),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
                      ),
                      hintText: '$_email',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: height / 30),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '전화번호',
                      )),
                  TextFormField(
                    controller: _phoneController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
                      ),
                      hintText: '$_phone',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: height / 20),
                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(133, 192, 64, 100),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          child: Row(children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            Text(
                              '저장',
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                          onPressed: () {
                            showDialog(context: context,builder: (context){
                              return AlertDialog(
                                content: Text('저장하시겠습니까?'),
                                actions: [
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: (){
                                      setState(() {
                                        if (_usernameController.text.isNotEmpty){
                                          Firestore.instance
                                              .collection('Users')
                                              .document(_uid)
                                              .updateData(
                                              {'name': _usernameController.text});

                                          //updateUserName(_usernameController.text, user);
                                        }
                                        if (_emailController.text.isNotEmpty && _emailController.text != _email){
                                          Firestore.instance
                                              .collection('Users')
                                              .document(_uid)
                                              .updateData({'email': _emailController.text});

                                          Auth().changeEmail(_emailController.text);
                                          //await _auth.signOut();
//                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
//                                          Navigator.of(context,
//                                              rootNavigator: true)
//                                              .pushReplacement(MaterialPageRoute(
//                                              builder: (context) =>
//                                              new GettingStartedScreen()));

                                              } else if(_emailController.text.isNotEmpty && _emailController.text == _email)
                                                return showDialog(context: context,builder: (context){
                                                  return Dialog(
                                                    child: Text('같은 이메일로 변경할 수 없습니다..'),
                                                  );
                                                });

                                        if (_phoneController.text.isNotEmpty)
                                          Firestore.instance
                                              .collection('Users')
                                              .document(_uid)
                                              .updateData({'phone': _phoneController.text});
//
                                        updateUser(
                                            _emailController.text,
                                            _usernameController.text,
                                           );

                                        _isEnabled = false; // 텍스트 수정 불가하게게

                                   Navigator.of(context).pop();

                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });

                          },
                        ),
                      ),
                      SizedBox(width: width / 4.7),
                      Container(
                          //width: width/3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(57, 103, 66, 10),
                          ),
                          child: FlatButton(
                              child: Row(children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                Text(
                                  '예약 조회',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ]),
                              onPressed: () async {
                                if(_book == '0')
                                showDialog(context: context, builder: (context){
                                return Dialog( //예약한 정보가 없을 시 보여주는 팝업창
                                    child: Container(
                                      child: SingleChildScrollView(
                                      child: Column(children:[
                                        Icon(Icons.close,size: width/10,color: Colors.red,),Text('예약 정보가 없습니다.',style: TextStyle(fontSize: width/20),)]))
                                    ),
                                  );
                                });
                                else return  showDialog(context: context, builder: (context){
                                  return Dialog( // 예약한 방이 있을 시 보여주는 팝업창
                                    child: Container(
                                        width: width/1.5,
                                        height: height/1.45,
                                        child: SingleChildScrollView(
                                            child: Column(
                                                children:[
                                                  AppBar(
                                                    backgroundColor: Color.fromRGBO(133, 192, 64, 100),
                                                    toolbarHeight: height/40,
                                                    automaticallyImplyLeading: false,
                                                    shadowColor: Colors.transparent,
                                                  ),
                                                 // SizedBox(height: height/40,),
                                                  Container(
                                                    child: FlatButton(
                                                      padding: EdgeInsets.only(left: width/1.8),
                                                      child: Text('예약취소'),
                                                      onPressed: (){
                                                        showDialog(context: context,builder: (context){
                                                          return AlertDialog(
                                                            title: Text('예약취소'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: [
                                                                  Text('예약을 취소하시겠습니까?'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              FlatButton(
                                                                child: Text('OK'),
                                                                onPressed: (){
                                                                 setState(() {
                                                                   Firestore.instance.collection('Users').document(_uid).updateData({'방 유형' :'0', '입실일':'','퇴실일':'','인원':''});
                                                                 });
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();

                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Cancel'),
                                                                onPressed: (){
                                                                Navigator.of(context).pop();
                                                                },
                                                              )
                                                            ],

                                                          );
                                                        });

                                                      },
                                                    ),
                                                  )
                                                 ,
                                                  Image(
                                                    image: FirebaseImage(_imageUrl),
                                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                                                      if(loadingProgress == null) return child;
                                                      return Center(
                                                        child: CircularProgressIndicator(
                                                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress. expectedTotalBytes : null,
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                  SizedBox(height: height/40,),

                                                  Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                        Text('예약자명 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: width/80,),
                                                        Text(_name),
                                                      ]),
                                                  SizedBox(height: height/40,),
                                                  Row( //전화번호
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children:[
                                                      Text('전화번호 :',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      SizedBox(width: width/80,),
                                                  Text(_phone),
                                                  ]),
                                                  SizedBox(height: height/40,),
                                                  Row( //예약 인원
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                        Text('인원 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: width/80,),
                                                        Text('몰라'),
                                                      ]),
                                                  SizedBox(height: height/40,),
                                                  Row( //방 유형
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                        Text('방 유형 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: width/80,),
                                                        Text(_roomName),
                                                      ]),
                                                  SizedBox(height: height/40,),
                                                  Row( //입실일
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                        Text('입실일 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: width/80,),
                                                        Text(_checkIn),
                                                      ]),
                                                  SizedBox(height: height/40,),
                                                  Row( //퇴실일
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:[
                                                        Text('퇴실일 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: width/80,),
                                                        Text(_checkOut),
                                                      ]),

                                                    //mainAxisAlignment: MainAxisAlignment.start,

                                                     SizedBox(height: height/60,),
                                                  Container(
                                                      width: width/3,
                                                      height: height/20,
                                                        decoration: BoxDecoration(
                                                          color: green1,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        //color: green1,
                                                        child: FlatButton(
                                                          child: Text('OK',style: TextStyle(fontSize: width/20,color: Colors.white),),
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: width/20,),



                                                ]))
                                    ),
                                  );
                                });
                                
                              }))
                    ],
                  ),
                  SizedBox(height: height / 20),
                  Container(
                    // 회원탈퇴
                    width: width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(133, 192, 64, 100),
                    ),
                    child: FlatButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_run,
                              color: Colors.white,
                            ),
                            Text(
                              '회원탈퇴',
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('회원탈퇴'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [Text('정말 탈퇴하시겠습니까?')],
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      deleteUser();
                                      Navigator.of(context, rootNavigator: true)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) =>
                                                  new GettingStartedScreen()));
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                  SizedBox(height: height / 50),
                  Container(
                      width: width / 1.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(57, 103, 66, 10),
                      ),
                      child: FlatButton(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_ind,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' 로그아웃',
                                  style: TextStyle(color: Colors.white),
                                )
                              ]),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                   // title: Text('로그아웃'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [Text('로그아웃 하시겠습니까?')],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            await _auth.signOut();
//                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushReplacement(MaterialPageRoute(
                                                    builder: (context) =>
                                                        new GettingStartedScreen()));
                                          }),
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });

//                            await _auth.signOut();
////                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
//                            Navigator.of(context, rootNavigator: true)
//                                .pushReplacement(MaterialPageRoute(
//                                    builder: (context) =>
//                                        new GettingStartedScreen()));
                          }))
                ],
              ),
            ));
          } else {
            return Text('Loading...');
          }
        },
      ),
    );


  }
}
