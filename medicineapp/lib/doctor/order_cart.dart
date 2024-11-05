import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/theme.dart';
import 'package:http/http.dart' as http;

import 'doctor_home_page.dart';

class OrderCart extends StatefulWidget {
  List<Map<String, dynamic>> data = Get.arguments['data'];
  int idFile = Get.arguments['idFile'];
  int? idR = Get.arguments['id_renew'];

  @override
  State<OrderCart> createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  int selectedPharmacy = 0;

  List<Map<String, dynamic>> get medicines => widget.data;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController doseController = TextEditingController();
  bool vis = false;

  int get idFile => widget.idFile;
  int? get idR => widget.idR;
  setSelectedPharmacy(int val) {
    setState(() {
      selectedPharmacy = val;
    });
  }

  late Future<List<Map<String, dynamic>>> futureMedicines;
  List pharmacies = [];
  List<Map<String, dynamic>> data = [];
  final GlobalKey<FormState> _ForomKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureMedicines = chossePharmacy(medicines);
  }

  @override
  Widget build(BuildContext context) {
    print(medicines);
    double total = 0;
    medicines.forEach((element) {
      total = element['quantity'] * element['price'] + total;
    });
    print(medicines);
    return Scaffold(
      body: Form(
        key: _ForomKey,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(2, 45, 123, 0.1),
            appBar: AppBar(
              title: const Text('Medicines Cart'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(
                          medicines[index]['name_medicine'],
                         medicines[index]['price'].toString(),
                          medicines[index]['quantity'],
                          medicines[index]['id_medicine'],medicines[index]['dose'],medicines[index]['description']);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: titleStyle,
                        ),
                        Text(
                          '\$ $total',
                          style: titleStyle,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await chossePharmacy(medicines);

                        setState(() {
                          vis = true;
                        });
                      },
                      child: Text(
                        'Choose Pharmacy',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                          backgroundColor: Color.fromRGBO(4, 93, 233, 0.8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  Visibility(
                    visible: vis,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureMedicines,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          pharmacies = snapshot.data!;
                          return Column(
                            children: [
                              Divider(
                                height: 20,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Choose Pharmacy',
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 24),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: createRadioListPharmacy()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_ForomKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (pharmacies.isEmpty) {
                                      Get.snackbar('Not aviable',
                                          "There's no pharmacy have all this medicines",
                                          backgroundColor: Colors.red,
                                          icon: Icon(Icons.dangerous));
                                      return;
                                    }
                                    _ForomKey.currentState!.save();
                                    createPrescription();
                                  },
                                  child: Text(
                                    'Finalize Order',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 28, vertical: 18),
                                      backgroundColor:
                                          Color.fromRGBO(4, 93, 233, 0.8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('No data found');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Card buildCard(String name, String price, int quantity, int id,String? dose,String? description ) {
    Map<String, dynamic> detail = {
      "id_medicine": id,
      "dose": dose,
      "quantity": quantity,
      "description":description
    };


    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color.fromRGBO(230, 255, 230, 1),
      elevation: 15,
      shadowColor: Color.fromRGBO(4, 93, 233, 0.8),
      child: Column(
        children: [
          Slidable(
            startActionPane: ActionPane(motion: StretchMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    medicines.removeWhere(
                        (medicine) => medicine['id_medicine'] == id);
                  });
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(15),
              )
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: subHeadingStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          '\$$price ',
                          style: subHeadingStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        iconSize: 30,
                        icon: Icon(
                          Icons.indeterminate_check_box_rounded,
                          color: Color.fromRGBO(4, 93, 233, 1),
                        ),
                        onPressed: () {
                          if (quantity > 1) {
                            int index = medicines.indexWhere(
                                (medicine) => medicine['id_medicine'] == id);

                            if (index != -1) {
                              setState(() {
                                medicines[index]['quantity'] = quantity - 1;
                              });
                            }
                          } else {
                            Get.snackbar(
                              'Medicine quantity',
                              'Cannot be less than one',
                              margin: EdgeInsets.all(8),
                              icon: Icon(Icons.report_problem),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.lightBlueAccent,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 25,
                        child: Text(
                          '$quantity',
                          style: TextStyle(fontSize: 21),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(
                          Icons.add_box,
                          color: Color.fromRGBO(4, 93, 233, 1),
                        ),
                        onPressed: () {
                          int index = medicines.indexWhere(
                              (medicine) => medicine['id_medicine'] == id);

                          if (index != -1) {
                            setState(() {
                              medicines[index]['quantity'] = quantity + 1;
                            });
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          TextFormField(
            initialValue: dose,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: 'Dose',
                hintStyle: TextStyle(fontSize: 20)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Dose is required';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              detail['dose'] = value!;
            },
          ),
          Divider(height: 10),
          TextFormField(
            initialValue: description,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: 'Description',
                hintStyle: TextStyle(fontSize: 20)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Description is required';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              detail['description'] = value!;
              data.add(detail);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> createRadioListPharmacy() {
    List<Widget> widgets = [];
    for (dynamic pharmacy in pharmacies) {
      widgets.add(
        RadioListTile(
          value: pharmacy['id_pharmacy'],
          groupValue: selectedPharmacy,
          title: Text(pharmacy['name']),
          subtitle: Text(pharmacy['location']),
          onChanged: (val) {
            print("Current User $val");
            setSelectedPharmacy(val);
          },
          selected: selectedPharmacy == pharmacy,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }

  Future<List<Map<String, dynamic>>> chossePharmacy(
      List<Map<String, dynamic>> medicines) async {
    print(medicines);
    final url = 'http://127.0.0.1:8000/api/chossePharmacy';

    // Prepare the request body
    final requestBody = json.encode(medicines);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print(responseData);
        final pharmacisies =
            List<Map<String, dynamic>>.from(responseData['pharmacies']);

        return pharmacisies;
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('No data found');
      }
    } catch (error) {
      print('Error sending request: $error');
      throw Exception('Failed to get data');
    }
  }

  Future<void> createPrescription() async {
    print(1);
    try {
      final String jsonStr = jsonEncode({
        'id_renew' :idR,
        'id_file': idFile,
        'id_pharmacy': selectedPharmacy,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'detail': data
      });

      print('data = $jsonStr');
      var res = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/createPres'),
          body: jsonStr,
          headers: {'Content-Type': 'application/json'});

      print(res);
      if (res.statusCode == 200) {
        Get.snackbar('Prescription sent successfully',
            'The pharmacist will check your request soon',
            duration: Duration(seconds: 5), backgroundColor: Colors.green);
        Get.to(DoctorHomePage());
      } else {
        Get.snackbar(
            'Error  ${res.statusCode}', 'Some error happens please try again',
            duration: Duration(seconds: 5), backgroundColor: Colors.red);

        print('Status dode: ${res.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
