import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
  import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  late CameraDescription cameraSuper;
  
  int counter = 0;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    cameraSuper = widget.camera;
  }

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
  
  get camera => null;

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
      drawer: Builder(builder: (context) =>
       Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  ),
              ),
              ListTile(
                title: Text('Flash'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    TelaFlash(camera: cameraSuper))
                    );
                },
              ),
              ListTile(
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    TelaCamera(camera: cameraSuper))
                    );
                },
              ),
            ],
             ),
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
    );
  }
}


class TelaFlash extends StatefulWidget {
  final CameraDescription camera;
  const TelaFlash({Key? key, required this.camera}) : super (key:key);

  @override
  State<StatefulWidget> createState() {
    return TelaFlashState();
  }
}

class TelaFlashState extends State<TelaFlash> {
  late CameraController _controller;

  bool statusFlash = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void ligarFlash() {
    setState(() {
      statusFlash= !statusFlash;
      _controller.setFlashMode(statusFlash ? FlashMode.torch : FlashMode.off);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(appBar: AppBar(title: Text ("Flash"),),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
            child: Text("Ligar Flash"),
            onPressed: () async {
              var status = await Permission.camera.request();
              if (status.isGranted) {
                ligarFlash();
              } else if (status.isDenied) {
                
              } else if (status.isPermanentlyDenied) {
                
              }
              
            },
          ),
          ElevatedButton(
            child: Text("Voltar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )]),
        ),)
      )
    );
  }
}

class TelaCamera extends StatefulWidget {
  final CameraDescription camera;
  const TelaCamera({Key? key, required this.camera}) : super (key:key);

  @override
  State<StatefulWidget> createState() {
    return TelaCameraState();
  }
}

class TelaCameraState extends State<TelaCamera> {
  late CameraController _controller;

  late Future<void> initializeControllerFuture;

@override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicture() async {
    try {
      await initializeControllerFuture;
      final XFile picture = await _controller.takePicture();
      // Aqui você pode salvar ou exibir a foto tirada
      print('Salva ${picture.path}');
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tirar Foto'),
      ),
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
    );
  }
}