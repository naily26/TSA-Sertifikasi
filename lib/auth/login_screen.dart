import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sertf/auth/register_screen.dart';
import 'package:sertf/helpers.dart';
import 'package:sertf/navigation/bottom_nav.dart';
import 'package:sertf/pages/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var idUser = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    userCek();
    super.initState();
  }

  userCek() async {
    // final prefs = await SharedPreferences.getInstance();

    // var id = prefs.getString('id');

    // if (id != null) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => BasicMainNavigationView()),
    //       (Route<dynamic> route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(child: Center(child: Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),),
            Container(height: 30,),
            Center(
              child: Card(
                elevation: 8.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Username",
                        ),
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Password",
                        ),
                        obscureText: true,
                        controller: passwordController,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          
                        ),
                        onPressed: () {
                          login();
                        },
                        child: const Text("Log In"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Expanded(child: Text("Don't Have a Account?")),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text("Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    try {
      var dbUser = FirebaseFirestore.instance.collection('users');

      var loginCek = await dbUser
          .where('username', isEqualTo: usernameController.text)
          .where('password', isEqualTo: passwordController.text)
          .get()
          .then((value) => value.docs);

      if (loginCek.isNotEmpty) {
        var data = loginCek.first.data();
        print(data);
        saveSharePref(
          loginCek.first.id,
          data['username'],
          data['nama'],
          data['nohp'],
          data['password'],
        );

        if (mounted) {
          Helpers().showSnackBar(context, 'Login Successful', Colors.black);
        }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BasicMainNavigationView()),
            (Route<dynamic> route) => false);
      } else {
        if (mounted) {
          Helpers().showSnackBar(context, 'Login Fail, try again', Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Helpers().showSnackBar(context, e.message.toString(), Colors.red);
      }
    }
  }

  saveSharePref(id, username, nama, nohp, pw) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('id', id);
    prefs.setString('username', username);
    prefs.setString('nama', nama);
    prefs.setString('nohp', nohp);
    prefs.setString('password', pw);
  }

  
}
