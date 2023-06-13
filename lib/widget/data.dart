import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Data {
  final LatLng latlong;
  final String attr1;
  final String attr2;
  final String attr3;

  const Data({
    required this.latlong,
    required this.attr1,
    required this.attr2, 
    required this.attr3,
  });
}