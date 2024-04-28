import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NoteModele {
  String? date;
  String? content;
  String color = ColorToHex(Colors.yellow.shade200).toString();
  String? time;
  String? img;
  int id = -1;
  int isLiked = 0;
  Image? imgbata = Image.asset(" assets/images/1.png");
  NoteModele(
      {required this.content,
      required this.date,
      required this.id,
      required this.isLiked,
      required this.color,
      this.time});

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      // 'img': img,
      'color': color,
      'favorite': isLiked,
      'date': date,
      // 'time': time,
    };
  } //()=>end function

  factory NoteModele.fromMap(Map<String, dynamic> map) {
    return NoteModele(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      color: map['color'] ?? '',
      date: map['ti'] ?? '',
      isLiked: map['favorite'] ?? '',
      time: map['ti'] ?? '',
    );
  } //()=>end function
}
