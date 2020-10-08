import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_Write.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/reviewList.dart';

class Review extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const Review(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
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
  var _star;
  var _note;
  String _reviewName;
  Color green1 = Color.fromRGBO(133, 192, 64, 100);
  Color green2 = Color.fromRGBO(57, 103, 66, 10);




  @override
  Widget build(BuildContext context) {
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

            Firestore.instance.collection('Users').document().get().then((DocumentSnapshot ds){

            });

            Firestore.instance //현재 로그인 된 Uid의 Users 문서의 필드 값을 가져옴
                .collection('Reviews')
                .document()
                .get()
                .then((DocumentSnapshot ds) {
                  _note = ds.data['note'];
                  _star = ds.data['starRate'];
                  _roomName = ds.data['방유형'];
                  _reviewName = ds.data['name'];

//              if (_book == '1' ||
//                  _book == '2' ||
//                  _book == '7' ||
//                  _book == '8') // 방 유형 번호에 따른 사진출력
//                _imageUrl = 'gs://tu-domi.appspot.com/room_type/three_room.png';
//              else if (_book == '3' ||
//                  _book == '4' ||
//                  _book == '9' ||
//                  _book == '10')
//                _imageUrl = 'gs://tu-domi.appspot.com/room_type/two_room.png';
//              else if (_book == '5' || _book == '6')
//                _imageUrl = 'gs://tu-domi.appspot.com/room_type/four_room.png';
//
//              switch (_book) {
//                // 방 유형 번호에 따른 방 이름 지정
//                case '1':
//                  _roomName = '남성 3인 도미토리';
//                  break;
//                case '2':
//                  _roomName = '남성 3인실';
//                  break;
//                case '3':
//                  _roomName = '남성 2인 도미토리';
//                  break;
//                case '4':
//                  _roomName = '남성 2인실';
//                  break;
//                case '5':
//                  _roomName = '여성 4인 도미토리';
//                  break;
//                case '6':
//                  _roomName = '여성 4인실';
//                  break;
//                case '7':
//                  _roomName = '여성 3인 도미토리';
//                  break;
//                case '8':
//                  _roomName = '여성 3인실';
//                  break;
//                case '9':
//                  _roomName = '여성 2인 도미토리';
//                  break;
//                case '10':
//                  _roomName = '여성 2인실';
//                  break;
//              }
            });
            return SingleChildScrollView(
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 13,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Review',
                        style: TextStyle(
                            fontSize: 60,
                            color: green2,
                            fontFamily: 'Balsamiq')),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                  child:Text('동명대학교 숙박\n\n소중한 후기를 남겨주세요.',textAlign: TextAlign.center,),),
                  SizedBox(
                    height: height / 10,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
,                        ),
                        color: green1,
                        child: Text('리뷰작성',style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ReviewWrite()));
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                  FeedPage(),
                  Row(children: [
//                    SmoothStarRating(
//                      //rating: rating,
//                      isReadOnly: true,
//                      size: 30,
//                      filledIconData: Icons.star,
//                      halfFilledIconData: Icons.star_half,
//                      defaultIconData: Icons.star_border,
//                      starCount: 5,
//                      rating: _star,
//                      allowHalfRating: true,
//                      spacing: 2.0,
//                      onRated: (value){
//                        print("rating value -> $value");
//                      },
//                    )
                  ],

                  ),
                ],
              ),
            );
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }
}
