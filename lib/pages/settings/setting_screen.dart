import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sertf/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sertf/auth/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var idUser = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nohpController = TextEditingController();

  @override
  void initState() {
    userCek();
    fetchProfil();
    super.initState();
  }

  userCek() async {
    final prefs = await SharedPreferences.getInstance();

    var id = prefs.getString('id');

    if (id == null) {
      Navigator.pop(context);
    } else {
      setState(() {
        idUser = id;
      });
    }
  }

  userSet(username, nama, noHp) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('nama', nama);
    prefs.setString('nohp', noHp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchProfil();
        },
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Username",
                      ),
                      controller: usernameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Name",
                      ),
                      controller: namaController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      controller: passwordController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "No HP",
                      ),
                      keyboardType: TextInputType.number,
                      controller: nohpController,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  updateProfil();
                },
                child: const Text("Update"),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                 LogOut();
                },
                child: const Text("Log Out", style: TextStyle(color: Colors.blue),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchProfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var id = prefs.getString('id');

      var dbUser = FirebaseFirestore.instance.collection('users');

      var fetch = await dbUser.doc(id).get().then((value) => value.data());

      if (fetch!.isNotEmpty) {
        setState(() {
          usernameController.text = fetch['username'];
          namaController.text = fetch['nama'];
          passwordController.text = fetch['password'];
          nohpController.text = fetch['nohp'];
        });
      } else {
        if (mounted) {
          Helpers().showSnackBar(context, 'Fetch Fail, try again', Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Helpers().showSnackBar(context, e.message.toString(), Colors.red);
      }
    }
  }

  LogOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
  }

  updateProfil() async {
    try {
      var dbUser = FirebaseFirestore.instance.collection('users');

      await dbUser.doc(idUser).update({
        'username': usernameController.text,
        'nama': namaController.text,
        'password': passwordController.text,
        'nohp': nohpController.text,
      });

      fetchProfil();

      if (mounted) {
        Helpers().showSnackBar(context, 'Update Successful', Colors.green);
        userSet(usernameController.text, namaController.text, nohpController.text);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Helpers().showSnackBar(context, e.message.toString(), Colors.red);
      }
    }
  }
}
