import 'package:geolocator/geolocator.dart';

Future _getMyLocation() async {
  bool isServiceEnable;
  LocationPermission locationPermission;

  isServiceEnable = await Geolocator.isLocationServiceEnabled();

  if (!isServiceEnable) {
    return Future.error('Location is disable');
  }

  locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    return Future.error('Permission denied');
  }
  if (locationPermission == LocationPermission.deniedForever) {
    return Future.error(
        'Permission is denied forever we canoot access the permission');
  }
  return await Geolocator.getCurrentPosition();
}
