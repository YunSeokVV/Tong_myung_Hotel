import 'package:tong_myung_hotel/state/current_State.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tong_myung_hotel/widgets/custom-widget-tabs.widget.dart';

import '../book_screens/select_booking_condition.dart';

//현재 로그인한 사용자의 UID를 보고싶다면 current_State로 갈것.

enum LoginType{
  email,
  google,
}
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  //final globalKey = GlobalKey<ScaffoldState>();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser({@required LoginType type, String email, String password, BuildContext context}) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {

      String _returnString;

      switch(type){
        case LoginType.email:

          _returnString = await _currentUser.loginUserWithEmail(email, password);


          break;
        case LoginType.google:

          _returnString  = await _currentUser.loginUserWithGoogle(email,password);

          break;
        default:
      }

      if (_returnString == 'success') {

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CustomWidgetExample()));

      }else{
//        Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text(_returnString),
//              duration: Duration(seconds: 2),
//            )
//        );
      scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('아이디 또는 비밀번호를 확인하세요'),
              duration: Duration(seconds: 2),
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _googleButton(){//구글로그인 버튼

    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4.5, 0, MediaQuery.of(context).size.width/4.5, 0),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: (){
          _loginUser(type: LoginType.google, context: context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding : const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assets/images/google.png"),height: MediaQuery.of(context).size.height/40),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            )
        ),

      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    double ratio = (wi+hi)/2;

    return Scaffold(
     //backgroundColor: Colors.transparent,
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/25),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: ratio/30 ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Container(
       //color: Colors.white,
        width: wi,
        height: hi,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: hi/10,),
            Text('시작하기',//Login 텍스트
            style: TextStyle(fontSize: ratio/10,fontWeight: FontWeight.bold,color: Colors.green),textAlign: TextAlign.center,),
            SizedBox(height: hi/15,),
            SizedBox(
              height: hi/30,
            ),
            Padding( // 이메일 입력란
              padding: const EdgeInsets.fromLTRB(30,0,30,30),
              child: TextField(
                style: TextStyle(fontSize: ratio/30, color: Colors.black54),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email,size: wi/20,color: Colors.black54,),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: ' Email',
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                controller: _emailController,
              ),
            ),
//                SizedBox(
//                  height: MediaQuery.of(context).size.height/150,
//                ),
            Padding( // 패스워드 입력란
              padding: const EdgeInsets.fromLTRB(30,0,30,0),
              child: TextField(
                obscureText: true,
                style: TextStyle(fontSize: ratio/30, color: Colors.black54),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline,size: wi/20,color: Colors.black54,),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: ' Password',
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                controller: _passwordController,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4.5,0,MediaQuery.of(context).size.width/4.5,0),
              child: FlatButton(//로그인 버튼
                color: Color.fromRGBO(133, 192, 64, 80),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/20
                  ),
                ),
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: const EdgeInsets.all(5),
                textColor: Colors.white,
                onPressed: () {
                  _loginUser(type: LoginType.email, email: _emailController.text, password: _passwordController.text,context: context);
                },
              ),
            ),
            SizedBox(
              height: hi/80,
            ),
            _googleButton(),


          ]),

        ),
      );
  }
}
