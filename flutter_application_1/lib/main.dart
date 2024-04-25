import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_widget.dart';
import 'package:camera/camera.dart';

main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(AppWidget(camera: firstCamera));
}