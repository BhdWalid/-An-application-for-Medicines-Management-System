import 'package:flutter/material.dart';
import '/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal information', style: headingStyle),
          SizedBox(height: 12),
          Text(
            'First name: Abdelhadi',
            style: subHeadingStyle,
          ),
          Divider(
            height: 8,
          ),
          Text(
            'Last name: Lakaf',
            style: subHeadingStyle,
          ),
          Divider(
            height: 8,
          ),
          Text(
            'Address: 17 Rue 1er November',
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
                  'hadid4704@gmail.com',
                  style: subHeadingStyle,
                ),
              ],
            ),
            onPressed: () => setState(() {
              _sendEmail('hadid4704@gmail.com');
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
                    '0659736703',
                    style: subHeadingStyle,
                  ),
                ],
              ),
              onPressed: () => setState(
                    () {
                      _makePhoneCall('0659736703');
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
