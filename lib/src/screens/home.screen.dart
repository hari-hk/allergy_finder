import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'show_picture.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  static const routeName = '/';

  final List<CameraDescription> cameras;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    _initializeControllerFuture = _controller.initialize();
    setState(() {}); // Rebuild after initializing the camera
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 5,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              icon: const Icon(Icons.account_circle, size: 40.0))
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          try {
            final image = await _controller.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShowPicture(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(' issue in taking picture 111');
          }
        },
        child: const Icon(
          Icons.camera,
          size: 60,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
