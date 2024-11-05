import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/button.dart';
import 'doctor_home_page.dart';
import 'order_cart.dart';

class RenewPage extends StatefulWidget {
   RenewPage({Key? key, required this.idF, required this.idR}) : super(key: key);
  final int idF;
  final int idR;

  @override
  State<RenewPage> createState() => _RenewPageState();
}

class _RenewPageState extends State<RenewPage> {
  List meds = [];


  @override
  Widget build(BuildContext context) {
    int id = widget.idF;
    int idR = widget.idR;

    return Scaffold(
      appBar: AppBar(title: Text('Renew Request'),centerTitle: true,),
      body: FutureBuilder(
        future: fetchFile(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String ,dynamic> data = snapshot.data!;
              meds =  data['prescription']['medicines'];
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
                    buildRow('Patient name', '${data['patient'][0]['first_name']} ${data['patient'][0]['last_name']}'),
                    const SizedBox(
                      height: 4,
                    ),
                    buildRow('Address', data['patient'][0]['address']),
                    const SizedBox(
                      height: 4,
                    ),
                    buildRow('Phone number', data['patient'][0]['phone_number']),
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
                              color: Color.fromRGBO(200, 130, 220,0.8),
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: (Column(
                              children: [
                                buildRow('Medicine ${index +1}', medicines[index]['name_medicine'].toString()) ,
                                const SizedBox(
                                  height: 4,
                                ),
                                buildRow('Dose', medicines[index]['dose']) ,
                                const SizedBox(
                                  height: 4,
                                ),
                                buildRow('Description', medicines[index]['description']) ,
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            )),
                          );
                        },
                        itemCount:data['prescription']['medicines'].length  ),


                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        MyButton(
                            label: 'Accept',
                            onTap: ()async {
                              List<Map<String,dynamic>> medicines = meds.map((item) => item as Map<String, dynamic>).toList();

                              print(medicines);
                              print(id);
                              await Get.to(()=>OrderCart(),arguments: {'data':medicines, 'idFile':id ,'id_renew':idR});
                            },
                            color: const Color.fromRGBO(50, 230, 50, 1)),
                        MyButton(
                            label: 'Refuse',
                            onTap: () {
                              refuse(idR);
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
      )
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
        'http://127.0.0.1:8000/api/patientFile/$id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to get data');
    }
  }
  Future refuse(id) async {
    print(id);
    final url =
        'http://127.0.0.1:8000/api/refuseRenew/$id';

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      Get.snackbar("Successful", "The renew refuse Successfully",backgroundColor: Colors.green);
      Get.to(DoctorHomePage());


    } else {

      Get.snackbar("ERROR ${response.statusCode}", "Failed to refuse",backgroundColor: Colors.red);
      throw Exception('Failed to get data');
    }
  }

}
