import 'dart:convert';

import 'package:medicineapp/pharmacy/pharmacy_home_page.dart';

import '../controler.dart';
import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ComplainPage extends StatefulWidget {
  const ComplainPage({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  Controller c = Controller();
  get info => c.getAccountInfo();
  int get id => widget.id ?? 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => accountComplain(),
            icon: Icon(
              Icons.send_outlined,
              color:
                  Get.isDarkMode ? Colors.white : darkGreyClr.withOpacity(0.7),
            ),
          )
        ],
        elevation: 0,
        title: Text(
          'Complain',
          style: subHeadingStyle,
        ),
        backgroundColor: context.theme.canvasColor,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            )),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 20),
                controller: subjectController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Subject',
                    hintStyle: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 30),
              TextFormField(
                style: const TextStyle(fontSize: 20),
                maxLines: 20,
                controller: bodyController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  hintStyle: TextStyle(fontSize: 18),
                  hintText: 'Please enter more details',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> accountComplain() async {
    try {
      final String jsonStr = jsonEncode({
        "resiver": id,
        "sender": info['id_account'],
        "subject": subjectController.text,
        "content": bodyController.text,
      });
      print(jsonStr);
      var res = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/addComplaint'),
          body: jsonStr,
          headers: {'Content-Type': 'application/json'});

      print(res);
      if (res.statusCode == 200) {
        Get.snackbar('Complaint sent successfully',
            'The admin will check your message soon',
            backgroundColor: Colors.green);
        Get.to(PharmacyHomePage());
      } else {
        Get.snackbar(
            'Error  ${res.statusCode}', 'Some error happens please try again',
            backgroundColor: Colors.red);

        print('Status dode: ${res.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
