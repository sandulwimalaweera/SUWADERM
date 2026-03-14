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

  @override
  void initState() {
    super.initState();

    updatedConfidence = widget.result['topConfidence'];

    tree = _getDecisionTree(widget.result['topLabel']);

    totalQuestions = tree.length;
  }

  Map<String, QuestionNode> _getDecisionTree(String disease) {
    switch (disease) {
      case "FU-ringworm":
        return {
          "q1": QuestionNode(
              question: "Is the rash circular or ring shaped?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Does the rash have a raised or scaly border?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Is the rash spreading slowly?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the affected area itchy?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.06,
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
              yesImpact: 0.03,
              noImpact: -0.02),
        };

      case "FU-eczema":
        return {
          "q1": QuestionNode(
              question: "Is the skin very itchy?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Is the skin dry or cracked?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Is there redness or swelling?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Does irritation worsen in cold weather?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Do you notice dry skin patches?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Do symptoms appear repeatedly?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      case "FU-psoriasis":
        return {
          "q1": QuestionNode(
              question: "Are there thick red patches?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Are the patches covered with silvery scales?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.09,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Does the skin crack or bleed?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Are patches on elbows or knees?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.06,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Do the patches itch or burn?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Have symptoms appeared repeatedly?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      case "FU-acne":
        return {
          "q1": QuestionNode(
              question: "Are there pimples or bumps?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.10,
              noImpact: -0.05),
          "q2": QuestionNode(
              question: "Are the bumps filled with pus?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.08,
              noImpact: -0.04),
          "q3": QuestionNode(
              question: "Are there blackheads or whiteheads?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.07,
              noImpact: -0.03),
          "q4": QuestionNode(
              question: "Is the skin oily?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Are the bumps painful when touched?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Have the pimples appeared recently?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.04,
              noImpact: -0.02),
        };

      default:
        return {
          "q1": QuestionNode(
              question: "Is the affected area itchy?",
              yesNext: "q2",
              noNext: "q3",
              yesImpact: 0.05,
              noImpact: -0.03),
          "q2": QuestionNode(
              question: "Is the skin red or inflamed?",
              yesNext: "q4",
              noNext: "q5",
              yesImpact: 0.05,
              noImpact: -0.02),
          "q3": QuestionNode(
              question: "Is there swelling?",
              yesNext: "q5",
              noNext: "q4",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q4": QuestionNode(
              question: "Has the condition worsened recently?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q5": QuestionNode(
              question: "Does the skin feel irritated or painful?",
              yesNext: "q6",
              noNext: "q6",
              yesImpact: 0.04,
              noImpact: -0.02),
          "q6": QuestionNode(
              question: "Has the condition lasted more than one week?",
              yesNext: null,
              noNext: null,
              yesImpact: 0.03,
              noImpact: -0.02),
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
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = tree[currentNodeKey]!;

    double progress = (answeredQuestions / totalQuestions).clamp(0.0, 1.0);

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
                    "Symptom Questionnaire",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation(Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$answeredQuestions questions answered",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
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
                          fontSize: 18, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _modernButton(
                      "Yes", const Color(0xFFAB47BC), () => _answer(true)),
                  const SizedBox(height: 20),
                  _modernButton("No", Colors.grey, () => _answer(false)),
                  const Spacer(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernButton(String text, Color color, VoidCallback onTap) {
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
