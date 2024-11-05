import '/./theme.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({required this.label, required this.onTap, this.color});

  final String label;
  final Function() onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45 ,
        width: 100,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white,fontSize:16),
        ),
        decoration: BoxDecoration(
            color:color?? primaryClr, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
