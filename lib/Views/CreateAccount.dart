// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparing_partners/Views/HomePage.dart';
import 'package:sparing_partners/Views/Login.dart';
import 'package:sparing_partners/components/button.dart';
import 'package:sparing_partners/components/checkbox.dart';
import 'package:sparing_partners/components/colors.dart';
import 'package:sparing_partners/components/cus_text.dart';
// import 'package:sparing_partners/components/profile_image_picker.dart';
import 'package:sparing_partners/components/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullnametextcontroller = TextEditingController();
  TextEditingController emailtextcontroller = TextEditingController();
  TextEditingController passwordtextcontroller = TextEditingController();
  TextEditingController confirmpasstextcontroller = TextEditingController();
  TextEditingController locationtextcontroller = TextEditingController();
  List<bool> checkboxStates = List.filled(19, false);
  String? _userLocation;
  final firestore = FirebaseFirestore.instance.collection("Users");
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? image;
  final picker = ImagePicker();

  Future getImageGalley() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(
      () {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          debugPrint("No image picked");
          Fluttertoast.showToast(
            msg: "No Image Picked",
            backgroundColor: Colors.red,
          );
        }
      },
    );
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle case when user denies location permissions
      Fluttertoast.showToast(
        msg: "Please enable location permissions to use this feature.",
        backgroundColor: appcolors.orangeColor,
      );
      return;
    }

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Retrieve latitude and longitude
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Update location text field with latitude and longitude
      setState(() {
        locationtextcontroller.text =
            'Latitude: $latitude, Longitude: $longitude';
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error retrieving location: $e",
        backgroundColor: appcolors.orangeColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const CTextBold(
            data: 'Register Here', color: appcolors.textColorwhite),
        backgroundColor: appcolors.orangeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
           

            Center(
              child: InkWell(
                onTap: getImageGalley,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: image != null
                        ? Image.file(image!.absolute)
                        : const Icon(
                            Icons.image,
                            size: 50,
                          ),
                  ),
                ),
              ),
            ),

            CTextField(
                controller: fullnametextcontroller,
                labelText: "Full Name",
                onChanged: (value) {},
                hide: false),
            CTextField(
                controller: emailtextcontroller,
                labelText: "Email",
                onChanged: (value) {},
                hide: false),
            CTextField(
                controller: passwordtextcontroller,
                labelText: "Password",
                onChanged: (value) {},
                hide: true),
            CTextField(
                controller: confirmpasstextcontroller,
                labelText: "Confirm Password",
                onChanged: (value) {},
                hide: true),
            Row(
              children: [
                Expanded(
                  child: CTextField(
                    controller: locationtextcontroller,
                    labelText: "Location",
                    onChanged: (value) {},
                    hide: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: appcolors.orangeColor,
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Getting Location",
                        backgroundColor: appcolors.orangeColor);
                    _getUserLocation();
                  },
                ),
              ],
            ),

            // Categories
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CTextBold(
                  data: "Select Categories:", color: appcolors.textColorblack),
            ),
            Row(
              children: [
                Expanded(
                  child: CcheckBox(
                    label: 'Boxing',
                    onChanged: (value) {
                      setState(() {
                        checkboxStates[0] = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CcheckBox(
                      label: 'Wrestling',
                      onChanged: (value) {
                        setState(() {
                          checkboxStates[1] = value;
                        });
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: 'MMA',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[2] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                        label: 'Jiu Jitsu',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[3] = value;
                          });
                        })),
              ],
            ),
            CcheckBox(
                label: 'Muay Thai',
                onChanged: (value) {
                  setState(() {
                    checkboxStates[4] = value;
                  });
                }),

            // Experience Level
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CTextBold(
                  data: "Experience Level:", color: appcolors.textColorblack),
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: 'Beginner',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[5] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                        label: 'Advance',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[6] = value;
                          });
                        })),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: 'Intermediate',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[7] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                        label: 'Professional',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[8] = value;
                          });
                        })),
              ],
            ),

            // Age
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CTextBold(
                  data: "Select Yor Age Group:",
                  color: appcolors.textColorblack),
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: '18 & Under',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[9] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                        label: '30 - 39',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[10] = value;
                          });
                        })),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: '19 - 29',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[11] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                        label: '40 & Up',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[12] = value;
                          });
                        })),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CTextBold(data: "Sex:", color: appcolors.textColorblack),
            ),
            Row(
              children: [
                Expanded(
                    child: CcheckBox(
                        label: 'Male',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[13] = value;
                          });
                        })),
                Expanded(
                    child: CcheckBox(
                  label: 'Female',
                  onChanged: (value) {
                    setState(() {
                      checkboxStates[14] = value;
                    });
                  },
                )),
                Expanded(
                    child: CcheckBox(
                        label: 'Other',
                        onChanged: (value) {
                          setState(() {
                            checkboxStates[15] = value;
                          });
                        })),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CTextBold(
                  data: "Weight Class:", color: appcolors.textColorblack),
            ),
            Column(
              children: [
                CcheckBox(
                    label: '100 - 120LBS / 45.4 - 54.4KGS',
                    onChanged: (value) {
                      setState(() {
                        checkboxStates[16] = value;
                      });
                    }),
                CcheckBox(
                  label: '140 - 160LBS / 64 - 73KGS',
                  onChanged: (value) {
                    setState(() {
                      checkboxStates[17] = value;
                    });
                  },
                ),
                CcheckBox(
                    label: '160 - 180LBS / 73 - 82KGS',
                    onChanged: (value) {
                      setState(() {
                        checkboxStates[18] = value;
                      });
                    }),
              ],
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Button(
                  buttonname: "Create Account",
                  ontap: () async {
                    if (image == null) {
                      Fluttertoast.showToast(
                        msg: 'Please pick an image',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (fullnametextcontroller.text.isEmpty ||
                        emailtextcontroller.text.isEmpty ||
                        passwordtextcontroller.text.isEmpty ||
                        confirmpasstextcontroller.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Fill All Fields",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: appcolors.orangeColor);
                    } else if (passwordtextcontroller.text !=
                        confirmpasstextcontroller.text) {
                      Fluttertoast.showToast(
                          msg: "Password Not Same",
                          backgroundColor: appcolors.orangeColor);
                    } else {
                      try {
                        // Create user account with email and password
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: emailtextcontroller.text,
                                password: passwordtextcontroller.text);

                        // Get the user's unique ID
                        String userId = userCredential.user!.uid;

                        // Extract data from text controllers
                        String fullName = fullnametextcontroller.text;
                        String email = emailtextcontroller.text;
                        String location = locationtextcontroller.text;
                        debugPrint('Saving Data In Database');
                        // Extract data from checkboxes
                        List<String> categories = [];
                        // Add selected categories to the list
                        if (checkboxStates[0]) categories.add('Boxing');
                        if (checkboxStates[1]) categories.add('Wrestling');
                        if (checkboxStates[2]) categories.add('MMA');
                        if (checkboxStates[3]) categories.add('Jiu Jitsu');
                        if (checkboxStates[4]) categories.add('Muay Thai');

                        List<String> experienceLevels = [];
                        // Add selected experience levels to the list
                        if (checkboxStates[5]) experienceLevels.add('Beginner');
                        if (checkboxStates[6]) experienceLevels.add('Advance');
                        if (checkboxStates[7])
                          experienceLevels.add('Intermediate');
                        if (checkboxStates[8])
                          experienceLevels.add('Professional');

                        List<String> agegroup = [];
                        // Add selected agegroup to the list
                        if (checkboxStates[9]) agegroup.add('18 & Under');
                        if (checkboxStates[10]) agegroup.add('30 - 39');
                        if (checkboxStates[11]) agegroup.add('19 - 29');
                        if (checkboxStates[12]) agegroup.add('40 & Up');

                        List<String> Sex = [];
                        // Add selected Sex to the list
                        if (checkboxStates[13]) Sex.add('Male');
                        if (checkboxStates[14]) Sex.add('Female');
                        if (checkboxStates[15]) Sex.add('Others');

                        List<String> weightclass = [];
                        // Add selected weight Class to the list
                        if (checkboxStates[16])
                          weightclass.add('100 - 120LBS / 45.4 - 54.4KGS');
                        if (checkboxStates[17])
                          weightclass.add('140 - 160LBS / 64 - 73KGS');
                        if (checkboxStates[18])
                          weightclass.add('160 - 180LBS / 73 - 82KGS');

                        final newId = DateTime.now().millisecondsSinceEpoch;

                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref("/users/$newId");

                        firebase_storage.UploadTask uploadTask =
                            ref.putFile(image!.absolute);

                        Future.value(uploadTask).then((value) async {
                          var newUrl = await ref.getDownloadURL();

                          // Create a data map with the extracted values
                          Map<String, dynamic> userData = {
                            'userId': userId,
                            'fullName': fullName,
                            'email': email,
                            'location': location,
                            'userlocation': _userLocation,
                            'categories': categories,
                            'experienceLevels': experienceLevels,
                            'agegroup': agegroup,
                            'Sex': Sex,
                            'weightclass': weightclass,
                            'profile': newUrl,
                            // Add more fields if needed
                          };

                          Future<String> uploadImageToStorage(
                              String childname, Uint8List file) async {
                            Reference ref = _storage.ref().child(childname);
                            UploadTask uploadTask = ref.putData(file);
                            TaskSnapshot snapshot = await uploadTask;
                            String downloadUrl =
                                await snapshot.ref.getDownloadURL();
                            return downloadUrl;
                          }

                          Future<String> saveData({
                            required Uint8List file,
                          }) async {
                            String resp = "Some Error Occurred";
                            try {
                              String imageUrl = await uploadImageToStorage(
                                  'ProfileImage', file);
                              resp = imageUrl;
                            } catch (err) {
                              resp = err.toString();
                            }
                            return resp;
                          }

                          // Store user data in Firestore
                          await firestore.doc(userId).set(userData);
                          debugPrint('DataSaved!');
                          // Show success message
                          Fluttertoast.showToast(
                              msg: "Account created successfully",
                              backgroundColor: Colors.greenAccent);

                          // Navigate to homepage after successful registration
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const homepage()));
                        });
                      } catch (e) {
                        debugPrint('Error creating account: $e');
                        Fluttertoast.showToast(
                            msg: e.toString(), backgroundColor: Colors.red);
                      }
                    }
                  }),
            )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already Register',
                        style: TextStyle(
                            color: appcolors.textColorblack,
                            fontSize: 20,
                            fontFamily: 'kanit',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            color: appcolors.orangeColor,
                            fontSize: 20,
                            fontFamily: 'kanit',
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
