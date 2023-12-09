import 'package:flutter/material.dart';
import 'package:sky_room/firebase_auth/auth.dart';
import 'package:sky_room/screen/loginScreen.dart';

class RegisScreen extends StatefulWidget {
  const RegisScreen({super.key});

  @override
  State<RegisScreen> createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
  late AuthFirebase auth;

  final TextEditingController _inputEmail = TextEditingController();
  final TextEditingController _inputPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  void _handleSignUp() async {
    final email = _inputEmail.text;
    final password = _inputPassword.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final authResult = await auth.signUp(email, password);

      if (authResult != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Register berhasil'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gagal mendaftar'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email atau password kosong'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 120, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Silahkan Daftar dengan Email Anda!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _inputEmail,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _inputPassword,
                        style: const TextStyle(color: Colors.white),
                        obscureText: mounted,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
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
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah Punya Akun? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen())),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
