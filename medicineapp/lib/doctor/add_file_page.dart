import 'dart:convert';

import 'doctor_home_page.dart';

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

import '../widgets/input_field.dart';

class EditFilePage extends StatefulWidget {
  const EditFilePage({Key? key}) : super(key: key);

  @override
  State<EditFilePage> createState() => _EditFilePageState();
}

class _EditFilePageState extends State<EditFilePage> {

  final GlobalKey<FormState> _ForomKey = GlobalKey();
  final GlobalKey<FormState> reasonKey = GlobalKey();
  final GlobalKey<FormState> _ForomEmailKey = GlobalKey();

  final _passwordcontroler = TextEditingController();
  final _emailcontroler = TextEditingController();
  final _patientemailcontroler = TextEditingController();
  final _first_namecontroler = TextEditingController();
  final _last_namecontroler = TextEditingController();
  final _phone_numbercontroler = TextEditingController();
  final _addresscontroler = TextEditingController();
  final _reasoncontroler = TextEditingController();
  final _reasoncontroler2 = TextEditingController();
  DateTime _birthDate = DateTime.now();

  Controller c = Controller();

  get info => c.getAccountInfo();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new file'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                'The patient have an account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Form(
                key: _ForomEmailKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ))),
                  child: TextFormField(
                    controller: _patientemailcontroler,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.') ||
                          value.contains(' ')) {
                        return 'Email is not valid';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Container(
                  height: 50,
                  //padding: EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(00, 40, 202, 1),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(SizeConfig.screenWidth * 0.95, 45),
                    ),
                    onPressed: () {
                      if (!_ForomEmailKey.currentState!.validate()) {
                        return;
                      }
                      searchEmail();
                    },
                    child: const Text(
                      'Check Account',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              Divider(height: 24),
              Text(
                'Create account for patient',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Form(
                key: _ForomKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _first_namecontroler,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'First name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'First name is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _last_namecontroler,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Last name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Last name is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _emailcontroler,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !value.contains('@') ||
                              !value.contains('.') ||
                              value.contains(' ')) {
                            return 'Email is not valid';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _phone_numbercontroler,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Phone number'),
                        validator: (value) {
                          if (value!.length != 10 || value!.contains(' ')) {
                            return 'Phone number is not valid';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _addresscontroler,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Address'),
                        validator: (value) {
                          if (value!.isEmpty || value!.length < 7) {
                            return 'Address is not valid';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 4),
                    InputField(
                      title: 'Date of birth',
                      note: DateFormat.yMd().format(_birthDate),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getDateFromUser(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ))),
                      child: TextFormField(
                        controller: _reasoncontroler2,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Reason'),
                        validator: (value) {
                          if (value!.isEmpty || value!.length < 2) {
                            return 'Reason is not valid';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Password '),
                  obscureText: true,
                  controller: _passwordcontroler,
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 5) {
                      return 'Password is short';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(00, 40, 202, 1),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(SizeConfig.screenWidth * 0.95, 45),
                    ),
                    onPressed: () {
                      create();
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void create() {
    if (!_ForomKey.currentState!.validate()) {
      return;
    }
    singAuth();
  }

  Future<void> searchEmail() async {
    final url =
        'http://127.0.0.1:8000/api/verifyEmail'; // Replace with your Laravel endpoint URL
    String emai = _patientemailcontroler.text;
    final response = await http.post(
      Uri.parse(url),
      body: {'email': emai},
    );

     if (response.statusCode == 200) {
      print(response.body);

      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      var file = jsonData['account'];
      print(file);
      showDialog(
          context: context,
          builder: (ctx) => _myAlert(
                id: file['id_patient'],
                Fname: file["first_name"],
                lname: file['last_name'],
                email: emai,
              ));
    } else {
      Get.snackbar("Error ${response.statusCode}", "Can't find the account");
      print('Failed to send email');
    }
  }

  Future<void> addFile(String reason, int doctorId, int patientId) async {
    final url =
        'http://127.0.0.1:8000/api/addFile';
    final String jsonStr = jsonEncode({
      'reason': reason,
      'doctor_id_doctor': doctorId,
      'patient_id_patient': patientId,
    });
    print(jsonStr);
    final response = await http.post(Uri.parse(url),
        body: jsonStr, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Get.snackbar("Successful", "The file added Successfully",backgroundColor: Colors.green);
      Get.to(DoctorHomePage());

    } else {
      Get.snackbar("ERROR ${response.statusCode}", "Failed to delete medicine",backgroundColor: Colors.red);

    }
  }

  _myAlert(
      {required int id,
      required String Fname,
      required String lname,
      required String email}) {
    return AlertDialog(
      titleTextStyle: headingStyle,
      content: Container(
        height:270,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('First name : $Fname', style: titleStyle),
            SizedBox(height: 10),
            Text('Last name :  $lname', style: titleStyle),
            SizedBox(height: 10),
            Text('Email : $email', style: titleStyle),
            Form(
              key: reasonKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey.shade300,
                ))),
                child: TextFormField(
                  controller: _reasoncontroler,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Reason'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Reason is required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            MyButton(
                label: 'Confirm',
                color: Color.fromRGBO(50, 230, 50, 1),
                onTap: () async {
                  if (!reasonKey.currentState!.validate()) {
                    return;
                  }
                  print(info['id_doctor']);
                  await addFile(_reasoncontroler.text, info['id_doctor'], id);

                  Get.to(DoctorHomePage());
                })
          ],
        ),
      ),
      title: const Text('Patient information'),
    );
  }

  Future<void> singAuth() async {
    try {
      final String jsonStr = jsonEncode({
        "first_name": _first_namecontroler.text,
        "last_name": _last_namecontroler.text,
        "email": _emailcontroler.text,
        "phone_number": _phone_numbercontroler.text,
        "password": _passwordcontroler.text,
        "type_user": "patient",
        "address": _addresscontroler.text,
        "birthday": DateFormat('yyyy-MM-dd').format(_birthDate).toString(),
        "doctor_id_doctor": info['id_doctor'],
        "reason": _reasoncontroler2.text
      });
      print(jsonStr);
      var res = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/CreerAccount'),
          body: jsonStr,
          headers: {'Content-Type': 'application/json'});

      print(res);
      if (res.statusCode == 200) {
        Get.snackbar('Account created successfully',
            'You can manage the file',
            duration: Duration(seconds: 5), backgroundColor: Colors.green);
        Get.offAll(DoctorHomePage());
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

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null)
      setState(() {
        _birthDate = _pickedDate;
      });
    else
      debugPrint('####### Date Wrong #######');
  }
}
