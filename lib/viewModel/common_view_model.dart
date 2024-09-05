import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../global/global_vars.dart';

class CommonViewModel {
  getCurrentLocation() async {
    Position cposition = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    position = cposition;

    placeMarks =
        await placemarkFromCoordinates(cposition.latitude, cposition.longitude);

    Placemark placeVar = placeMarks![0];

    String fullAddress =
        "${placeVar.subThoroughfare} ${placeVar.thoroughfare}, ${placeVar.subLocality} ${placeVar.locality}, ${placeVar.subAdministrativeArea} ${placeVar.administrativeArea}, ${placeVar.postalCode} ${placeVar.country}";

    return fullAddress;
  }

  updateLocationInDatabase() async {
    String address = await getCurrentLocation();

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "address": address,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
  }

  showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
