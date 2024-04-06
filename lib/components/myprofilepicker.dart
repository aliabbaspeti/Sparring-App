import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparing_partners/components/Utils.dart';
import 'package:sparing_partners/components/colors.dart';
import 'package:sparing_partners/resources/add_data.dart';

class myprofileimagepicker extends StatefulWidget {
  const myprofileimagepicker({super.key});

  @override
  State<myprofileimagepicker> createState() => myprofileimagepickerState();
}

class myprofileimagepickerState extends State<myprofileimagepicker> {
  Uint8List? _image;
  void selectImage () async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
    _image = img;  
    });
    
  }

  void saveprofile()async{
    String resp = await Storedata().saveData(file: _image!);
    

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: appcolors.orangeColor,
                width: 2,
              ),
            ),
            child: 
            _image != null ?
            CircleAvatar(
              radius: 80,
              backgroundImage: MemoryImage(_image!),
            )
            :
            const CircleAvatar(
              backgroundImage:
                  AssetImage("lib/Asset/img/twoplayersshadow.png"),
              backgroundColor: Colors.white12,
              radius: 80,
            ),
          ),
          Positioned(
          bottom: 0,
          right: 5,
          child: SizedBox(
            height: 40,
            child: InkWell(
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                // maxRadius: 40,
                child: Icon(Icons.add_a_photo,
                    size: 30,
                    color: appcolors
                        .orangeColor // ICON THAT SHOWS BELOW CIRCLE SHAPE
                    ),
              ),
              onTap: () {
                selectImage();
Fluttertoast.showToast(msg: "in Process");
              },
            ),
          ),
        ),
        
  ]);
  }
}