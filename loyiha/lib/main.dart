import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loyiha/bir.dart';
import 'package:loyiha/rr.dart';
import 'package:loyiha/ss.dart';
import 'package:loyiha/zz.dart';
import 'saf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  AnimationController? _animationController;
  Animation<double>? _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Aylanish davomiyligini uzaytirdik
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  static List<Widget> _widgetOptions = [
    www(),
    Rrss(),
    Archa(),
    MyWidget(),
    Salom(), // Ensure Salom is defined
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // Trigger animation only for the selected index
      _animationController?.forward().then((_) {
        _animationController?.reverse();
      });
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 30, 43, 235),
        items: <Widget>[
          _buildAnimatedIcon(Icons.home, 0),
          _buildAnimatedIcon(Icons.search, 1),
          _buildAnimatedIcon(Icons.person, 2),
          _buildAnimatedIcon(Icons.settings, 3),
          _buildAnimatedIcon(Icons.person, 4),
        ],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }

  Widget _buildAnimatedIcon(IconData iconData, int index) {
    return AnimatedBuilder(
      animation: _rotationAnimation!,
      builder: (context, child) {
        return Transform.rotate(
          angle: _selectedIndex == index ? _rotationAnimation!.value * 2.0 * 3.14 : 0.0, // Rotate only if selected
          child: Icon(
            iconData,
            size: 30,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
