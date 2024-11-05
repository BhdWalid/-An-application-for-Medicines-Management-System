import 'dart:convert';

import 'account_complain_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();

  var arguments = Get.arguments;
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> reasonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.arguments[0];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color:
                  Get.isDarkMode ? Colors.white : darkGreyClr.withOpacity(0.7)),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(AccountComplainPage(id: data['sender']));
            },
            child: Row(
              children: [
                Icon(Icons.reply,
                    color: Get.isDarkMode
                        ? Colors.white
                        : darkGreyClr.withOpacity(0.7)),
                Text(
                  'Reply',
                  style: TextStyle(
                      color: Get.isDarkMode
                          ? Colors.white
                          : darkGreyClr.withOpacity(0.7)),
                ),
              ],
            ),
          )
        ],
        elevation: 0,
        backgroundColor: context.theme.canvasColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data['subject'], style: headingStyle.copyWith(fontSize: 28)),
            ),
            ListTile(
              title: Text(data['last_name']+' '+data['first_name']),
              subtitle: Text(data['date']),
              leading:const CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text('S', style: TextStyle(fontSize: 36),textAlign: TextAlign.center,),
              ),
            ),
            Divider(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['content'],
                style: titleStyle
              )
            )
          ],
        ),
      ),
    );
  }
}
