import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pharmacy_home_page.dart';
import 'stock_page.dart';
import '/theme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/button.dart';
import 'edit_medicine_page.dart';

class ProductDetail extends StatefulWidget {

  final int id;

  const ProductDetail({super.key, required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {



  @override
  Widget build(BuildContext context) {
    final int stockId = widget.id ;



    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Get.to(EditMedicinePage(id:stockId));
                },
                icon: Icon(Icons.edit, size: 35)),
          )
        ],
        title: Text('The Medicine Information'),
      ),
      body:  FutureBuilder(
        future: fetchStock(stockId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String ,dynamic> data = snapshot.data!;
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Product Detail',
                      style: headingStyle.copyWith(fontSize:40),
                    ),
                    SizedBox(height: 24,),
                    SizedBox(
                      child:data['image'] == null?Image(image: AssetImage('images/medicine.png')):
                      Image(image: AssetImage(data['image'])),
                      height:120,
                    ),
                    SizedBox(height: 24,),
                    buildRow('Name',data['name_medicine']),
                    SizedBox(height: 4,),
                    buildRow('Quantity', '${data['quantity']}'),
                    SizedBox(height: 4,),
                    buildRow('Fabrication Date', '${data['date_f']}'),
                    SizedBox(height: 4,),
                    buildRow('Expiry Date', '${data['date_e']}'),
                    SizedBox(height: 4,),
                    buildRow('Price', '${data['price']} \$'),
                    SizedBox(height: 4,),
                    buildRow('Code Bar', '${data['bar_code']}'),
                    SizedBox(height: 8),
                    MyButton(
                        label: 'Delete',
                        color:Color.fromRGBO(255, 0, 33, 1),
                        onTap: () {
                            delete(data['id_stock']);


                        }),
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
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 24),
              ),
              Text(data,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 22))
            ],
          );
  }

  Future<Map<String ,dynamic>> fetchStock(id) async {
    print(id);
    final url =
        'http://127.0.0.1:8000/api/medicinebystock/$id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final stock = List<Map<String, dynamic>>.from(jsonData['stock']);

      print(stock);
      return stock.first;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future delete(int id) async{
    final url = 'http://127.0.0.1:8000/api/delete_prod/$id';

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      Get.snackbar("Successful", "The medicine deleted Successfully",backgroundColor: Colors.green);
      Get.to(PharmacyHomePage());


    } else {

      Get.snackbar("ERROR ${response.statusCode}", "Failed to delete medicine",backgroundColor: Colors.red);
      throw Exception('Failed to get data');
    }
  }
}
