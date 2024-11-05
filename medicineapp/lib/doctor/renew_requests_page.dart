import 'dart:convert';

import 'package:medicineapp/doctor/renew_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RenewRequestsPage extends StatefulWidget {
  const RenewRequestsPage({Key? key}) : super(key: key);

  @override
  State<RenewRequestsPage> createState() => _RenewRequestsPageState();
}

class _RenewRequestsPageState extends State<RenewRequestsPage> {
  Controller c = Controller();
  get info => c.getAccountInfo();

  List renews = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renew requests'),
      ),
      body: FutureBuilder(
        future: fetchFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>>? files = snapshot.data;
              print(files);
              return ListView.builder(
                itemCount: files?.length,
                itemBuilder: (context, index) {
                  return buildCard(
                      files![index]['id_renew'],
                      files[index]['prescription']['date'],
                      files[index]['prescription']['first_name'] +
                          ' ' +
                          files[index]['prescription']['last_name']);
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
              Map<String, dynamic> targetComplaint =
                  renews.firstWhere((complaint) => complaint['id_renew'] == id);
              print('target $targetComplaint');

              Get.to(() => RenewPage(
                    idF: targetComplaint['prescription']['file_id_file'],
                    idR: id,
                  ));
            },
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchFiles() async {
    final url = 'http://127.0.0.1:8000/api/viewRenows/${info['id_doctor']}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final renowsList = List<Map<String, dynamic>>.from(jsonData['renows']);
      renews = renowsList;
      return renowsList;
    } else {
      throw Exception('Failed to get data');
    }
  }
}
