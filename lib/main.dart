import 'dart:ui' as ui;
import 'package:face_detector_app/face_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FaceDetectorApp());
}

class FaceDetectorApp extends StatelessWidget {
  const FaceDetectorApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FaceDetector App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FaceDetectorHomePage(title: 'Face Detector App'),
    );
  }
}

class FaceDetectorHomePage extends StatefulWidget {
  const FaceDetectorHomePage({super.key, required this.title});

  final String title;

  @override
  State<FaceDetectorHomePage> createState() => _FaceDetectorHomePageState();
}

class _FaceDetectorHomePageState extends State<FaceDetectorHomePage> {
  late FaceDetector _faceDetector;
  late ui.Image _image;
  late List<Face> _faces;
  var loaded = false;

  @override
  void initState() {
    _faceDetector = FaceDetector(
        options:
            FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getImageFromGallery() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final image = InputImage.fromFilePath(imageFile.path);
      List<Face> faces = await _faceDetector.processImage(image);

      await _loadImage(imageFile);

      setState(() {
        _faces = faces;
        loaded = true;
      });
    }
  }

  _loadImage(XFile xfile) async {
    final dataBytes = await xfile.readAsBytes();
    await decodeImageFromList(dataBytes).then((value) => {
          setState(() {
            _image = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loaded)
              Center(
                child: FittedBox(
                  child: SizedBox(
                    width: _image.width.toDouble(),
                    height: _image.height.toDouble(),
                    child: CustomPaint(painter: FacePainter(_image, _faces)),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Take photo with Camera")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    getImageFromGallery();
                  },
                  child: const Text("Open Gallery")),
            )
          ],
        ));
  }
}
