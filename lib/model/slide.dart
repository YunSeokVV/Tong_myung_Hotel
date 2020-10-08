//예약하기화면에서 사용자가 방의유형을 선택할 때 사용하는 slide 이다.

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

// Tip : read_me 파일을 확인하면 동명대학교 기숙사의 건물구조를 알 수 있다.

final man_type = [
  Slide(
    imageUrl: 'assets/images/1호관1유형.png',
    title: '',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/images/1호관2유형.png',
    title: '',
    description: '',
  ),
];

final woman_type = [
  Slide(
    imageUrl: 'assets/images/1호관1유형.png',
    title: '',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/images/1호관2유형.png',
    title: '',
    description: '',
  ),
//  Slide(
//    imageUrl: 'assets/images/2호관1유형.png',
//    title: '',
//    description: '',
//  ),
  Slide(
    imageUrl: 'assets/images/2호관2유형.png',
    title: '',
    description: '',
  ),
];