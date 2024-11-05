import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controler.dart';
import '/pharmacy/order_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  Controller c = Controller();
  get info => c.getAccountInfo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Managing'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(6, 10, 6, 0),
        child:FutureBuilder(
          future: fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return buildCard(
                      orders[index]['id_order'],
                      orders[index]['date'],
                      orders[index]['patient_name'],
                      orders[index]['state']
                      );
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

      ),
    );
  }

  Card buildCard(int id, String date, String pName,String state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:state == 'pending'? Color.fromRGBO(9, 198, 249, 1): Color.fromRGBO(50, 230, 50, 1),
      elevation: 20,
      shadowColor: Color.fromRGBO(4, 93, 233, 0.8),
      child: ListTile(
        leading: Text(
          id.toString(),
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Date: $date'),
        title: Text(pName),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Get.to(() => OrderDetailPage(id: id));
        },
      ),
    );
  }
  Future<List> fetchOrders() async {

      final url = 'http://127.0.0.1:8000/api/getOrder/${info['pharmacy_id_pharmacy']}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ordersList = List<Map<String, dynamic>>.from(jsonData['prescriptions']);

        if (ordersList.isEmpty )
          throw Exception('No data found');
        else return ordersList;
      } else {
        throw Exception('Failed to get data');
      }

  }

}
