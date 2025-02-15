import 'package:flutter/material.dart';
import 'package:growell_app/pages/bottom_navigation.dart';

class OnboardingQuestions extends StatefulWidget {
  const OnboardingQuestions({super.key});

  @override
  State<OnboardingQuestions> createState() => _OnboardingQuestionsState();
}

class _OnboardingQuestionsState extends State<OnboardingQuestions> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Berapa umur kamu saat ini?',
      'type': 'number',
      'field': 'age',
      'unit': 'tahun'
    },
    {
      'question': 'Berapa tinggi badan kamu?',
      'type': 'number',
      'field': 'height',
      'unit': 'cm'
    },
    {
      'question': 'Berapa berat badan kamu?',
      'type': 'number',
      'field': 'weight',
      'unit': 'kg'
    },
    {
      'question': 'Apa jenis kelamin kamu?',
      'type': 'choice',
      'field': 'gender',
      'options': ['Laki-laki', 'Perempuan']
    },
    {
      'question': 'Bagaimana level aktivitas kamu sehari-hari?',
      'type': 'choice',
      'field': 'activity_level',
      'options': ['Rendah', 'Sedang', 'Tinggi']
    },
    {
      'question': 'Apakah kamu memiliki alergi makanan?',
      'type': 'text',
      'field': 'alergic',
      'hint': 'Masukkan alergi atau ketik "tidak ada"'
    },
  ];

  Map<String, dynamic> _answers = {};
  int _currentPage = 0;

  void _nextQuestion(String answer) {
    _answers[_questions[_currentPage]['field']] = answer;
    
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      // Save to Firebase and navigate to home
      _saveUserProfile();
    }
  }

  Future<void> _saveUserProfile() async {
    // TODO: Implement Firebase save
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            return QuestionPage(
              question: _questions[index],
              onAnswer: _nextQuestion,
            );
          },
        ),
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;

  const QuestionPage({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question['question'],
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    switch (question['type']) {
      case 'number':
        return NumberInput(
          unit: question['unit'],
          onSubmit: onAnswer,
        );
      case 'choice':
        return ChoiceInput(
          options: question['options'],
          onSelect: onAnswer,
        );
      case 'text':
        return TextInput(
          hint: question['hint'],
          onSubmit: onAnswer,
        );
      default:
        return const SizedBox();
    }
  }
}

// Input Widgets
class NumberInput extends StatelessWidget {
  final String unit;
  final Function(String) onSubmit;

  const NumberInput({
    super.key,
    required this.unit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffix: Text(unit),
        border: const OutlineInputBorder(),
      ),
      onSubmitted: onSubmit,
    );
  }
}

class ChoiceInput extends StatelessWidget {
  final List<String> options;
  final Function(String) onSelect;

  const ChoiceInput({
    super.key,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () => onSelect(option),
                child: Text(option),
              ),
            ),
          )
          .toList(),
    );
  }
}

class TextInput extends StatelessWidget {
  final String hint;
  final Function(String) onSubmit;

  const TextInput({
    super.key,
    required this.hint,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onSubmitted: onSubmit,
    );
  }
}