import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:camera/camera.dart';

class AppWidget extends StatelessWidget {
  final CameraDescription camera;

  const AppWidget({super.key, required this.camera});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(camera: camera),
    );
  }
}