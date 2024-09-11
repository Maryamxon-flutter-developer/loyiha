import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class Salom extends StatefulWidget {
  @override
  _SalomState createState() => _SalomState();
}

class _SalomState extends State<Salom> with SingleTickerProviderStateMixin {
  List<bool> _selectedTiles = List<bool>.filled(25, false);
  bool _isComplete = false;
  AnimationController? _animationController;
  Animation<double>? _rotationAnimation;
  bool _isRotated = false; // Aylanish holatini saqlash

  final List<String> _images = List.generate(
    25,
    (index) => 'https://picsum.photos/id/${index + 1}/200/200',
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  void _onTileTap(int index) {
    setState(() {
      _selectedTiles[index] = !_selectedTiles[index];
      if (_selectedTiles[index]) {
        _animationController?.forward();
      } else {
        _animationController?.reverse();
      }
      _isComplete = _selectedTiles.every((tile) => tile);
    });
  }

  void _onAvatarTap() {
    setState(() {
      if (_isRotated) {
        _animationController?.reverse();
      } else {
        _animationController?.forward();
      }
      _isRotated = !_isRotated;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 51, 243),
        title: WidgetMask(
          blendMode: BlendMode.srcATop,
          childSaveLayer: true,
          mask: Image.network(
            "https://media2.giphy.com/media/CKlafeh1NAxz35KTq4/giphy-downsized-large.gif",
            fit: BoxFit.cover,
          ),
          child: Text(
            "1989",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _onAvatarTap,
            child: AnimatedBuilder(
              animation: _rotationAnimation!,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation!.value * 2.0 * 3.14,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/refresh.png"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: AnimatedBuilder(
                    animation: _rotationAnimation!,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.rotationY(
                            _selectedTiles[index] ? _rotationAnimation!.value * 3.14 : 0.0),
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTiles[index] ? Colors.green : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(8),
                            image: _selectedTiles[index]
                                ? DecorationImage(
                                    image: NetworkImage(_images[index]),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (_isComplete)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Rotation Completed!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
