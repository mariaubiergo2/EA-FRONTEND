import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Data {
  final LatLng latlong; //Lat y long de donde quieres hacer zoom
  final String attr1; //Unused
  final String attr2; //Unused
  final String attr3; //Unused

  const Data({
    required this.latlong,
    required this.attr1,
    required this.attr2, 
    required this.attr3,
  });
}