import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source)async{
  final ImagePicker imagePicker = ImagePicker();
  XFile? _file = await imagePicker.pickImage(source: source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  
    Fluttertoast.showToast(msg: "Image Not Selected");
  
}