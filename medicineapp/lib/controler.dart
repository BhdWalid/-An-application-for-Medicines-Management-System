import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Controller extends GetxController {

  final GetStorage _box  = GetStorage();

  get info => getAccountInfo();


  void saveAccountInfo(info) {
    _box.write('info', info);
  }
  getAccountInfo(){
    return _box.read('info');

  }
}