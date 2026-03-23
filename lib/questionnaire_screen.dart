import 'dart:io';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class QuestionNode {
  final String question;
  final String? yesNext;
  final String? noNext;
  final double yesImpact;
  final double noImpact;

  QuestionNode({
    required this.question,
    this.yesNext,
    this.noNext,
    required this.yesImpact,
    required this.noImpact,
  });
}

class QuestionnaireScreen extends StatefulWidget {
  final File image;
  final Map<String, dynamic> result;

  const QuestionnaireScreen({
    super.key,
    required this.image,
    required this.result,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late Map<String, QuestionNode> tree;

  String currentNodeKey = "q1";

  double updatedConfidence = 0.0;

  Map<String, bool> answers = {};

  int answeredQuestions = 0;

  int totalQuestions = 0;

  int currentDiseaseIndex = 0;

  List<Map<String, dynamic>> predictions = [];

  @override
  void initState() {
    super.initState();

    final disease = widget.result['topLabel'];

    /// Skip questionnaire for healthy or invalid image
    if (disease == "Healthy Skin" || disease == "Not a skin image") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              image: widget.image,
              result: widget.result,
            ),
          ),
        );
      });
      return;
    }

    predictions = widget.result['allPredictions'] ?? [];
    if (predictions.isEmpty) {
      // Fallback if no predictions
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              image: widget.image,
              result: widget.result,
            ),
          ),
        );
      });
      return;
    }

    currentDiseaseIndex = 0;
    String currentDisease = predictions[currentDiseaseIndex]['label'];
    updatedConfidence = predictions[currentDiseaseIndex]['confidence'];

    tree = _getDecisionTree(currentDisease);

    totalQuestions = tree.length;
  }

  Map<String, QuestionNode> _getDecisionTree(String disease) {
    switch (disease) {
      /// CELLULITIS
      case "Cellulitis":
        return {
          "q1": QuestionNode(
              question: "Is the skin red and swollen?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Does the area feel warm to the touch?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.03),
          "q3": QuestionNode(
              question: "Is the skin painful or tender?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the redness spreading?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Do you have swelling in the area?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Do you have fever or chills?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// IMPETIGO
      case "Impetigo":
        return {
          "q1": QuestionNode(
              question: "Are there red sores or blisters?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Do the sores form yellow crusts?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.09,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Are the sores around the mouth or nose?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Do the sores spread when scratched?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the affected area itchy?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Did the sores start as small blisters?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// ATHLETE'S FOOT
      case "Athlete’s Foot":
        return {
          "q1": QuestionNode(
              question: "Is the skin between your toes itchy?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Is the skin cracked or peeling?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Is there redness between the toes?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Do you feel burning or stinging?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the skin flaky or dry?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Does itching worsen after removing shoes?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// NAIL FUNGUS
      case "Nail Fungus":
        return {
          "q1": QuestionNode(
              question: "Is the nail thickened?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Is the nail yellow or white?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Is the nail brittle or crumbling?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the nail separating from the nail bed?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the nail surface rough?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Has the nail condition lasted more than a month?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// RINGWORM
      case "Ringworm":
        return {
          "q1": QuestionNode(
              question: "Is the rash circular or ring-shaped?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Does the rash have a scaly border?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Is the rash spreading outward?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the rash itchy?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the skin dry or flaky?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Has the rash lasted more than one week?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// CUTANEOUS LARVA MIGRANS
      case "Cutaneous Larva Migrans":
        return {
          "q1": QuestionNode(
              question: "Is there a snake-like rash pattern?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Is the rash very itchy?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Did the rash appear after walking barefoot?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the rash slowly moving across the skin?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the rash red and raised?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Is the rash on the feet or legs?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// CHICKENPOX
      case "Chickenpox":
        return {
          "q1": QuestionNode(
              question: "Are there many small fluid-filled blisters?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Are the blisters spread across the body?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Did you have fever before the rash?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Do the blisters itch?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Do blisters form scabs later?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Did rash start on chest or face?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      /// SHINGLES
      case "Shingles":
        return {
          "q1": QuestionNode(
              question: "Is the rash on one side of the body?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Is the rash painful or burning?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Are there fluid-filled blisters?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Does the rash follow a band pattern?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Is the skin sensitive to touch?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Did pain start before the rash?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      default:
        return {
          "q1": QuestionNode(
              question: "Is the affected area itchy?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.05,
              noImpact: -0.05),
        };
    }
  }

  void _answer(bool isYes) {
    final node = tree[currentNodeKey]!;

    setState(() {
      answers[node.question] = isYes;

      answeredQuestions++;

      updatedConfidence += isYes ? node.yesImpact : node.noImpact;

      updatedConfidence = updatedConfidence.clamp(0.0, 1.0);
    });

    // Check if confidence dropped below 50% and switch to next disease if available
    if (updatedConfidence < 0.5 &&
        currentDiseaseIndex < predictions.length - 1) {
      setState(() {
        currentDiseaseIndex++;
        String newDisease = predictions[currentDiseaseIndex]['label'];
        updatedConfidence = predictions[currentDiseaseIndex]['confidence'];
        tree = _getDecisionTree(newDisease);
        totalQuestions = tree.length;
        answeredQuestions = 0;
        currentNodeKey = "q1";
        answers.clear();
      });
      return; // Don't proceed to next question yet
    }

    final nextKey = isYes ? node.yesNext : node.noNext;

    if (nextKey == null) {
      _finish();
    } else {
      setState(() {
        currentNodeKey = nextKey;
      });
    }
  }

  void _finish() {
    Map<String, dynamic> finalResult = Map.from(widget.result);
    finalResult['topLabel'] = predictions[currentDiseaseIndex]['label'];
    finalResult['topConfidence'] = updatedConfidence;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          image: widget.image,
          result: finalResult,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = tree[currentNodeKey]!;

    double progress = (answeredQuestions / totalQuestions).clamp(0.0, 1.0);
    final topLabel = predictions.isNotEmpty
        ? predictions[currentDiseaseIndex]['label']
        : "Unknown";
    final confidence = (updatedConfidence * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Text(
                        'Questionnaire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Predicted: $topLabel',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Confidence: $confidence%',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Question ${answeredQuestions + 1} of $totalQuestions',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            node.question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _answer(true),
                                  icon: const Icon(Icons.thumb_up_rounded),
                                  label: const Text('Yes'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _answer(false),
                                  icon: const Icon(Icons.thumb_down_rounded),
                                  label: const Text('No'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            node.yesNext == null && node.noNext == null
                                ? 'Last question. Tap your answer to finish.'
                                : 'Tap an answer to continue.',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
