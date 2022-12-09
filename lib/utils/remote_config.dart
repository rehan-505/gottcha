import 'package:firebase_remote_config/firebase_remote_config.dart';


class RemoteConfigService{
  late final RemoteConfig _remoteConfigService;
  RemoteConfigService({required RemoteConfig remote}):_remoteConfigService=remote;
  final defaults=<String,dynamic>{
    'hider_marker_show':10,
    'hider_marker_show_for':10,
    'shrink_after':10,
    'debug':false,
  };
  static RemoteConfigService? _instance;
static Future<RemoteConfigService> getInstance() async {
    if(_instance==null){
      _instance=RemoteConfigService(remote:await RemoteConfig.instance);

    }
    return _instance!;
  }
  int get hider_marker_show=>_remoteConfigService.getInt('hider_marker_show');
  int get hider_marker_show_for=>_remoteConfigService.getInt('hider_marker_show_for');
  int get shrink_after=>_remoteConfigService.getInt('shrink_after');
  //setter of shrink_after
  bool get debug=>_remoteConfigService.getBool('debug');

  // int get hider_marker_show=>2;
  // int get hider_marker_show_for=>10;
  // int get shrink_after=>2;
  // //setter of shrink_after
  // bool get debug=>false;


  Future initialize()async{
    try{
      await _remoteConfigService.setDefaults(defaults);

      await _remoteConfigService.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),));
     bool value= await _remoteConfigService.fetchAndActivate();
     print("settt"+value.toString());
    }
    catch(e){
      print(e);
    }
  }

}