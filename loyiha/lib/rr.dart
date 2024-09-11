import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Vaqtni formatlash uchun
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences uchun

class Rrss extends StatefulWidget {
  const Rrss({super.key});

  @override
  State<Rrss> createState() => _RrssState();
}

class _RrssState extends State<Rrss> {

  List<Map<String, String>> _dataList = []; // Ma'lumot va vaqtni saqlaydigan ro'yxat
  String _inputText = '';
  int? _editIndex; // Tahrirlash uchun indeks

  @override
  void initState() {
    super.initState();
    _loadData(); // Ma'lumotlarni yuklash
  }

  // Ma'lumotlarni yuklash funksiyasi
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedData = prefs.getStringList('dataList');

    if (savedData != null) {
      setState(() {
        _dataList = savedData.map((item) {
          List<String> splitItem = item.split('|');
          return {
            'text': splitItem[0],
            'timestamp': splitItem[1],
          };
        }).toList();
      });
    }
  }

  // Ma'lumotlarni saqlash funksiyasi
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = _dataList.map((item) => '${item['text']}|${item['timestamp']}').toList();
    prefs.setStringList('dataList', stringList);
  }

  void _showAddDialog({int? index}) {
    _editIndex = index;
    if (index != null) {
      _inputText = _dataList[index]['text']!;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Dialogni tashqaridan bosish bilan yopishni oldini oladi
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            index == null ? "Malumot kiriting" : "Malumotni tahrirlang",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(173, 43, 52, 231),
          elevation: 0,
          content: GlassMorphismEffect(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _inputText = value;
                      });
                    },
                    controller: TextEditingController(text: _inputText),
                    decoration: InputDecoration(
                      hintText: 'Ism Kiriting',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dialogni yopish
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_inputText.isNotEmpty) {
                            if (_editIndex == null) {
                              setState(() {
                                _dataList.add({
                                  'text': _inputText,
                                  'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
                                }); // Yangi malumot va vaqt qo'shish
                              });
                            } else {
                              setState(() {
                                _dataList[_editIndex!] = {
                                  'text': _inputText,
                                  'timestamp': _dataList[_editIndex!]['timestamp']! // Eskisini saqlash
                                }; // Malumotni tahrirlash
                              });
                            }
                            _saveData(); // Ma'lumotni saqlash
                          }
                          Navigator.of(context).pop(); // Dialogni yopish
                          _inputText = ''; // Inputni tozalash
                          _editIndex = null; // Indeksni qayta tiklash
                        },
                        child: Text(index == null ? 'Add' : 'Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editItem(int index) {
    _showAddDialog(index: index);
  }

  void _deleteItem(int index) {
    setState(() {
      _dataList.removeAt(index);
      _saveData(); // Ma'lumotni o'chirganda saqlash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image(
                image: AssetImage("assets/q.webp"),
                fit: BoxFit.cover,
              ), // Background image
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: _dataList.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value['text']!;
                String timestamp = entry.value['timestamp']!;
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(113, 233, 237, 240).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item,
                              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 22, 62, 238), fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Qo\'shilgan vaqti: ',
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                            Text(
                              ' $timestamp',
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editItem(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteItem(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

// Glassmorphism effect widget
class GlassMorphismEffect extends StatelessWidget {
  final Widget child;

  const GlassMorphismEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
