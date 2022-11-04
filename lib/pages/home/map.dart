import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';


class MyMap extends StatefulWidget {
  const MyMap({Key? key, required this.lat, required this.long}) : super(key: key);

  final double lat;
  final double long;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: Text('Your Location'),
        ),
        body: OpenStreetMapSearchAndPick(
             center: LatLong(-7.94767195143, 112.617200129),
            //  center: LatLong(widget.lat, widget.long),
            // buttonColor: Colors.blue,
            // buttonText: 'Set Current Location',
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
            }));
  }
}