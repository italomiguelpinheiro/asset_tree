import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isOnline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.first != ConnectivityResult.none) {
    return true;
  }
  return false;
}
