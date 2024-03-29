import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sky_room/firebase_auth/auth.dart';
import 'package:sky_room/providers/providerLogin.dart';
import 'package:sky_room/screen/loginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                await _checkCameraPermissionAndPickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkCameraPermissionAndPickImage() async {
    PermissionStatus status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      await _pickImage(ImageSource.camera);
    } else {
      print('Camera permission denied');
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

  Future<void> _editUsername() async {
    String newUsername = userData['firstName'] ?? "";
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Edit your username',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new username',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newUsername = value;
            },
          ),
          actions: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _updateUsername(newUsername);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    if (newUsername.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': newUsername,
      });
      await _readData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
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
                  await _showImagePickerOptions();
                  await _readData();
                },
                child: const Text("Upload Photo"),
              ),
              IconButton(
                onPressed: () async {
                  await _deleteProfilePicture();
                  await _readData();
                },
                icon: const Icon(Icons.delete),
              )
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Username: ${userData['firstName']}',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editUsername,
                      ),
                    ],
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
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Berhasi Sign Out'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Berhasil Sign Out',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
