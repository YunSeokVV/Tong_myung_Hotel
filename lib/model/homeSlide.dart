import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/tu_logo.png',
    title: 'Welcome',
    description: '동명대학교 숙박 예약앱입니다',
  ),
  Slide(
    imageUrl: 'assets/images/nightschool.jpg',
    title: 'Experience',
    description: '새로운 경험을 할 수 있습니다',
  ),
  Slide(
    imageUrl: 'assets/images/gwangan.jpg',
    title: 'Travel',
    description: '동명대학교와 함께 여행을 떠나요',
  ),

];
