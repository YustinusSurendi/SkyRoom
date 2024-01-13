import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sky_room/firebase_auth/auth.dart';
import 'package:sky_room/providers/providerLogin.dart';
import 'package:sky_room/screen/loginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  late AuthFirebase auth;
  late String uid;
  late Map<String, dynamic> userData = {};
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    uid = context.read<UserProvider>().uid ?? "";
    _readData();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadData();
    } else {
      print('User canceled image picking');
    }
  }

  Future<void> _readData() async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data() as Map<String, dynamic>;
        });
      } else {
        print('User data not found.');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _deleteProfilePicture() async {
    await Firebase.initializeApp();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'profilefoto': null});
  }

  Future<void> _uploadData() async {
    if (_image == null) return;

    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child(
          'userfotoprofile/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageReference.putFile(_image!);

      final downloadURL = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilefoto': downloadURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('profile image uploaded successfully'),
        ),
      );
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Column(children: [
          if (userData['profilefoto'] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData['profilefoto']),
                radius: 100,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0="),
                radius: 100,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await _pickImage(ImageSource.gallery);
                    await _readData();
                  },
                  child: const Text("Upload Photo")),
              IconButton(
                  onPressed: () async {
                    await _deleteProfilePicture();
                    await _readData();
                  },
                  icon: const Icon(Icons.delete))
            ],
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
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Username: ${userData['firstName']} ${userData['lastName']}',
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
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Email: ${userData['email']}',
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
                    AuthFirebase().signOut().then((result) {
                      if (result == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
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
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.red),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
        ]));
  }
}
