import 'dart:convert';

import 'package:medicineapp/patient/complain_page.dart';

import 'patient_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/doctor/prescription.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';
import 'dart:convert' as convert;

class FileInfoPage extends StatefulWidget {
  const FileInfoPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<FileInfoPage> createState() => _FileInfoPageState();
}

class _FileInfoPageState extends State<FileInfoPage> {
  final GlobalKey<FormState> reasonKey = GlobalKey();
  final _reasoncontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('The File Information'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchFile(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data!;

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Patient information',
                        style: headingStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      buildRow('Doctor Name',
                          '${data['file'][0]['first_name']} ${data['file'][0]['last_name']}'),
                      const SizedBox(
                        height: 4,
                      ),
                      buildRow('Address', data['file'][0]['address']),
                      const SizedBox(
                        height: 4,
                      ),
                      buildRow('Phone number', data['file'][0]['phone_number']),
                      const SizedBox(
                        height: 4,
                      ),
                      buildRow('Reason', '${data['file'][0]['reason']}'),
                      const Divider(
                        height: 16,
                      ),
                      Text(
                        'Prescription Detail',
                        style: headingStyle,
                      ),
                      data['prescription'] == null
                          ? Text(
                              'No prescription found',
                              style: subTitleStyle,
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                List medicines =
                                    data['prescription']['medicines'];
                                print(medicines);
                                return Container(
                                  margin: EdgeInsets.only(top: 12),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(240, 130, 180, 0.8),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: (Column(
                                    children: [
                                      buildRow(
                                          'Medicine ${index + 1}',
                                          medicines[index]['name_medicine']
                                              .toString()),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      buildRow(
                                          'Dose', medicines[index]['dose']),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      buildRow('Description',
                                          medicines[index]['description']),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      buildRow('Order quantity',
                                          "${medicines[index]['quantity'].toString()} Box"),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  )),
                                );
                              },
                              itemCount:
                                  data['prescription']['medicines'].length),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyButton(
                              label: 'Renew request',
                              onTap: () {
                                Get.defaultDialog(
                                  content: TextFormField(
                                    controller: _reasoncontroler,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Detail'),
                                  ),
                                  title: 'Send The Renew Request',
                                  titleStyle: headingStyle,
                                  textConfirm: 'Confirm',
                                  textCancel: 'Cancel',
                                  buttonColor:
                                      const Color.fromRGBO(50, 230, 50, 1),
                                  onConfirm: () {
                                    renew(data['prescription']['id_order']);
                                  },
                                  middleText: '',
                                );
                              },
                              color: const Color.fromRGBO(50, 230, 50, 1)),
                          MyButton(
                              label: 'Send Complaint',
                              onTap: () {
                                Get.to(ComplainPage(
                                    id: data['file'][0]['id_account']));
                              },
                              color: const Color.fromRGBO(230, 50, 50, 1))
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return const Text('No data found');
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Row buildRow(String lable, String data) {
    return Row(
      children: [
        Text(
          '$lable : ',
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),
        ),
        Text(data,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 22))
      ],
    );
  }

  Future<Map<String, dynamic>> fetchFile(id) async {
    print(id);
    final url = 'http://127.0.0.1:8000/api/patientFile/$id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future renew(id) async {
    print(id);
    final String jsonStr =
        jsonEncode({"order_id_order": id, "detail": _reasoncontroler.text});
    print(jsonStr);
    var response = await http.post(Uri.parse('http://127.0.0.1:8000/api/renew'),
        body: jsonStr, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Get.snackbar(
          'Renew sent successfully', 'The doctor will check your renew soon',
          duration: Duration(seconds: 5), backgroundColor: Colors.green);
      Get.offAll(PatientHomePage());
    } else {
      Get.snackbar('Error  ${response.statusCode}',
          'Some error happens please try again',
          duration: Duration(seconds: 5), backgroundColor: Colors.red);

      print('Status dode: ${response.statusCode}');
    }
  }
}
