import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'contact_inbox_page.dart';
import 'my_medicines_page.dart';
import 'complain_page.dart';
import '/login.dart';

import '../theme.dart';
import 'information_page.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {

  int selectedPage = 1;
  int screen =  1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(9, 198, 249, 0.5),
            Color.fromRGBO(4, 93, 233, 0.8)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            ListTile(
              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.nights_stay)),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: const Icon(Icons.person_2),
              ),
              title: Text(
                'Hey, Ahmed',
                style: headingStyle,
              ),
              subtitle: const Text(
                'Good Morning',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: screen==2 ? InformationPage() : GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: <Widget>[
                          buildGestureDetector('My \nFiles', MyMedicinesPage()),
                          buildGestureDetector('Contact', ContactInboxPage()),
                          buildGestureDetector('Account Complain', ComplainPage()),

                        ],
                      ),
                    ),
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.lightBlueAccent,blurRadius: 5,offset: Offset(0,5))
                        ],
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[200]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            iconSize: 40,
                            color: selectedPage == 1?Color.fromRGBO(4, 93, 233, 0.8):Colors.blueGrey,
                            icon: const Icon(
                              Icons.home,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPage =1;
                                screen = 1;
                              });
                            },
                          ),
                          IconButton(
                            iconSize: 40,
                            color: selectedPage == 2?Color.fromRGBO(4, 93, 233, 0.8):Colors.blueGrey,
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              setState(() {
                                screen = 2;
                                selectedPage = 2;
                              });
                            },
                          ),
                          IconButton(
                            iconSize: 40,
                            color: selectedPage == 3?Color.fromRGBO(4, 93, 233, 0.8):Colors.blueGrey,
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              setState(() {
                                Get.offAll(LoginPage());
                                selectedPage = 3;
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildGestureDetector(String title, next) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                  color: Colors.black54,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 5)
            ],
            gradient: LinearGradient(
                colors: [Colors.grey[400]!, Colors.grey[100]!],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
            borderRadius: BorderRadius.circular(16)),
        child: Text(
          title,
          style: headingStyle,
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () async {
        Get.to(next);
      },
    );
  }
}
