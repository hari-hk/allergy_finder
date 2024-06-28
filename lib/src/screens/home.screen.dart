import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_controller),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: IconButton.outlined(
                        style: IconButton.styleFrom(
                          iconSize: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShowPictureView(
                                imagePath: pickedFile!.path,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.image)),
                  ),
                  Positioned(
                    bottom: 20,
                    child: IconButton.outlined(
                        style: IconButton.styleFrom(
                          iconSize: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          final image = await _controller.takePicture();
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShowPictureView(
                                imagePath: image.path,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.camera)),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
