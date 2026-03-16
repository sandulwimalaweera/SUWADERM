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

    updatedConfidence = widget.result['topConfidence'];

    tree = _getDecisionTree(disease);

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          image: widget.image,
          result: widget.result,
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
                    "Symptom Confirmation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  LinearProgressIndicator(value: progress),
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _answer(true),
                    child: const Text("Yes"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _answer(false),
                    child: const Text("No"),
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
