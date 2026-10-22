import 'package:flutter/material.dart';
import '../widgets/bottom_gap.dart';
import '../theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalEntry {
  final DateTime date;
  final String text;
  final String emoji;
  final String mood;

  JournalEntry({
    required this.date,
    required this.text,
    required this.emoji,
    required this.mood,
  });
}

class JournalWidget extends StatefulWidget {
  const JournalWidget({super.key});

  @override
  State<JournalWidget> createState() => _JournalWidgetState();
}

class _JournalWidgetState extends State<JournalWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final Map<DateTime, JournalEntry> _entries = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedEmoji = '😊';
  String _selectedMood = 'Happy';
  late AnimationController _saveAnimationController;
  late Animation<double> _saveAnimation;

  // Design constants
  static const Color _primaryBlue = Color(0xFF4A9FE8);
  static const Color _deepBlue = Color(0xFF2F7CC2);
  static const Color _teal = Color(0xFF3AA8CF);
  static const Color _lightSlate = Color(0xFF94A3B8);
  static const Color _background = Color(0xFFF5FAFF);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _primaryTextColor = Color(0xFF1E293B);

  final Map<String, String> _moodEmojis = {
    'Happy': '😊',
    'Sad': '😢',
    'Anxious': '😰',
    'Angry': '😠',
    'Excited': '🤩',
    'Calm': '😌',
    'Stressed': '😓',
    'Confused': '😕',
    'Grateful': '🙏',
    'Lonely': '🥺',
  };

  final Map<String, Color> _moodColors = {
    'Happy': const Color(0xFF3AA8CF),
    'Sad': const Color(0xFF4A9FE8),
    'Anxious': const Color(0xFF3AA8CF),
    'Angry': const Color(0xFF2F7CC2),
    'Excited': const Color(0xFF6366F1),
    'Calm': const Color(0xFFCDEFF7),
    'Stressed': const Color(0xFF2F8FB8),
    'Confused': const Color(0xFF94A3B8),
    'Grateful': const Color(0xFF8B5CF6),
    'Lonely': const Color(0xFF475569),
  };

  final List<String> _moods = [
    'Happy',
    'Sad',
    'Anxious',
    'Angry',
    'Excited',
    'Calm',
    'Stressed',
    'Confused',
    'Grateful',
    'Lonely',
  ];

  @override
  void initState() {
    super.initState();
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _saveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _saveAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _addSampleEntries();
  }

  void _addSampleEntries() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    _entries[_normalizeDate(today)] = JournalEntry(
      date: today,
      text:
          "Today was a wonderful day! I felt so loved and supported by my friends. 💕",
      emoji: "😊",
      mood: "Happy",
    );

    _entries[_normalizeDate(yesterday)] = JournalEntry(
      date: yesterday,
      text:
          "Feeling a bit anxious about school tomorrow, but I'm trying to stay positive and remember that I'm stronger than I think! 🌟",
      emoji: "😰",
      mood: "Anxious",
    );

    _entries[_normalizeDate(twoDaysAgo)] = JournalEntry(
      date: twoDaysAgo,
      text:
          "Had a rough day. Someone was mean online, but I talked to my friend about it and felt much better. I'm grateful for good friends! 🤗",
      emoji: "😢",
      mood: "Sad",
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void dispose() {
    _textController.dispose();
    _saveAnimationController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🤗', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Don\'t forget to share how your day went!',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF3AA8CF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 8,
        ),
      );
      return;
    }

    setState(() {
      _entries[_normalizeDate(_selectedDay)] = JournalEntry(
        date: _selectedDay,
        text: _textController.text.trim(),
        emoji: _selectedEmoji,
        mood: _selectedMood,
      );
    });

    _saveAnimationController.forward().then((_) {
      _saveAnimationController.reset();
    });

    _textController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🎉', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Your precious memory has been saved! ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3AA8CF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  void _selectDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _textController.clear();

      final normalizedDay = _normalizeDate(selectedDay);
      if (_entries.containsKey(normalizedDay)) {
        final entry = _entries[normalizedDay]!;
        _textController.text = entry.text;
        _selectedEmoji = entry.emoji;
        _selectedMood = entry.mood;
      } else {
        _selectedEmoji = '😊';
        _selectedMood = 'Happy';
      }
    });
  }

  JournalEntry? _getEntryForDay(DateTime day) {
    return _entries[_normalizeDate(day)];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEntry = _entries[_normalizeDate(_selectedDay)];

    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const BottomGap(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.headerGradient,
                ),
              ),
              child: FlexibleSpaceBar(
                title: const Text(
                  'Mood Diary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.headerGradient,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_stories_rounded,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendar(selectedEntry),
                  const SizedBox(height: 24),
                  if (selectedEntry != null)
                    _buildEntryView(selectedEntry)
                  else
                    _buildEntryEditor(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(JournalEntry? selectedEntry) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _textController.text =
                _entries[_normalizeDate(selectedDay)]?.text ?? '';
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: _moodColors[_selectedMood]!.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: _moodColors[_selectedMood],
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: _primaryBlue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _primaryTextColor,
          ),
        ),
        eventLoader: (day) {
          final entry = _entries[_normalizeDate(day)];
          return entry != null ? [entry] : [];
        },
      ),
    );
  }

  Widget _buildEntryView(JournalEntry entry) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _moodColors[entry.mood]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _moodColors[entry.mood]!.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entry.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your memory from this day:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _moodColors[entry.mood]!,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_rounded, color: _moodColors[entry.mood]!),
                onPressed: () {
                  setState(() {
                    _textController.text = entry.text;
                    _selectedEmoji = entry.emoji;
                    _selectedMood = entry.mood;
                    _entries.remove(_normalizeDate(_selectedDay));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            entry.text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: _primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How was your day?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildMoodSelector(),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _textController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Share your thoughts and feelings here...',
              hintStyle: TextStyle(color: _lightSlate),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: _moodColors[_selectedMood],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Memory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your mood:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _moods.length,
            itemBuilder: (context, index) {
              final mood = _moods[index];
              final isSelected = _selectedMood == mood;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood;
                    _selectedEmoji = _moodEmojis[mood]!;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? _moodColors[mood] : _cardBackground,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color:
                          isSelected ? Colors.transparent : Colors.grey[300]!,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: _moodColors[mood]!.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _moodEmojis[mood]!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      if (isSelected)
                        Text(
                          mood,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
