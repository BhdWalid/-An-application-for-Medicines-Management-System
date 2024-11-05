import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_medicine_page.dart';
import 'edit_medicine_page.dart';
import 'product_detail_page.dart';
import '../controler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme.dart';

class StockPage extends StatefulWidget {
  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List allMedicines = [];
  List medicines = [];
  Controller c = Controller();

  get info => c.getAccountInfo();

  TextEditingController SearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    Get.to(AddMedicinePage());
                  },
                  icon: Icon(Icons.add, size: 35)),
            )
          ],
          title: Text(
            'Stock',
            style: subHeadingStyle,
          ),
          backgroundColor: context.theme.primaryColor,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: SearchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.lightBlueAccent,
                      size: 25,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (value) => searchMedicine(value),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchFiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      medicines = snapshot.data!;
                      return ListView.builder(
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          return buildCard(
                            medicines[index]['bar_code'].toString(),
                            medicines[index]['name_medicine'],
                            medicines[index]['quantity'],
                            medicines[index]['id_stock'],);
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
          ],
        ));
  }

  Card buildCard(String codebar, String name, int quantity, int idStock) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color.fromRGBO(9, 198, 249, 1),
      elevation: 20,
      shadowColor: Color.fromRGBO(4, 93, 233, 0.8),
      child: ListTile(
        leading: Icon(
          Icons.medication,
          color: Colors.red,
          size: 50,
        ),
        subtitle: Text('Cde bar: $codebar'),
        title: Text(name),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Quantity'),
            Text('$quantity'),
          ],
        ),
        onTap: () {
          print(idStock);
          Get.to(ProductDetail(id: idStock,));
        },
      ),
    );
  }

  void searchMedicine(String value) {
    final suggestions = allMedicines.where((medicine) {
      final medicineName = medicine['name_medicine'].toLowerCase();
      final input = value.toLowerCase();
      return medicineName.contains(input);
    }).toList();
    setState(() {
      print(suggestions);
      medicines = suggestions;
    });
  }

  void addMedicine() {
    Get.to(EditMedicinePage());
  }

  Future<List> fetchFiles() async {
    if(medicines.isEmpty){
      final url = 'http://127.0.0.1:8000/api/medicinebypharmacy/${info['pharmacy_id_pharmacy']}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final fileList = List<Map<String, dynamic>>.from(jsonData['stock']);

        medicines = fileList;
        allMedicines = fileList;

        if (fileList.isEmpty )
          throw Exception('No data found');
        else return fileList;
      } else {
        throw Exception('Failed to get data');
      }
    }else{
      return medicines ;
    }
  }
}
