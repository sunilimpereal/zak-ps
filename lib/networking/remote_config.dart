import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:zak_mobile_app/networking/constants.dart';

var backendURL = 'http://awszts.afroaves.com:8080/api/v2/';
void fetchValuesFromRemoteConfig() async {
  final remoteConfig = await RemoteConfig.instance;
  await remoteConfig.setDefaults(<String, dynamic>{backendURLKey: backendURL});
  await remoteConfig.fetchAndActivate();
  backendURL = remoteConfig.getString(backendURLKey);
}
