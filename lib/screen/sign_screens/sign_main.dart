import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/home_slide_item.dart';
import '../../model/homeSlide.dart';
import '../../widgets/home_slide_dots.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

enum AuthFormType { signIn, sinUp, reset}

class GettingStartedScreen extends StatefulWidget {
  final AuthFormType authFormType;

  GettingStartedScreen({Key key, @required this.authFormType}) : super(key: key);



  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  AuthFormType authFormType;

  _GettingStartedScreenState({this.authFormType});

  final formKey = GlobalKey<FormState>();

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
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

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double hi = MediaQuery.of(context).size.height;//기기의 세로길이
    double wi = MediaQuery.of(context).size.width;//기기의 가로길이
    double ratio = (hi+wi)/2;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => HomeSlideItem(i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  HomeSlideDots(true)
                                else
                                  HomeSlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/20,

                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                    color: Color.fromRGBO(133, 192, 64, 80),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                  ),
                  SizedBox(height: hi/60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '아이디가 없으세요?',
                        style: TextStyle(
                          fontSize:  ratio/50,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          '회원가입',
                          style: TextStyle(fontSize: ratio/45,fontWeight: FontWeight.w900),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(SignupScreen.routeName);
                        },
                      ),

                      FlatButton(
                        child: Text(
                          '비밀번호를 잊으셨나요?',
                          style: TextStyle(fontSize: ratio/60,fontWeight: FontWeight.w900),
                        ),
                        onPressed: (){
                          setState(() {
                            authFormType = AuthFormType.reset;
                          });
                        },
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
//  Widget showForgotPassword(bool visible){
//    return FlatButton(
//      child: Text(
//        '비밀번호를 잊으셨나요?',
//        style: TextStyle(fontSize: ratio/45,fontWeight: FontWeight.w900),
//      ),
//      onPressed: (){
//        setState(() {
//          authFormType = AuthFormType.reset;
//        });
//      },
//    )
  }
