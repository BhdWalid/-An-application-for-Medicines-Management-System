import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class ThemeServices {

  final GetStorage _box  = GetStorage();
  final _key = 'isDarkMode';

  void saveAccountInfo(info) {
    _box.write('info', info);
  }
  getAccountInfo(){
   return _box.read('info');

  }

  _saveThemeToBox(bool isDarkMode){
    _box.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox(){
    return _box.read<bool>(_key) ??false;
  }

  ThemeMode get theme => _loadThemeFromBox()? ThemeMode.dark : ThemeMode.light ;

  void switchMode(){
    Get.changeThemeMode( _loadThemeFromBox()? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}