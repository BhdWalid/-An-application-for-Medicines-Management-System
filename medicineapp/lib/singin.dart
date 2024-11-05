import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'login.dart';
import 'size_config.dart';
import 'package:http/http.dart' as http;


class SinginPage extends StatefulWidget {
  const SinginPage({Key? key}) : super(key: key);

  @override
  State<SinginPage> createState() => _SinginPageState();
}

class _SinginPageState extends State<SinginPage> {

  dynamic role ;
  bool visiable = false;
  List items = ['pharmacist', 'doctor'];
  final GlobalKey<FormState> _ForomKey = GlobalKey();
  final Map<String, String> _autData = {
    'email': '',
    'password': '',
    'first_name': '',
    'last_name': '',
    'phone_number': '',
    'address': '',
    'type_user': '',
    'specialty' : '',
    'name' : '',
    'location' : ''
  };
  final _passwordcontroler = TextEditingController();
  final _emailcontroler = TextEditingController();
  final _first_namecontroler = TextEditingController();
  final _last_namecontroler = TextEditingController();
  final _phone_numbercontroler = TextEditingController();
  final _addresscontroler = TextEditingController();
  final _specialtycontroler = TextEditingController();
  final _locationcontroller = TextEditingController();

  final _namecontroller = TextEditingController();



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
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(9, 198, 249, 0.5),
              Color.fromRGBO(4, 93, 233, 0.8)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _ForomKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 50,
                      left: SizeConfig.screenWidth * 0.05,
                      right: SizeConfig.screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('images/cover.png'),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text('Create an account',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(4, 93, 233, 1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
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
                                    controller: _first_namecontroler,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'First name'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'First name is required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      if (value == null) {
                                        return;
                                      } else {
                                        _autData['first_name'] = value;
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
                                        border: InputBorder.none,
                                        hintText: 'Last name'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Last name is required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      if (value == null) {
                                        return;
                                      } else {
                                        _autData['last_name'] = value;
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
                                        _autData['email'] = value.toLowerCase();
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
                                        border: InputBorder.none,
                                        hintText: 'Phone number'),
                                    validator: (value) {
                                      if (value!.length != 10 ||
                                          value!.contains(' ')) {
                                        return 'Phone number is not valid';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      if (value == null) {
                                        return;
                                      } else {
                                        _autData['phone_number'] = value;
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
                                        border: InputBorder.none,
                                        hintText: 'Address'),
                                    validator: (value) {
                                      if (value!.isEmpty || value!.length < 9) {
                                        return 'Address is not valid';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      if (value == null) {
                                        return;
                                      } else {
                                        _autData['address'] = value;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all( 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ))),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      value: role,
                                      items: items.map(buildMenuItem).toList(),
                                      hint: Text('Choose your role'),
                                      style: TextStyle(color: Colors.black,
                                          fontSize: 16),
                                      onChanged: (value) {
                                        setState(() {

                                          role = value;
                                          _autData['type_user'] = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: _autData['type_user'] == 'doctor',
                                  child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ))),
                                  child: TextFormField(
                                    controller: _specialtycontroler,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Specialty'),
                                    validator: (value) {
                                      if (value!.isEmpty || value!.length < 3) {
                                        return 'Specialty is required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      if (value == null) {
                                        return;
                                      } else {
                                        _autData['specialty'] = value;
                                      }
                                    },
                                  ),
                                ),),

                                Padding(
                                  padding: const EdgeInsets.all(10),
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
                                      if( value ==null) {
                                        return;
                                      }
                                      _autData['password'] = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: _autData['type_user'] == 'pharmacist',
                            child: Container(
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
                                  Text('Pharmacy Information',style: TextStyle(fontSize: 24,)),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                            ))),
                                    child: TextFormField(
                                      controller: _namecontroller,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Pharmacy name'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length <6) {
                                          return 'The name is not valid';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        if (value == null) {
                                          return;
                                        } else {
                                          _autData['name'] = value;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),

                                    child: TextFormField(
                                      controller: _locationcontroller,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Location'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length <6) {
                                          return 'Location is not valid';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        if (value == null) {
                                          return;
                                        } else {
                                          _autData['location'] = value;
                                        }
                                      },
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
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
                                  singin();
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ],
                      ),

                      Center(
                          child: TextButton(
                              onPressed: () {
                                Get.off(() => LoginPage());
                              },
                              child: Text('I have an account >',
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


  void singin() {
    if (!_ForomKey.currentState!.validate()) {
      return;
    }
    _ForomKey.currentState!.save();
    singAuth();
  }

  Future<void> singAuth() async {
    try {
      final String jsonStr = jsonEncode(_autData);
      print(jsonStr);
      var res = await http.post(Uri.parse('http://127.0.0.1:8000/api/CreerAccount'),
          body: jsonStr, headers: {'Content-Type': 'application/json'});

      print(res);
      if (res.statusCode == 200) {
        print(res.statusCode);
        print(res.body);
        var obj = jsonDecode(res.body) as Map<String, dynamic>;
        print(obj['message']);

      Get.snackbar('Account created successfully', 'The admin will check your request soon',duration: Duration(seconds: 5), backgroundColor: Colors.green);
      Get.to(LoginPage());
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
}
