import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/input_field.dart';
import 'pharmacy_home_page.dart';

class EditMedicinePage extends StatefulWidget {
  const EditMedicinePage({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<EditMedicinePage> createState() => _EditMedicinePage();
}

class _EditMedicinePage extends State<EditMedicinePage> {
  int get id => widget.id!;

  Future<void> edit(int id) async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/updateStock/$id');
      print(1);

      var data = {
        "quantity": int.parse(_quantityController.text),
        "date_f": DateFormat("yyyy-MM-dd").format(_manuDate).toString(),
        "date_e": DateFormat("yyyy-MM-dd").format(_expDate).toString()
      };
      // Await the http get response, then decode the json-formatted response.
      var response = await http.put(url,
          body: convert.jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        Get.snackbar("Successful", "The medicine edited Successfully",backgroundColor: Colors.green);

        print('Request suus with status: ${response.statusCode}.');
      } else {
        Get.snackbar("ERROR ${response.statusCode}", "Failed to delete medicine",backgroundColor: Colors.red);

        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (ex) {
      print(ex);
    }
  }

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _manuController = TextEditingController();

  DateTime _manuDate = DateTime.now();
  DateTime _expDate = DateTime.now();


  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(

        title: const Text('Edit medicine'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:FutureBuilder(
            future: fetchStock(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                   var data = snapshot.data!;
                   _medicineNameController.text = data['name_medicine'];
                   _manuDate =_manuDate != DateTime.now() && _manuDate != DateFormat("yyyy-MM-dd").parse(data['date_f'])?_manuDate: DateFormat("yyyy-MM-dd").parse(data['date_f']) ;
                   _quantityController.text = data['quantity'].toString();
                   _expDate = DateFormat("yyyy-MM-dd").parse(data['date_e']) ;
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 14),
                      Text('Edite the stock', style: headingStyle),
                      const SizedBox(height: 16),
                      InputField(
                        widget: Text(''),
                        title: 'Medicine name',
                        note: 'Enter the medicine name.',
                        controller: _medicineNameController,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: _manuController,
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
                        title: 'Exp date',
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
                          label: 'Edite',
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => _myAlert());
                          }),
                    ],
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

  _myAlert() {
    return AlertDialog(
      titleTextStyle: headingStyle,
      content: Container(
        height: 230,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Name : ${_medicineNameController.text}',
              style: titleStyle,
            ),
            SizedBox(height: 10),
            Text('Quantity : ${_quantityController.text}', style: titleStyle),
            SizedBox(height: 10),
            Text('menuDate :  ${DateFormat.yMd().format(_manuDate)}',
                style: titleStyle),
            SizedBox(height: 10),
            Text('expDate : ${DateFormat.yMd().format(_expDate)}',
                style: titleStyle),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                    label: 'Confirm',
                color:Color.fromRGBO(50, 230, 50, 1),
                    onTap: ()async {



                      Get.to(PharmacyHomePage());
                      await edit(id);

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
  Future<Map<String ,dynamic>> fetchStock() async {
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

}
