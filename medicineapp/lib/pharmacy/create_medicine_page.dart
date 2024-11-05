
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
import 'stock_page.dart';

class CreateMedicinePage extends StatefulWidget {
  const CreateMedicinePage({Key? key}) : super(key: key);

  @override
  State<CreateMedicinePage> createState() => _CreateMedicinePage();
}

class _CreateMedicinePage extends State<CreateMedicinePage> {


  Future<void> add(
      {required String medicineName,
      required double price,
      required String image,
      required String bar_code}) async {
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/addToMedicine');
      print(1);

      var data = {
        "name_medicine": medicineName.toLowerCase(),
        "price": price,
        "bar_code": bar_code,
        "image" : image
      };

      var response = await http.post(url, body: convert.jsonEncode(data),headers:{
        "Content-Type" : "application/json"
      });
      if (response.statusCode == 200) {
        Get.snackbar("Successful", "The medicine added Successfully",backgroundColor: Colors.green);
        Get.to(StockPage());
        print('Request failed with status:  ${response.statusCode}.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Request failed with status: ${response.body}.');
        Get.snackbar("${response.statusCode}", "${response.body}",backgroundColor: Colors.red);
      }
    } catch (ex) {
      print(ex);
    }
  }
  final GlobalKey<FormState> _ForomKey = GlobalKey();

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codebarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new medicine'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: SizeConfig.screenWidth,
        child: Form(
          key: _ForomKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 14),
                Text('Add Medicine', style: headingStyle),
                const SizedBox(height: 16),
                InputField(
                  title: 'Medicine name',
                  note: 'Enter the medicine name.',
                  controller: _medicineNameController,
                ),
                const SizedBox(height: 16),
                InputField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d*)?'))
                  ],
                  title: 'Code Bar',
                  keyboardType: TextInputType.numberWithOptions(),
                  note: 'Enter the medicine code bar.',
                  controller: _codebarController,
                ),
                const SizedBox(height: 16),
                InputField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d*)?\.?\d{0,2}'))
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  title: 'Price',
                  note: 'Enter the medicine price.',
                  controller: _priceController,
                ),
                const SizedBox(height: 16),
                InputField(
                  validator: false,
                  title: 'Image',
                  note: 'Enter the image name.',
                  controller: _imageController,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                MyButton(
                    label: 'Add the medicine',
                    onTap: () {
                      if (!_ForomKey.currentState!.validate()) {
                        return;
                      }

                      _ForomKey.currentState!.save();
                      showDialog(
                          context: context,
                          builder: (ctx) => _myAlert(
                              medicineName: _medicineNameController.text,
                              codebar: _codebarController.text,
                              price: double.parse(_priceController.text),
                              image: _imageController.text,));

                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _myAlert(
      {required String medicineName,
        required String codebar,
        required double price,
        required String image,
        }) {
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
            Text('Code Bar : $codebar', style: titleStyle),
            SizedBox(height: 10),
            Text('Price : $price', style: titleStyle),
            SizedBox(height: 10),
            Text('Image : $image',
                style: titleStyle),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(label: 'Confirm', onTap: () {

                 add(medicineName: medicineName, price: price, image: image, bar_code: codebar);

                  Navigator.pop(context,'Confirm');}),
                MyButton(label: 'Cancel', onTap: () {Navigator.pop(context,'Cancel');}),
              ],
            )
          ],
        ),
      ),
      title: const Text('Confirm Your Data'),
    );
  }
}
