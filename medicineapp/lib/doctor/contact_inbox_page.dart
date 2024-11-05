import 'package:flutter/material.dart';

import '../controler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../theme.dart';
import 'contact_page.dart';

class ContactInboxPage extends StatefulWidget {
  const ContactInboxPage({Key? key}) : super(key: key);

  @override
  State<ContactInboxPage> createState() => _ContactInboxPageState();
}

class _ContactInboxPageState extends State<ContactInboxPage> {

  Controller c = Controller();
  get info => c.getAccountInfo();

  List complaints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(


        elevation: 0,
        title: Text(
          'In Box',
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
      body:FutureBuilder(
        future: fetchBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List files = snapshot.data!;
              print(complaints);
              return complaints.isNotEmpty? ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return buildCard(files[index]['id_complaint'], files[index]['date'], files[index]['first_name'] +' '+ files[index]['last_name'],files[index]['subject']);
                },
              ):const Center(child:  Text("Your inbox is Empty!"));
            } else {
              return Text('No data found');
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  ListTile buildCard(int id, String date, String pName,String subject) {
    return
        ListTile(
          leading: Text(
            id.toString(),
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Subject: $subject \nDate: $date'),
          title: Text(pName),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {

            Map<String, dynamic> targetComplaint = complaints.firstWhere(
                    (complaint) => complaint['id_complaint'] == id);
            print('target $targetComplaint');

             Get.to(()=>ContactPage(),arguments: [targetComplaint] );

          },
            isThreeLine:true
    );
  }
  Future<List> fetchBox() async {
    final url = 'http://127.0.0.1:8000/api/inBox';

    final response = await http.post(Uri.parse(url),body: jsonEncode({
      "id": info['id_account']
    }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print('Status dode: ${response.body}');
      final jsonData = json.decode(response.body);
      final fileList = List<Map<String, dynamic>>.from(jsonData['messages']);
      complaints = fileList;

      return fileList;
    } else {
      print('Status dode: ${response.statusCode}');
      throw Exception('Failed to get data');
    }
  }
}
