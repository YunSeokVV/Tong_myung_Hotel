import 'package:flutter/material.dart';

import '../model/homeSlide.dart';

class HomeSlideItem extends StatelessWidget {
  final int index;
  HomeSlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width:  MediaQuery.of(context).size.width/1.5,
          height:  MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/20,
        ),
        Text(
          slideList[index].title,
          style: TextStyle(
            fontSize:  MediaQuery.of(context).size.width/10,
            color: Color.fromRGBO(57, 103, 66, 100),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          slideList[index].description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize:  MediaQuery.of(context).size.width/25),
        ),
      ],
    );
  }
}
