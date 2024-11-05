import 'dart:convert';

import 'package:medicineapp/patient/file_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controler.dart';

class MyMedicinesPage extends StatefulWidget {
  const MyMedicinesPage({Key? key}) : super(key: key);

  @override
  State<MyMedicinesPage> createState() => _MyMedicinesPageState();
}

class _MyMedicinesPageState extends State<MyMedicinesPage> {
  Controller c = Controller();
  get info => c.getAccountInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Medicines'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>>? files = snapshot.data;
              return ListView.builder(
                itemCount: files?.length,
                itemBuilder: (context, index) {
                  return buildCard(
                      files![index]['id_file'],
                      files[index]['address'],
                      files[index]['first_name'] +
                          ' ' +
                          files[index]['last_name']);
                },
              );
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

  Card buildCard(int id, String date, String pName) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color.fromRGBO(9, 198, 249, 1),
      elevation: 20,
      shadowColor: Color.fromRGBO(4, 93, 233, 0.8),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              id.toString(),
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Date: $date'),
            title: Text(pName),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Get.to(() => FileInfoPage(id: id));
            },
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchFiles() async {
    final url =
        'http://127.0.0.1:8000/api/getPatientFiles/${info['id_patient']}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final fileList = List<Map<String, dynamic>>.from(jsonData['file']);

      return fileList;
    } else {
      throw Exception('Failed to get data');
    }
  }
}
