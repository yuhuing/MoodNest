import 'package:flutter/material.dart';
import '../widgets/bottom_gap.dart';
import '../theme/app_colors.dart';
import 'bullying_info.dart';

class Question {
  final String text;
  final List<String> options;
  final String? explanation;

  Question({required this.text, required this.options, this.explanation});
}

class EducationWidget extends StatefulWidget {
  const EducationWidget({super.key});

  @override
  State<EducationWidget> createState() => _EducationWidgetState();
}

class _EducationWidgetState extends State<EducationWidget>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  bool _showResults = false;
  int _score = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Enhanced design constants with cold color theme
  static const double _borderRadius = 16.0;
  static const double _largeBorderRadius = 24.0;
  static const double _standardPadding = 24.0;
  static const double _itemSpacing = 20.0;
  static const double _smallSpacing = 12.0;
  static const double _largeSpacing = 32.0;

  // Cold color palette
  static const Color _primaryBlue = Color(0xFF4A9FE8);
  static const Color _deepBlue = Color(0xFF2F7CC2);
  static const Color _lightBlue = Color(0xFFBFE3FF);
  static const Color _teal = Color(0xFF3AA8CF);
  static const Color _lightTeal = Color(0xFFCDEFF7);
  static const Color _slate = Color(0xFF475569);
  static const Color _lightSlate = Color(0xFF94A3B8);
  static const Color _background = Color(0xFFF5FAFF);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _accent = Color(0xFF3AA8CF);

  final List<Question> _questions = [
    Question(
      text: "Was the message or behavior repeated over time?",
      options: ["Yes", "No", "I'm not sure"],
      explanation:
          "Cyberbullying often involves repeated behavior over time, not just a one-time incident.",
    ),
    Question(
      text: "Did the message make you feel scared, worthless, or powerless?",
      options: ["Yes", "No", "Sometimes"],
      explanation:
          "The emotional impact is a key indicator of bullying behavior.",
    ),
    Question(
      text: "Was the message sent with the intent to harm or embarrass you?",
      options: ["Yes", "No", "I'm not sure"],
      explanation: "Intent to harm is a defining characteristic of bullying.",
    ),
    Question(
      text: "Did the person have more power or influence than you?",
      options: ["Yes", "No", "Maybe"],
      explanation: "Power imbalance is often present in bullying situations.",
    ),
    Question(
      text: "Did the behavior happen in a public space where others could see?",
      options: ["Yes", "No", "Somewhat"],
      explanation: "Public humiliation is a common tactic in cyberbullying.",
    ),
    Question(
      text: "Have you asked the person to stop, but they continued?",
      options: ["Yes", "No", "I haven't asked them to stop"],
      explanation:
          "Ignoring requests to stop is a strong indicator of bullying.",
    ),
    Question(
      text: "Did the behavior affect your daily life or mental health?",
      options: ["Yes, significantly", "Somewhat", "No"],
      explanation: "The impact on your well-being is important to consider.",
    ),
    Question(
      text:
          "Were you targeted because of your identity, beliefs, or characteristics?",
      options: ["Yes", "No", "I'm not sure"],
      explanation:
          "Targeted harassment based on personal characteristics is a form of bullying.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _answerQuestion(int answerIndex) {
    setState(() {
      _answers.add(answerIndex);

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _animationController.reset();
        _animationController.forward();
      } else {
        _calculateResults();
        _showResults = true;
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  void _calculateResults() {
    _score = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == 0) {
        _score += 2;
      } else if (_answers[i] == 1) {
        _score += 0;
      } else {
        _score += 1;
      }
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = [];
      _showResults = false;
      _score = 0;
    });
    _animationController.reset();
    _animationController.forward();
  }

  String _getResultMessage() {
    final maxScore = _questions.length * 2;
    final percentage = (_score / maxScore) * 100;

    if (percentage >= 70) {
      return "This appears to be cyberbullying. You should seek help and support.";
    } else if (percentage >= 40) {
      return "This may be cyberbullying. Consider talking to someone you trust.";
    } else {
      return "This doesn't appear to be cyberbullying, but if you're concerned, talk to someone.";
    }
  }

  Color _getResultColor() {
    final maxScore = _questions.length * 2;
    final percentage = (_score / maxScore) * 100;

    if (percentage >= 70) {
      return const Color(0xFFEF4444);
    } else if (percentage >= 40) {
      return const Color(0xFFF59E0B);
    } else {
      return _teal;
    }
  }

  // Enhanced container builder with gradient and modern styling
  Widget _buildContainer({
    required Widget child,
    bool hasGradient = false,
    Color? backgroundColor,
    List<Color>? gradientColors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_standardPadding),
      decoration: BoxDecoration(
        gradient:
            hasGradient && gradientColors != null
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                )
                : null,
        color: backgroundColor ?? _cardBackground,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: _lightSlate.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: _lightSlate.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Glassmorphism effect container
  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_standardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const BottomGap(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _background,
              _lightBlue.withOpacity(0.1),
              _lightTeal.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar with gradient
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.headerGradient,
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: const Text(
                    'Education Hub',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: -0.5,
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.headerGradient,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: AppColors.navy.withOpacity(0.12),
                      ),
                    ),
                  ),
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.navy,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(_standardPadding),
                child: Column(
                  children: [
                    // Enhanced info card with modern design
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BullyingInfoPage(),
                              ),
                            );
                          },
                          child: _buildContainer(
                            hasGradient: true,
                            gradientColors: [
                              _primaryBlue.withOpacity(0.1),
                              _teal.withOpacity(0.1),
                            ],
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_primaryBlue, _teal],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _primaryBlue.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.psychology_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Understanding Bullying',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: _slate,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Learn the difference between normal online activity and cyberbullying.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _lightSlate,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _primaryBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: _primaryBlue,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: _largeSpacing),

                    // Question or Results section
                    _showResults ? _buildResults() : _buildQuestion(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Enhanced progress indicator
        _buildGlassContainer(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_primaryBlue, _teal]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${((_currentQuestionIndex + 1) / _questions.length * 100).round()}% Complete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _itemSpacing),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _lightBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_primaryBlue, _teal]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: _itemSpacing),

        // Enhanced question display
        _buildContainer(
          hasGradient: true,
          gradientColors: [_accent.withOpacity(0.05), _teal.withOpacity(0.05)],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_accent, _teal]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: _itemSpacing),
              Expanded(
                child: Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _slate,
                    height: 1.4,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: _itemSpacing),

        // Enhanced answer options
        ...List.generate(question.options.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: _smallSpacing),
            child: GestureDetector(
              onTap: () => _answerQuestion(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(_standardPadding),
                decoration: BoxDecoration(
                  color: _cardBackground,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(
                    color: _lightBlue.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryBlue.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _primaryBlue, width: 2),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _primaryBlue.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: _itemSpacing),
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _slate,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        // Enhanced results header
        _buildContainer(
          hasGradient: true,
          gradientColors: [
            _getResultColor().withOpacity(0.1),
            _getResultColor().withOpacity(0.05),
          ],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getResultColor(),
                      _getResultColor().withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getResultColor().withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: _itemSpacing),
              const Text(
                'Assessment Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _slate,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: _smallSpacing),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getResultColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getResultMessage(),
                  style: TextStyle(
                    fontSize: 16,
                    color: _getResultColor(),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: _itemSpacing),

        // Enhanced score breakdown
        _buildGlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_primaryBlue, _teal]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.list_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Your Responses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _slate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _itemSpacing),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final answer = _answers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: _smallSpacing),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryBlue.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _lightBlue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${question.text}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _slate,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Answer: ${question.options[answer]}',
                          style: TextStyle(
                            fontSize: 13,
                            color: _teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (question.explanation != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          question.explanation!,
                          style: TextStyle(
                            fontSize: 12,
                            color: _lightSlate,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: _itemSpacing),

        // Enhanced action buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _lightSlate.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Retake Quiz',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cardBackground,
                    foregroundColor: _slate,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: _itemSpacing),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_primaryBlue, _teal]),
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryBlue.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home_rounded, size: 20),
                  label: const Text(
                    'Go Home',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
