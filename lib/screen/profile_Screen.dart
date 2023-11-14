import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_heimdall/screen/bodyWidget.dart';
import 'package:project_heimdall/screen/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_heimdall/firebase_auth/auth.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  late AuthFirebase auth;
  final ImagePicker _picker = ImagePicker();
  final String _keyImage = 'image';
  final String _keyScore = 'score';

  var streamController = StreamController<double>();
  XFile? image;
  double score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.black,
        ),
        body: Column(children: [
          StreamBuilder(
              stream: streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("object : waiting");
                  return Column(children: [
                    MyBodyWidget(
                      image: null,
                      value: 0.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            _setImage(image?.path);
                            startStream();
                          },
                          child: const Text("Take Image")),
                    ),
                  ]);
                } else if (snapshot.connectionState == ConnectionState.active) {
                  print("object : active");
                  return Column(children: [
                    MyBodyWidget(image: null, value: snapshot.data!),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: null, child: Text("Take Image")),
                    ),
                  ]);
                } else if (snapshot.connectionState == ConnectionState.done) {
                  print("object : Done");
                  return Column(children: [
                    MyBodyWidget(image: image?.path, value: 1.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            _setImage(image?.path);
                            setState(() {
                              streamController = StreamController<double>();
                            });
                            startStream();
                          },
                          child: const Text("Take Image")),
                    ),
                  ]);
                }
                return const Center();
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 150,
              height: 50,
              margin: const EdgeInsets.only(top: 100),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // auth.signOut();
                    AuthFirebase().signOut().then((result) {
                      if (result == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Berhasi Sign Out'),
                          backgroundColor: Colors.green,
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Berhasil Sign Out',
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.green,
                        ));
                      }
                    });
                  });
                },
                child: const Text(
                  'Logout',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Colors.red),
              ),
            ),
          ),
        ]));
  }

  Future<void> _setImage(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null)
      setState(() {
        prefs.setString(_keyImage, value);
      });
  }

  Future<void> _setScore(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble(_keyScore, value);
      score = ((prefs.getDouble(_keyScore) ?? 0));
    });
  }

  startStream() async {
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 1), () async {
        streamController.add(i / 3);
      });
    }
    streamController.close();
  }
}
