import 'package:tong_myung_hotel/state/currentUser.dart';
import 'package:tong_myung_hotel/state/current_State.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tong_myung_hotel/widgets/custom-widget-tabs.widget.dart';
import '../book_screens/select_booking_condition.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signUpKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();


  CurrentUser _currentUser;

  void _signUpUser(String name, String email, String password, String phone, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(
        context, listen: false); //context는 무엇?

    try {
      String _returnString = await _currentUser.signUpUser(name, email, password, phone);
      if (_returnString == 'success') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>CustomWidgetExample()));

      }else{
//        Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text(_returnString),
//              duration: Duration(seconds: 2),
//            )
//        );
        signUpKey.currentState.showSnackBar(SnackBar(
          content: Text('이미 존재하는 이메일입니다.'),
          duration: Duration(seconds: 2),
        ));
      }
    }

    catch (e) {

    }
  }


  @override
  Widget build(BuildContext context) {
    double wi= MediaQuery.of(context).size.width;
    double hi= MediaQuery.of(context).size.height;
    double ratio = (wi+hi)/2;
    return Scaffold(
      key: signUpKey,
      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        // title: Text('Login'),
//        elevation: 0,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back_ios),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ),
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
           //color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/signup_logo.gif',
                      height: hi/5,
                      width: wi/5,
                    ),  //TU 로고이미지
                    SizedBox(
                      height: hi/20,
                    ),
                    TextFormField( // Email 주소 입력란
                      style: TextStyle(fontSize: wi/20, color: Colors.black54),
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: Colors.white,
//                       hintText: 'Email Address',
//                        contentPadding: const EdgeInsets.all(15),
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                      ),
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
                      validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField( // 이름 입력란
                      style: TextStyle(fontSize: wi/20, color: Colors.black54),
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: Colors.white,
//                        hintText: 'Username',
//                        contentPadding: const EdgeInsets.all(15),
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        enabledBorder: UnderlineInputBorder(

//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline,size: wi/20,color: Colors.black54,),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' Username',
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
                      controller: _usernameController,
                      validator: (val) => val.isEmpty ? 'Enter an Full Name' : null,
                    ),
                    SizedBox(height: 20,),
                    TextFormField( // 전화번호 입력란
                      style: TextStyle(fontSize: wi/20, color: Colors.black54),
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: Colors.white,
//                        hintText: 'Password',
//                        contentPadding: const EdgeInsets.all(15),
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone,size: wi/20,color: Colors.black54,),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' Phone Number',
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
                      controller: _phoneController,
                      validator: (val) => val.isEmpty ? 'Enter an phoneNumber' : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField( // 비밀번호 입력란
                      obscureText: true,
                      style: TextStyle(fontSize: wi/20, color: Colors.black54),
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: Colors.white,
//                        hintText: 'Password',
//                        contentPadding: const EdgeInsets.all(15),
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline,size: wi/20,color: Colors.black54,),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password 6자 이상',
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
                      validator: (val) => val.isEmpty ? 'Enter an Full Name' : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(//비밀번호 확인 입력란
                      obscureText: true,
                      style: TextStyle(fontSize: wi/20, color: Colors.black54),
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: Colors.white,
//                        hintText: 'Confirm Password',
//                        contentPadding: const EdgeInsets.all(15),
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white),
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,size: wi/20,color: Colors.black54,),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' Password Confirm',
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
                      controller: _confirmPasswordController,
                      validator: (val) => val.isEmpty ? 'Enter an Full Name' : null,
                    ),
                    SizedBox(
                      height: hi/20,
                    ),
                    FlatButton(
                      color: Color.fromRGBO(133, 192, 64, 80),
                      child: Text(
                        '가입하기',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/15,
                        ),
                      ),
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(color:Color.fromRGBO(133, 192, 64, 80)),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(15),
                      textColor: Colors.white,
                      onPressed: () {
                                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                              _signUpUser(_usernameController.text,_emailController.text, _passwordController.text, _phoneController.text,
                               context);
                                     }
                         else if(_passwordController.text !=
                                          _confirmPasswordController.text){
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(content: Text(
                                                "패스워드를 확인하세요"),
                                              //화면 하단에  잠깐  나오는 오류 바
                                              duration: Duration(seconds: 2),)
                                        );
                                      }
                         else{
                           showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Alert Dialog"),
                                              content: Text("Dialog Content"),
                                            );
                                          }
                                      );

                                      }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
