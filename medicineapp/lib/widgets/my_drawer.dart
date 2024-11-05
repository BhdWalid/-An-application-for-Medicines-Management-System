import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/theme_services.dart';
class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  bool isDark = !Get.isDarkMode ;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(

        children: [
          const SizedBox(height: 80),
          const CircleAvatar(
            maxRadius: 60,
            child:Icon(Icons.construction, size: 80),
          ),
          const SizedBox(height: 20),
          SwitchListTile(value: isDark, onChanged:(val){
            ThemeServices().switchMode();
            isDark = Get.isDarkMode;
          },
          title: Text('Mode'),),


        ],
      ),
    );
  }
}


