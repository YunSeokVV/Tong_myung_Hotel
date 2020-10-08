import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:tong_myung_hotel/screen/book_screens/booking_room.dart';

class CurrentUser extends ChangeNotifier {

  //현재 로그인한 사용자의 uid 를 담는다.
  static String login_user_uid;

  String _uid;
  String _email;
  String _phone;

  String get getUid => _uid;

  String get getEmail => _email;

  String get getPhone => _phone;

  FirebaseAuth _auth = FirebaseAuth.instance;

  BuildContext get context => null;


  Future updatePhoto(String photo, FirebaseUser currentUser) async{
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.photoUrl = photo;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future<String> signUpUser(String name, String email, String password, String phone) async {
    String retVal = 'error';
    String checkIn = ''; // 입실일
    String checkOut = ''; // 퇴실일
    String roomType = '0'; // 방 유형
    String people =''; // 예약 인원 수


    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_authResult.user != null) {
        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
       //Firestore.instance.collection('Users').add({'name':name, 'email': email, 'phone': phone, '방 유형': roomType, '입실일': checkIn, '퇴실일': checkOut});
        Firestore.instance.collection('Users').document(_uid).setData({'name':name, 'email': email, 'phone': phone, '방 유형': roomType,'인원': people, '입실일': checkIn, '퇴실일': checkOut});

        await updateUserName(name, _authResult.user);
        retVal = "success";
      }
    }
//  catch(e){
//      retVal = e.massage;
//  }
    catch(signUpError){
      if(signUpError is PlatformException){
        if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
        }
      }
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async{
    String retVal = 'error';

    try{
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(_authResult.user != null){
        _uid = _authResult.user.uid;

        login_user_uid=_uid;
        print("login_user_uid");
        print(login_user_uid);
        _email = _authResult.user.email;
        retVal = 'success';


      }

    }catch(e){
      retVal = e.message;
    }
    return retVal;
  }


  Future<String> loginUserWithGoogle(String email, String password) async{
    String retVal = 'error';
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try{
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential =  GoogleAuthProvider.getCredential(idToken: (_googleAuth.idToken), accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      if(_authResult.user != null){
        _uid = _authResult.user.uid;
        login_user_uid=_uid;
        print("login_user_uid");
        print(login_user_uid);
        _email = _authResult.user.email;
        retVal = 'success';
      }

    }catch(e){
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> getCurrentUID() async{
    return (await _auth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async{
    return await _auth.currentUser();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> getCurrentName() async{
 return (await _auth.currentUser()).displayName.toString();
  }

  // Sign Out
  signOut() {
    return _auth.signOut();
  }
}



