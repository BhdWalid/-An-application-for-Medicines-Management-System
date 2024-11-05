import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_file_page.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';
import 'order_cart.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();

}

class _PrescriptionPageState extends State<PrescriptionPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> allMedicines = [];
  List<Map<String, dynamic>> medicines = [];
  List<int> selectedTiles = [];

  TextEditingController searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> futureMedicines;

  @override
  void initState() {
    super.initState();
    futureMedicines = getMedicines();
  }

  @override
  Widget build(BuildContext context) {
    int idFile  =widget.id;
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 5,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      List<Map<String, dynamic>> filteredMedicines = medicines.where((medicine) {
                        int id = medicine['id_medicine'];
                        return selectedTiles.contains(id);
                      }).toList();
                      filteredMedicines.forEach((medicine) {
                        medicine['quantity'] = 1;
                      });
                      print(filteredMedicines);
                      Get.to(()=>OrderCart(),arguments: {'data':filteredMedicines, 'idFile':idFile});
                    },
                    icon: Icon(Icons.shopping_cart, size: 35),
                  ),
                ),
              ),
              Positioned(
                child: CircleAvatar(
                  child: Text(
                    selectedTiles.length.toString(),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  radius: 12,
                ),
                top: 5,
              )
            ],
          )
        ],
        title: Text(
          'Prescription',
          style: subHeadingStyle,
        ),
        backgroundColor: context.theme.primaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchMedicine(value);
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.lightBlueAccent,
                  size: 25,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureMedicines,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  medicines = snapshot.data!;
                  return ListView.builder(
                    itemCount: medicines.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      return buildCard(
                        medicines[index]['bar_code'].toString(),
                        medicines[index]['name_medicine'],
                        medicines[index]['id_medicine'],
                      );
                    },
                  );
                } else {
                  return Text('No data found');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Card buildCard(String codebar, String name, int id) {
    bool selected = selectedTiles.contains(id);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: selected ? Colors.lightBlue : Color.fromRGBO(46, 210, 74, 1.0),
      elevation: 20,
      shadowColor: Color.fromRGBO(4, 93, 233, 0.8),
      child: ListTile(
        leading: Icon(
          Icons.medication,
          color: Colors.red,
          size: 50,
        ),
        subtitle: Text('Code bar: $codebar'),
        title: Text(
          name,
          style: subTitleStyle,
        ),
        trailing: Icon(
          Icons.add_circle,
          size: 30,
          color: Colors.white70,
        ),
        onTap: () {
          setState(() {
            if (selected) {
              selectedTiles.remove(id);
            } else {
              selectedTiles.add(id);
            }
          });
        },
        tileColor: selected ? Colors.lightBlue : Colors.white,
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
      futureMedicines = getMedicines();
    });

  }

  Future<List<Map<String, dynamic>>> getMedicines() async {
    if (medicines.isEmpty) {
      final url = 'http://127.0.0.1:8000/api/allmedecine';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = List<Map<String, dynamic>>.from(jsonData['medicines']);

        allMedicines = data;

        if (data.isEmpty)
          throw Exception('No data found');
        else
          return data;
      } else {
        throw Exception('Failed to get data');
      }
    } else {
      print(medicines);
      return medicines;
    }
  }
}
