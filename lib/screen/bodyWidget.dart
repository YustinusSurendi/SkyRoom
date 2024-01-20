import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MyBodyWidget extends StatefulWidget {
  String? image;
  double value = 0;
  MyBodyWidget({super.key, this.image, required this.value});

  @override
  State<MyBodyWidget> createState() => _MyBodyWidgetState();
}

class _MyBodyWidgetState extends State<MyBodyWidget> {
  late SharedPreferences prefs;
  final String _keyScore = 'score';
  final String _keyImage = 'image';

  String? image;
  double score = 0;
  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      score = (prefs.getDouble(_keyScore) ?? 0);
      widget.image ??= prefs.getString(_keyImage);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: widget.image != null
                ? Image.file(
                    File(widget.image!),
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    width: 200,
                    height: 200,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey[500],
                                ),
                                CircularProgressIndicator(
                                  value: widget.value,
                                  color: Colors.grey,
                                ),
                              ],
                            )))),
          ),
        ]),
      ),
    );
  }
}
