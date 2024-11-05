import 'package:flutter/material.dart';
import '../controler.dart';
import '/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {




  Controller c = Controller();
  get info => c.getAccountInfo();




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal information', style: headingStyle),
          SizedBox(height: 12),
          Text(
            'First name: ${info["first_name"]}',
            style: subHeadingStyle,
          ),
          Divider(
            height: 8,
          ),
          Text(
            'Last name: ${info["last_name"]}',
            style: subHeadingStyle,
          ),
          Divider(
            height: 8,
          ),
          Text(
            'Address: ${info["address"]}',
            style: subHeadingStyle,
          ),
          SizedBox(height: 20),
          Text('Contact info', style: headingStyle),
          SizedBox(height: 12),
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.amber,
                ),
                SizedBox(width: 20),
                Text(
                  '${info["email"]}',
                  style: subHeadingStyle,
                ),
              ],
            ),
            onPressed: () => setState(() {
              _sendEmail('${info["email"]}');
            })
          ),
          Divider(
            height: 8,
          ),
          TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Text(
                    '${info["phone_number"]}',
                    style: subHeadingStyle,
                  ),
                ],
              ),
              onPressed: () => setState(
                    () {
                      _makePhoneCall('${info["phone_number"]}');
                    },
                  )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }
}
