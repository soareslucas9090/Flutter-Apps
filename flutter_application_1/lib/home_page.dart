import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;

  int currentIndex = 0;

  List<String> imagePaths = [
    '1.jpg',
    '2.jpg',
    '3.jpg',
  ];

  List<Color> buttonColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % imagePaths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Troca a imagem e a cor aí"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePaths[currentIndex],
              width: 500,
              height: 500,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: nextImage,
              child: Text('Próxima imagem'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColors[currentIndex],
                foregroundColor: Colors.black
              ),
            ),
          ],
        ), 
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            nextImage();

          });
        },
      ),
    );
  }
}
