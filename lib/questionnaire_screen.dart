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

  /// ⭐ STORE USER ANSWERS
  Map<String, bool> answers = {};

  @override
  void initState() {
    super.initState();
    updatedConfidence = widget.result['topConfidence'];
    tree = _getDecisionTree(widget.result['topLabel']);
  }

  /// ===================== DECISION TREES =====================

  Map<String, QuestionNode> _getDecisionTree(String disease) {
    switch (disease) {
      case "FU-ringworm":
        return {
          "q1": QuestionNode(
              question: "Is the rash circular?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.08),
          "q2": QuestionNode(
              question: "Is the skin scaly?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.05),
          "q3": QuestionNode(
              question: "Is it fluid-filled?",
              yesNext: "q6",
              noNext: null,
              yesImpact: -0.12,
              noImpact: 0.02),
          "q4": QuestionNode(
              question: "Is it itchy?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.07,
              noImpact: -0.04),
          "q5": QuestionNode(
              question: "Has it been spreading?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.05,
              noImpact: -0.03),
          "q6": QuestionNode(
              question: "Do you have fever?",
              yesNext: null,
              noNext: null,
              yesImpact: -0.08,
              noImpact: 0.02),
        };

      case "BA- cellulitis":
        return {
          "q1": QuestionNode(
              question: "Is the skin swollen?",
              yesNext: "q2",
              noNext: null,
              yesImpact: 0.09,
              noImpact: -0.07),
          "q2": QuestionNode(
              question: "Is the area painful?",
              yesNext: "q3",
              noNext: "q4",
              yesImpact: 0.08,
              noImpact: -0.05),
          "q3": QuestionNode(
              question: "Is the skin warm to touch?",
              yesNext: "q5",
              noNext: null,
              yesImpact: 0.07,
              noImpact: -0.04),
          "q4": QuestionNode(
              question: "Is redness spreading rapidly?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.06,
              noImpact: -0.04),
          "q5": QuestionNode(
              question: "Do you have fever?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.07,
              noImpact: -0.05),
        };

      case "FU-athlete-foot":
        return {
          "q1": QuestionNode(
              question: "Is there itching between toes?",
              yesNext: "q2",
              noNext: null,
              yesImpact: 0.09,
              noImpact: -0.07),
          "q2": QuestionNode(
              question: "Is the skin peeling?",
              yesNext: "q3",
              noNext: null,
              yesImpact: 0.08,
              noImpact: -0.05),
          "q3": QuestionNode(
              question: "Is there burning sensation?",
              yesNext: "q4",
              noNext: null,
              yesImpact: 0.07,
              noImpact: -0.04),
          "q4": QuestionNode(
              question: "Is the skin cracked?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.06,
              noImpact: -0.03),
        };

      default:
        return {
          "q1": QuestionNode(
              question: "Is the area itchy?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.05,
              noImpact: -0.05),
        };
    }
  }

  /// ===================== HANDLE ANSWER =====================

  void _answer(bool isYes) {
    final node = tree[currentNodeKey]!;

    /// ⭐ STORE ANSWER
    answers[node.question] = isYes;

    updatedConfidence += isYes ? node.yesImpact : node.noImpact;

    updatedConfidence = updatedConfidence.clamp(0.0, 1.0);

    final nextKey = isYes ? node.yesNext : node.noNext;

    if (nextKey == null) {
      _finish();
    } else {
      setState(() {
        currentNodeKey = nextKey;
      });
    }
  }

  /// ===================== FINISH QUESTIONNAIRE =====================

  void _finish() {
    List<dynamic> predictions = List.from(widget.result['allPredictions']);

    String predictedDisease = widget.result['topLabel'];

    for (var p in predictions) {
      if (p['label'] == predictedDisease) {
        p['confidence'] = updatedConfidence;
      }
    }

    predictions.sort((a, b) =>
        (b['confidence'] as double).compareTo(a['confidence'] as double));

    final updatedResult = {
      'topLabel': predictions.first['label'],
      'topConfidence': predictions.first['confidence'],
      'allPredictions': predictions.take(3).toList(),
      'originalConfidence': widget.result['topConfidence'],
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          image: widget.image,
          result: updatedResult,
          answers: answers, // ⭐ PASS ANSWERS
        ),
      ),
    );
  }

  /// ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    final node = tree[currentNodeKey]!;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Symptom Confirmation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  LinearProgressIndicator(
                    value: updatedConfidence,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 60),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      node.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _modernButton(
                    text: "Yes",
                    color: const Color(0xFFAB47BC),
                    onTap: () => _answer(true),
                  ),
                  const SizedBox(height: 20),
                  _modernButton(
                    text: "No",
                    color: Colors.grey,
                    onTap: () => _answer(false),
                  ),
                  const Spacer(),
                  Text(
                    "Current Confidence: ${(updatedConfidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
