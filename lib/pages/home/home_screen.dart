import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sertf/pages/home/map.dart';
import 'package:sertf/data/my_colors.dart';
import 'package:sertf/widget/my_text.dart';
import 'package:sertf/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var idUser = "";
  var nama = "";
  var username = "";
  var nohp = "";

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double long = 0, lat = 0;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
     userCek();
    checkGps();
    super.initState();
  }

  userCek() async {
    final prefs = await SharedPreferences.getInstance();

    idUser = prefs.getString('id')!;
    nama = prefs.getString('nama')!;
    username = prefs.getString('username')!;
   nohp = prefs.getString('nohp')!;

    // if (id == null) {
    //   Navigator.pop(context);
    // } else {
    //   setState(() {
    //     idUser = id;
    //     nama = name!;
    //     username = usern!;
    //     nohp = hp!;
    //   });
    // }
  }

  // fetchProfil() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();

  //     var id = prefs.getString('id');

  //     var dbUser = FirebaseFirestore.instance.collection('users');

  //     var fetch = await dbUser.doc(id).get().then((value) => value.data());

  //     if (fetch!.isNotEmpty) {
  //       setState(() {
  //         username = fetch['username'];
  //         nama = fetch['nama'];
  //        nohp = fetch['nohp'];
  //       });
  //     } else {
  //       if (mounted) {
  //         Helpers().showSnackBar(context, 'Fetch Fail, try again', Colors.red);
  //       }
  //     }
  //   } on FirebaseException catch (e) {
  //     if (mounted) {
  //       Helpers().showSnackBar(context, e.message.toString(), Colors.red);
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: const [],
        ),
        body: SingleChildScrollView(
            child: RefreshIndicator(
          onRefresh: () async {
            checkGps();
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Container(
              //   height: 300,
              //   child: FlutterMap(
              //     options: MapOptions(
              //       center: LatLng(lat, long),
              //       zoom: 9.2,
              //     ),
              //     children: [
              //       TileLayer(
              //         urlTemplate:
              //             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              //         userAgentPackageName: 'com.example.app',
              //       ),
              //       ElevatedButton(onPressed: () {
              //         Navigator.push(
              //                       context,
              //                       MaterialPageRoute(builder: (context) => MyMap(lat: lat, long: long,)),
              //                     );
              //       }, child: Text('get location'))
              //     ],
              //   ),
              // ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 15,),
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.indigo[400],
                      elevation: 2,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10),
                              Expanded(
                                child: Text("Welcome to Our Apps",
                                    style: MyText.subhead(context)!.copyWith(
                                        color: Colors.lightBlue[100])),
                              ),
                              // IconButton(icon: Icon(Icons.add, color: Colors.lightBlue[100]), onPressed: () {}),
                            ],
                          ),
                          Container(height: 10),
                          Text("Indonesia",
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.lightBlue[50])),
                          Text(nama,
                              style: MyText.display1(context)!
                                  .copyWith(color: Colors.white)),
                          Text(nohp,
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.lightBlue[200])),
                          Container(height: 25),
                        ],
                      ),
                    ),
                    Container(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyMap(
                                          lat: lat,
                                          long: long,
                                        )),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              color: Colors.white,
                              elevation: 2,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: MyColors.grey_10,
                                      child: Icon(Icons.arrow_upward,
                                          color: MyColors.grey_40, size: 15),
                                    ),
                                    Container(width: 15),
                                    Text("Click and Get Your Current Now",
                                        style: MyText.subhead(context)!
                                            .copyWith(
                                                color: Colors.indigo[900],
                                                fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 10),
                    Text("Today",
                        style: MyText.body2(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Container(height: 5),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white,
                      elevation: 2,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: MyColors.grey_10,
                              child: Icon(Icons.arrow_downward,
                                  color: MyColors.grey_40, size: 15),
                            ),
                            Container(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Location",
                                    style: MyText.subhead(context)!.copyWith(
                                        color: Colors.indigo[900],
                                        fontWeight: FontWeight.w500)),
                                Container(height: 5),
                                Text("04 november 2022",
                                    style: MyText.caption(context)!
                                        .copyWith(color: MyColors.grey_40)),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(lat.toString() + ' ::lat',
                                    style: MyText.body1(context)!.copyWith(
                                        color: Colors.lightBlue[500])),
                                Container(height: 5),
                                Text(long.toString() + ' ::long',
                                    style: MyText.body1(context)!.copyWith(
                                        color: Colors.lightBlue[500])),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        )));
  }

  checkGps() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    print("oke");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("Masuk getLocation()");
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    setState(() {
      long = position.longitude;
      lat = position.latitude;
    });

    

    // setState(() {
    //   //refresh UI
    // });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
      print("hee");

      setState(() {
        long = position.longitude;
        lat = position.latitude;
      });

      print(lat);
      print(long);
      // setState(() {
      //   //refresh UI on update
      // });
    });
  }
}
