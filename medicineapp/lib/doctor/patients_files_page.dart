import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_file_page.dart';
import 'order_cart.dart';
import '../controler.dart';
import 'file_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientsFilesPage extends StatefulWidget {
  const PatientsFilesPage({Key? key}) : super(key: key);

  @override
  State<PatientsFilesPage> createState() => _PatientsFilesPageState();
}

class _PatientsFilesPageState extends State<PatientsFilesPage> {
   List allFiles = [];
   List files = [];
  Controller c = Controller();
  get info => c.getAccountInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              Get.to(EditFilePage());
            },
            icon: Icon(Icons.add_box),
            iconSize: 26,
          ),
        ],
        title: Text('Files'),
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
                  return buildCard(files![index]['id_file'], files[index]['birthday'], files[index]['first_name'] +' '+ files[index]['last_name']);
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
              Get.to(() => FileDetailPage(id: id));
            },
          ),

        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchFiles() async {
    final url = 'http://127.0.0.1:8000/api/getDoctorFiles/${info['id_doctor']}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final fileList = List<Map<String, dynamic>>.from(jsonData['file']);


        files = fileList;
        allFiles = fileList;

      return fileList;
    } else {
      throw Exception('Failed to get data');
    }
  }
}
