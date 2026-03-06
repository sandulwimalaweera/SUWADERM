import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinDiseaseClassifier {
  Interpreter? _interpreter;
  late List<String> _labels;

  static const int inputSize = 299;

  Future<void> loadModel() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/skin_disease_model_finetuned.tflite',
      options: InterpreterOptions()..threads = 2,
    );

    final raw = await rootBundle.loadString('assets/labels.txt');
    _labels = raw.split('\n').where((e) => e.isNotEmpty).toList();
  }

  Future<Map<String, dynamic>> classifyImage(File file) async {
    await loadModel();

    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      return {
        'topLabel': 'Invalid image',
        'topConfidence': 0.0,
        'allPredictions': []
      };
    }

    final resized =
        img.copyResize(decoded, width: inputSize, height: inputSize);

    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final p = resized.getPixel(x, y);
            return [p.r / 255, p.g / 255, p.b / 255];
          },
        ),
      ),
    );

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter!.run(input, output);

    final probs = output[0];

    final predictions = List.generate(_labels.length, (i) {
      return {
        'label': _labels[i],
        'confidence': probs[i],
      };
    });

    predictions.sort((a, b) =>
        (b['confidence'] as double).compareTo(a['confidence'] as double));

    final topLabel = predictions.first['label'];
    final topConfidence = predictions.first['confidence'] as double;

    /// ============================
    /// NOT-SKIN IMAGE DETECTION
    /// ============================
    const double threshold = 0.60;

    if (topConfidence < threshold) {
      return {
        'topLabel': 'Not a skin image',
        'topConfidence': topConfidence,
        'allPredictions': [],
      };
    }

    return {
      'topLabel': topLabel,
      'topConfidence': topConfidence,
      'allPredictions': predictions.take(3).toList(),
    };
  }

  void dispose() {
    _interpreter?.close();
  }
}
