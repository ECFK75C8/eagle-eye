import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

import '../utils/scanner_utils.dart';
import '../utils/text_Detector_painter.dart';

class CaptureScreen extends StatefulWidget {
  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final String matchString =
      r'(^[A-Z]{3}[ -][0-9]{3}[A-Z]{2}$)|(^[A-Z]{2}[0-9]{3}[ -][A-Z]{3}$)';
  bool _isDetecting = false;

  VisionText _textScanResults;

  final CameraLensDirection _direction = CameraLensDirection.back;

  CameraController _camera;

  final TextRecognizer _textRecognizer =
      FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _textRecognizer.close();
    _camera?.dispose();
  }

  Future<VisionText> Function(FirebaseVisionImage image)
      _getDetectionMethod() => _textRecognizer.processImage;

  void _setupCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(description, ResolutionPreset.medium);

    await _camera.initialize();

    _camera.startImageStream((image) {
      if (_isDetecting) return;

      setState(() {
        _isDetecting = true;
      });

      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then((results) {
        setState(() {
          if (results != null) {
            setState(() {
              _textScanResults = results;
            });
          }
        });
      }).whenComplete(() => _isDetecting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        (_camera == null)
            ? Container(
                color: Colors.black,
              )
            : Container(
                height: MediaQuery.of(context).size.height - 150,
                child: CameraPreview(_camera),
              ),
        _buildResults(_textScanResults)
      ],
    ));
  }

  Widget _buildResults(VisionText scanResults) {
    CustomPainter painter;
    if (scanResults != null) {
      final Size imageSize = Size(_camera.value.previewSize.height - 100,
          _camera.value.previewSize.width);

      painter = TextDetectorPainter(imageSize, scanResults);
      // getWords(scanResults);
      return CustomPaint(
        painter: painter,
      );
    } else
      return Container();
  }
}
