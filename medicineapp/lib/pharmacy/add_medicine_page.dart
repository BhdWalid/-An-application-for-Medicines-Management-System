import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:get_storage/get_storage.dart';
import '/pharmacy/create_medicine_page.dart';

import '../controler.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:easy_autocomplete/easy_autocomplete.dart';

import '../widgets/input_field.dart';
import 'pharmacy_home_page.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  State<AddMedicinePage> createState() => _AddMedicinePage();
}

class _AddMedicinePage extends State<AddMedicinePage> {
  Controller c = Controller();

  get info => c.getAccountInfo();

  bool isLoading = true;



  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _manuController = TextEditingController();

  DateTime _manuDate = DateTime.now();
  DateTime _expDate = DateTime.now();

  List<String> suggestions = [];
  List listMedicines = [];
  late int id;

  final GlobalKey<FormState> _ForomKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    getMedicines();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Get.to(CreateMedicinePage());
                },
                icon: Icon(Icons.add, size: 35)),
          )
        ],
        title: const Text('Add a new medicine to stock'),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _ForomKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 14),
                      Text('Add Medicine', style: headingStyle),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine name',
                            style: titleStyle,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            padding: EdgeInsets.only(left: 8),
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: EasyAutocomplete(
                                    validator: (value) {
                                      for (var medicine in listMedicines) {
                                        if (medicine['name_medicine'] ==
                                            value) {
                                          id = medicine['id_medicine'];
                                          print(
                                              'User ID: ${medicine['id_medicine']}');
                                          return null;
                                        }
                                      }
                                      return 'This name is not registered';
                                    },
                                    controller: _medicineNameController,
                                    suggestions: suggestions,
                                    onChanged: (value) =>
                                        print('onChanged value: $value'),
                                    onSubmitted: (value) {
                                      _medicineNameController.text = value;
                                      print('onSubmitted value: $value');
                                    },
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter the medicine name.',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Manufacture date',
                        note: DateFormat.yMd().format(_manuDate),
                        widget: IconButton(
                          icon: const Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          onPressed: () => _getDateFromUser('manu'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Expiry date',
                        note: DateFormat.yMd().format(_expDate),
                        widget: IconButton(
                          icon: const Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          onPressed: () => _getDateFromUser('exp'),
                        ),
                      ),

                      const SizedBox(height: 16),
                      InputField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?'))
                        ],
                        keyboardType: TextInputType.number,
                        title: 'Quantity',
                        note: 'Enter the medicine quantity.',
                        controller: _quantityController,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      MyButton(
                          label: 'Add the medicine',
                          onTap: () {
                            if (!_ForomKey.currentState!.validate()) {
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (ctx) => _myAlert(
                                    medicineName: _medicineNameController.text,
                                    quantity: int.parse(_quantityController.text),
                                    menuDate: _manuDate,
                                    expDate: _expDate));
                          }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _getDateFromUser(String selectedDate) async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate == 'manu' ? _manuDate : _expDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null)
      setState(() {
        selectedDate == 'manu'
            ? _manuDate = _pickedDate
            : _expDate = _pickedDate;
        print(_manuController.text);
      });
    else
      debugPrint('####### Date Wrong #######');
  }

  _myAlert(
      {required String medicineName,
      required int quantity,
      required DateTime menuDate,
      required DateTime expDate}) {
    return AlertDialog(
      titleTextStyle: headingStyle,
      content: Container(
        height: 230,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Name : $medicineName',
              style: titleStyle,
            ),
            SizedBox(height: 10),
            Text('Quantity : $quantity', style: titleStyle),
            SizedBox(height: 10),

            Text('menuDate :  ${DateFormat.yMd().format(menuDate)}',
                style: titleStyle),
            SizedBox(height: 10),
            Text('expDate : ${DateFormat.yMd().format(expDate)}',
                style: titleStyle),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                    label: 'Confirm',
                color:Color.fromRGBO(50, 230, 50, 1),
                    onTap: ()async {

                     await add(
                          idM: id,
                          quantity: int.parse(_quantityController.text),
                          menuDate: menuDate,
                          expDate: expDate);

                      Get.to(PharmacyHomePage());
                    }),
                MyButton(
                    label: 'Cancel',
                    color:Color.fromRGBO(255, 0, 33, 1),
                    onTap: () {
                      Navigator.pop(context, 'Cancel');
                    }),
              ],
            )
          ],
        ),
      ),
      title: const Text('Confirm Your Data'),
    );
  }
  Future<void> add(
      {required int idM,
        required int quantity,
        required DateTime menuDate,
        required DateTime expDate}) async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/add_prod');
      print(1);

      var data = {
        "id_pharmacy": info['pharmacy_id_pharmacy'],
        "id_medicine": idM,
        "quantity": quantity,
        "date_f": DateFormat('yyyy-MM-dd').format(menuDate).toString(),
        "date_e": DateFormat('yyyy-MM-dd').format(expDate).toString()
      };
      print(data);
      // Await the http get response, then decode the json-formatted response.
      var response = await http.post(url,
          body: convert.jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        print('Request failed with status: ${response.statusCode}.');
        Get.snackbar("Successful", "The medicine added Successfully",backgroundColor: Colors.green);

      } else {
        print('Request failed with status: ${response.statusCode}.');
        Get.snackbar("Error ${response.statusCode}.", "Failed to add medicine",backgroundColor: Colors.red);

      }
    } catch (ex) {
      print(ex);
    }
  }
  Future getMedicines() async {
    final url = 'http://127.0.0.1:8000/api/allmedecine';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final allMedicines =
          List<Map<String, dynamic>>.from(jsonData['medicines']);

      setState(() {
        print(listMedicines);
        listMedicines = allMedicines;
        suggestions = listMedicines
            .map((medicine) => medicine['name_medicine'].toString())
            .toList();
        isLoading = false;
      });

      if (suggestions.isEmpty) {
        print('No data');
        throw Exception('No data found');
      } else {
        return allMedicines;
      }
    } else {
      throw Exception('Failed to get data');
    }
  }
}
