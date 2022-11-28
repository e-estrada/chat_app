import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  
  final String text;
  final Function onPressed;

  const BotonAzul({
    super.key, 
    required this.text, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 2,
        backgroundColor: Colors.blue
      ),
      onPressed: () => onPressed(),
      // onPressed: null,
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 17),)),
      ),
    );
  }
}