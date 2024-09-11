import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON parsing uchun

class Archa extends StatefulWidget {
  const Archa({super.key});

  @override
  State<Archa> createState() => _ArchaState();
}

class _ArchaState extends State<Archa> {
  String rate = 'Yuklanmoqda...'; // Valyuta kursini saqlaydigan o'zgaruvchi

  @override
  void initState() {
    super.initState();
    _fetchCurrencyRate(); // API so'rovini boshlash
  }

  // API orqali kurs olish funksiyasi
  Future<void> _fetchCurrencyRate() async {
    final url = Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          rate = data[0]['Rate']; // API'dan olingan 'Rate' qiymatini olish
        });
      } else {
        setState(() {
          rate = 'Xato yuz berdi';
        });
      }
    } catch (e) {
      setState(() {
        rate = 'Internet xatosi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
              'Kurs: $rate,UZS', // API dan kelgan kursni ekranga chiqaramiz
              style: TextStyle(fontSize: 24),
            ),
      ),
      body: Column(
        children: [
         
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Number of repetitions of the pattern
              itemBuilder: (context, sectionIndex) {
                return Column(
                  children: List.generate(32, (index) {
                    // Generate each line with increasing number of 'x'
                    return Text(
                      'x' * (index + 1),
                      style: TextStyle(fontSize: 20),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
