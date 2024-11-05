import 'dart:convert';

import 'pharmacy/pharmacy_home_page.dart';

import 'controler.dart';
import 'doctor/doctor_home_page.dart';
import 'patient/patient_home_page.dart';
import 'services/theme_services.dart';
import 'singin.dart';
import 'size_config.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool visiable = false;
  List items = ['pharmacist', 'doctor', 'patient'];
  Controller c = Controller();
  dynamic role;

  final GlobalKey<FormState> _ForomKey = GlobalKey();
  final Map<String, String> _autData = {
    'email': '',
    'password': '',
    'type_user': ''
  };
  final _passwordcontroler = TextEditingController();
  final _emailcontroler = TextEditingController();

  Future<void> loginAuth() async {
    try {
      final String jsonStr = jsonEncode({
        'email': _autData['email']!.toLowerCase(),
        'password': _autData['password'],
        'type_user': _autData['type_user']
      });
      print(jsonStr);
      var res = await http.post(Uri.parse('http://127.0.0.1:8000/api/login'),
          body: jsonStr, headers: {'Content-Type': 'application/json'});

      print(res);
      if (res.statusCode == 200) {
        print(res.statusCode);
        print(res.body);
        var obj = jsonDecode(res.body) as Map<String, dynamic>;
        var info = obj['utilisateur'];
        print(info['type_user']);

        c.saveAccountInfo(info);

        if (obj['utilisateur']['type_user'] == 'doctor')
          Get.to(DoctorHomePage());
        if (obj['utilisateur']['type_user'] == 'pharmacist') {
          return Get.to(PharmacyHomePage());
        }
        if (obj['utilisateur']['type_user'] == 'patient') {
          return Get.to(PatientHomePage());
        }
      } else {
        print('Status dode: ${res.statusCode}');
        setState(() {
          visiable = true;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: SingleChildScrollView(
          controller: ScrollController(initialScrollOffset: 0.8),
            child: Container(
              height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(9, 198, 249, 0.5),
            Color.fromRGBO(4, 93, 233, 0.8)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Form(
          key: _ForomKey,
          child: Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  left: SizeConfig.screenWidth * 0.05,
                  right: SizeConfig.screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('images/cover.png'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Login',
                          style: TextStyle(
                            fontSize: 38,
                            color: Colors.grey[200],
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(height: 5),
                      Visibility(
                        visible: visiable,
                        child: const Text(
                          'Email or password are not valid',
                          style: TextStyle(fontSize: 17, color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              const BoxShadow(
                                  color: Color.fromRGBO(4, 93, 233, 1),
                                  blurRadius: 15,
                                  offset: Offset(0, 8))
                            ]),
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
                                controller: _emailcontroler,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email'),
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !value.contains('@') ||
                                      !value.contains('.')) {
                                    return 'Email is not valid';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  if (value == null) {
                                    return;
                                  } else {
                                    _autData['email'] = value;
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
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password '),
                                obscureText: true,
                                controller: _passwordcontroler,
                                validator: (value) {
                                  if (value!.isEmpty || value.length <= 5) {
                                    return 'Password is short';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  _autData['password'] = value!;
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  value: role,
                                  items: items.map(buildMenuItem).toList(),
                                  hint: Text('Choose your role'),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  onChanged: (value) {
                                    setState(() {
                                      role = value;
                                      _autData['type_user'] = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(00, 40, 202, 1),
                              borderRadius: BorderRadius.circular(50)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize:
                                  Size(SizeConfig.screenWidth * 0.95, 45),
                            ),
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                      Center(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget password',
                              style: TextStyle(color: Colors.grey.shade300),
                            )),
                      ),
                    ],
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () {
                            Get.off(SinginPage());
                          },
                          child: Text('Create a new account >',
                              style: TextStyle(color: Colors.black)))),
                ],
              )),
        ),
      ),
    ));
  }

  DropdownMenuItem buildMenuItem(item) {
    return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  void login() {
    if (!_ForomKey.currentState!.validate()) {
      return;
    }

    _ForomKey.currentState!.save();
    loginAuth();
  }
}
