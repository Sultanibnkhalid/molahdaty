import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
 
void showToast({String? text, Color color = Colors.black, context}){
  
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(text!.tr(),
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      
    ),textAlign: TextAlign.center,),
    
    duration: const Duration(seconds: 2),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
}