import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuSliderPage(),
    );
  }
}

class MenuSliderPage extends StatefulWidget {
  const MenuSliderPage({super.key});

  @override
  _MenuSliderPageState createState() => _MenuSliderPageState();
}

class _MenuSliderPageState extends State<MenuSliderPage> {
  int selectedIndex = 0;

  final items = [
    {"title": "Home", "color": Colors.red},
    {"title": "About", "color": Colors.blue},
    {"title": "Services", "color": Colors.green},
    {"title": "Contact", "color": Colors.orange},
  ];

  final List<GlobalKey> itemKeys = [];

  double sliderLeft = 0;
  double sliderWidth = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < items.length; i++) {
      itemKeys.add(GlobalKey());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSlider();
    });
  }

  void updateSlider() {
    final RenderBox renderBox =
        itemKeys[selectedIndex].currentContext!.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    setState(() {
      sliderLeft = position.dx;
      sliderWidth = size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          items[selectedIndex]["title"] as String,
          style: TextStyle(fontSize: 28),
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return GestureDetector(
                  key: itemKeys[index],
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });

                    Future.delayed(Duration(milliseconds: 10), () {
                      updateSlider();
                    });
                  },
                  child: Text(
                    items[index]["title"] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),

            AnimatedPositioned(
              duration: Duration(milliseconds: 450),
              curve: Curves.easeInOutCubic,
              left: sliderLeft,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 450),
                width: sliderWidth,
                height: 4,
                color: items[selectedIndex]["color"] as Color,
              ),
            ),
          ],
        ),
      ),
    );
  }