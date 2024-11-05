import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/doctor/prescription.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import '../pharmacy/pharmacy_home_page.dart';
import '../theme.dart';
import 'doctor_home_page.dart';
import 'dart:convert' as convert;

class FileDetailPage extends StatefulWidget {
  const FileDetailPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState extends State<FileDetailPage> {
  final GlobalKey<FormState> reasonKey = GlobalKey();
  final _reasoncontroler = TextEditingController();


  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(_myAlert(id: id));
              },
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.edit),
              ))
        ],
        title: Text('The File Information'),
      ),
      body:

      SingleChildScrollView(
        child: FutureBuilder(
          future: fetchFile(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Map<String ,dynamic> data = snapshot.data!;
                _reasoncontroler.text = data['file'][0]['reason'];

                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Patient information',
                        style: headingStyle,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      buildRow('Patient Name', '${data['file'][0]['first_name']} ${data['file'][0]['last_name']}'),
                      SizedBox(
                        height: 4,
                      ),
                      buildRow('Born on', data['file'][0]['birthday']),
                      SizedBox(
                        height: 4,
                      ),
                      buildRow('Reason', '${data['file'][0]['reason']}'),

                      Divider(
                        height: 16,
                      ),
                      Text(
                        'Prescription Detail',
                        style: headingStyle,
                      ),

                      data['prescription']==null? Text('No prescription found',style: subTitleStyle,):ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index){

                            List medicines = data['prescription']['medicines'];
                            print(medicines);
                        return  Container(
                          margin: EdgeInsets.only(top:12),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(240, 130, 180,0.8),
                            borderRadius: BorderRadius.circular(15),

                          ),

                          child: (Column(
                            children: [
                              buildRow('Medicine ${index +1}', medicines[index]['name'].toString()) ,
                              SizedBox(
                              height: 4,
                              ),
                              buildRow('Dose', medicines[index]['dose']) ,
                              SizedBox(
                                height: 4,
                              ),
                              buildRow('quantity', medicines[index]['quantity'].toString()) ,
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          )),
                        );
                      },
                      itemCount:data['prescription']['medicines'].length  ),


                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //MyButton(label: 'Refuse', onTap: (){},color:Color.fromRGBO(255, 0, 33, 1) ),
                          MyButton(
                              label: 'New prescription',
                              onTap: () {Get.to(PrescriptionPage(id:id));},
                              color: Color.fromRGBO(50, 230, 50, 1)),
                          MyButton(
                              label: 'Delete File',
                              onTap: () {delete(id);},
                              color: Color.fromRGBO(230, 50, 50, 1))
                        ],
                      )
                    ],
                  ),
                );

            } else {
                return Text('No data found');
              }
            } else {
              return Center(child: CircularProgressIndicator());
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
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),
        ),
        Text(data,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 22))
      ],
    );
  }

  Future<Map<String ,dynamic>> fetchFile(id) async {
    print(id);
    final url =
        'http://127.0.0.1:8000/api/getFile/$id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future delete(int id) async{
    final url = 'http://127.0.0.1:8000/api/deleteFile/$id';

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      Get.snackbar("Successful", "The file deleted Successfully",backgroundColor: Colors.green);
      Get.to(DoctorHomePage());


    } else {

      Get.snackbar("ERROR ${response.statusCode}", "Failed to delete medicine",backgroundColor: Colors.red);
      throw Exception('Failed to get data');
    }
  }
  _myAlert({required int id,}) {
    return AlertDialog(
      titleTextStyle: headingStyle,
      content: Container(
        height:200,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: reasonKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                        ))),
                child: TextFormField(
                  controller: _reasoncontroler,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Reason'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Reason is required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            MyButton(
                label: 'Confirm',
                color: Color.fromRGBO(50, 230, 50, 1),
                onTap: () async {
                  if (!reasonKey.currentState!.validate()) {
                    return;
                  }
                   edit(id);
                  Get.back();
                })
          ],
        ),
      ),
      title: const Text('Patient information'),
    );
  }
  Future<void> edit(int id) async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/updateFile/$id');
      print(1);

      var data = {
        "reason": _reasoncontroler.text,
      };

      var response = await http.put(url,
          body: convert.jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        Get.snackbar("Successful", "The file edited Successfully",backgroundColor: Colors.green);
        print('Request suus with status: ${response.statusCode}.');
      } else {
        Get.snackbar("ERROR ${response.statusCode}", "Failed to delete medicine",backgroundColor: Colors.red);
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (ex) {
      print(ex);
    }
  }

}
