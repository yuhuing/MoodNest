import 'package:flutter/material.dart';
import 'widgets/bottom_gap.dart';
import 'package:flutter/services.dart';
import 'features/counseling_hotline.dart';
import 'features/chatbot.dart';
import 'features/education.dart';
import 'features/report.dart';
import 'features/diary.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const MoodNestApp());
}

class MoodNestApp extends StatelessWidget {
  const MoodNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodNest - Anti-Cyberbullying App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        // Pastel headers need dark status bar icons (clock, battery).
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _borderRadius = 20.0;
  static const double _cardSpacing = 14.0;
  static const double _contentPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        bottomNavigationBar: const BottomGap(color: AppColors.background),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.headerGradient,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _contentPadding,
        16,
        _contentPadding,
        8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MoodNest',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Your Safe Space',
                    style: TextStyle(color: AppColors.navySoft, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: const Text(
              'Support for cyberbullying & mental wellness',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 14,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Fits everything on one screen: the tiles stretch to fill whatever
  // height is left, so no scrolling is needed.
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _contentPadding,
        _contentPadding,
        _contentPadding,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmergencySection(),
          const SizedBox(height: 18),
          const Text(
            'Support Features',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tools to help you navigate difficult situations',
            style: TextStyle(fontSize: 13.5, color: AppColors.navySoft),
          ),
          const SizedBox(height: 14),
          Expanded(child: _buildFeatureGrid()),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: AppColors.pastelBlue, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.pastelBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: AppColors.primaryDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Counseling Hotline',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Immediate help when you need it most',
                  style: TextStyle(fontSize: 12, color: AppColors.navySoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CounselingHotlineWidget(),
                ),
              );
            },
            icon: const Icon(Icons.phone_rounded, size: 16),
            label: const Text(
              'Call',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      FeatureData(
        title: 'Chat',
        subtitle: 'AI counselor',
        icon: Icons.psychology_rounded,
        background: AppColors.pastelBlue,
        iconColor: AppColors.primaryDark,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotWidget()),
            ),
      ),
      FeatureData(
        title: 'Education',
        subtitle: 'Learn & grow',
        icon: Icons.school_rounded,
        background: AppColors.pastelAqua,
        iconColor: AppColors.aqua,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EducationWidget()),
            ),
      ),
      FeatureData(
        title: 'Report',
        subtitle: 'Safe reporting',
        icon: Icons.report_problem_rounded,
        background: AppColors.pastelSky,
        iconColor: AppColors.primary,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportWidget()),
            ),
      ),
      FeatureData(
        title: 'Diary',
        subtitle: 'Track mood',
        icon: Icons.auto_stories_rounded,
        background: AppColors.pastelPeri,
        iconColor: const Color(0xFF6F7FE0),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JournalWidget()),
            ),
      ),
    ];

    // Size the 2x2 tiles from the space available instead of a fixed square,
    // so all four always fit on screen.
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - _cardSpacing) / 2;
        final tileHeight = (constraints.maxHeight - _cardSpacing) / 2;
        final aspectRatio =
            tileHeight > 0 ? (tileWidth / tileHeight).clamp(0.6, 2.5) : 1.0;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _cardSpacing,
            mainAxisSpacing: _cardSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) => _buildFeatureCard(features[index]),
        );
      },
    );
  }

  Widget _buildFeatureCard(FeatureData feature) {
    return Material(
      color: feature.background,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: feature.onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          // FittedBox shrinks the content on very small screens instead of
          // overflowing the tile.
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      feature.icon,
                      color: feature.iconColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feature.title,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feature.subtitle,
                    style: const TextStyle(
                      color: AppColors.navySoft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });
}
