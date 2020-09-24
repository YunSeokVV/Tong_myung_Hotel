import 'package:flutter/material.dart';

class HomeSlideDots extends StatelessWidget {
  bool isActive;
  HomeSlideDots(this.isActive);



  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? MediaQuery.of(context).size.height/200 :  MediaQuery.of(context).size.height/200,
      width: isActive ?  MediaQuery.of(context).size.width/15:  MediaQuery.of(context).size.width/30,
      decoration: BoxDecoration(
        color: isActive ? Color.fromRGBO(52, 160, 74, 100) : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}