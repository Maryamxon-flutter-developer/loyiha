import 'package:flutter/material.dart';

class www extends StatefulWidget {
  const www({super.key});

  @override
  State<www> createState() => _wwwState();
}

class _wwwState extends State<www> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Siz uchun bu sahifa bonus",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
}