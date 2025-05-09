import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Utils{

  String getPlatform(){
    if(kIsWeb){
      return 'web';
    }
    else if(Platform.isAndroid){
      return 'android';
    }
    else if(Platform.isIOS){
      return 'ios';
    }
    else{
      return 'unKnown Platform';
    }
  }

}