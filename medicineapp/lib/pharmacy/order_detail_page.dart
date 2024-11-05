import 'package:medicineapp/pharmacy/pharmacy_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme.dart';
import 'orders_page.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    final int id = widget.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Order Detail'),
      ),
      body: FutureBuilder(
        future: fetchOrder(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              double total = 0;
              Map<String, dynamic> doctor = snapshot.data!['doctor'][0];
              Map<String, dynamic> data = snapshot.data!['prescription'];
              Map<String, dynamic> patient = snapshot.data!['patient'][0];
              print(data);
              data['medicines'].forEach((element) {
                total = element['quantity'] * element['price'] + total;
              });
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Order Detail',
                      style: headingStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    buildRow('Patient Name',
                        patient['last_name'] + ' ' + patient['first_name']),
                    SizedBox(
                      height: 4,
                    ),
                    buildRow('Address', patient['address']),
                    SizedBox(
                      height: 4,
                    ),
                    buildRow('Phone Number', patient['phone_number']),
                    SizedBox(
                      height: 4,
                    ),
                    buildRow('Doctor Name',
                        doctor['last_name'] + ' ' + doctor['first_name']),
                    SizedBox(
                      height: 4,
                    ),
                    buildRow('Order Date', data['date']),
                    Divider(
                      height: 8,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data['medicines'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              index == 0
                                  ? SizedBox(height: 0)
                                  : SizedBox(height: 4),
                              buildRow(
                                  'Medicine ${index + 1}',
                                  data['medicines'][index]['name'] +
                                      ' X ' +
                                      data['medicines'][index]['quantity']
                                          .toString()),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 6,
                    ),
                    buildRow('Total Price', '$total \$'),
                    SizedBox(height: 30),
                    data['state'] == 'pending'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MyButton(
                                  label: 'Refuse',
                                  onTap: () {
                                    refuse(data['id_order']);
                                  },
                                  color: Color.fromRGBO(255, 0, 33, 1)),
                              MyButton(
                                  label: 'Accept',
                                  onTap: () {
                                    acceptOrder(id);
                                  },
                                  color: Color.fromRGBO(50, 230, 50, 1))
                            ],
                          )
                        : Text(
                            'The order accepted',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.indigo,
                                fontWeight: FontWeight.w700),
                          ),
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

  Future<Map<String, dynamic>> fetchOrder(id) async {
    print(id);
    final url = 'http://127.0.0.1:8000/api/getOrderDetail/$id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future acceptOrder(id) async {
    print(id);
    final url = 'http://127.0.0.1:8000/api/acceptOrder/$id';

    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      Get.snackbar('The order accepted successfully',
          'You should deliver the order soon',
          duration: Duration(seconds: 5), backgroundColor: Colors.green);
      Get.offAll(PharmacyHomePage());
    } else {
      print(response.statusCode);
      throw Exception('Failed to get data');
    }
  }

  Future refuse(id) async {
    print(id);
    final url = 'http://127.0.0.1:8000/api/refuseOrder/$id';

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      Get.snackbar("Successful", "The order refuse Successfully",
          backgroundColor: Colors.green);
      Get.to(PharmacyHomePage());
    } else {
      Get.snackbar("ERROR ${response.statusCode}", "Failed to refuse",
          backgroundColor: Colors.red);
      throw Exception('Failed to get data');
    }
  }
}
