import 'dart:async';
import '../widgets/bottom_gap.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CounselingHotlineWidget extends StatefulWidget {
  const CounselingHotlineWidget({super.key});

  @override
  State<CounselingHotlineWidget> createState() =>
      _CounselingHotlineWidgetState();
}

class _CounselingHotlineWidgetState extends State<CounselingHotlineWidget> {
  // Color palette (match Education/Chatbot/Report/Journal)
  static const Color _primaryBlue = Color(0xFF4A9FE8);
  static const Color _deepBlue = Color(0xFF2F7CC2);
  static const Color _teal = Color(0xFF3AA8CF);
  static const Color _lightTeal = Color(0xFFCDEFF7);
  static const Color _background = Color(0xFFF5FAFF);
  static const Color _slate = Color(0xFF475569);
  static const double _borderRadius = 18.0;
  static const double _padding = 20.0;

  final List<Map<String, dynamic>> _hotlines = [
    {
      'name': 'Malaysian Mental Health Association (MMHA)',
      'number': '0327806803',
      'description':
          'Confidential emotional support for any mental health concerns.',
      'icon': Icons.self_improvement,
      'gradient': [Color(0xFF4A9FE8), Color(0xFF2F7CC2)],
    },
    {
      'name': 'MIASA Crisis Helpline',
      'number': '1800180066',
      'description': '24/7 immediate help for emotional and crisis support.',
      'icon': Icons.support_agent,
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'name': 'Talian HEAL (Help with Empathy And Love)',
      'number': '15555',
      'description': 'Trusted helpline for anxiety, stress, and depression.',
      'icon': Icons.escalator_warning,
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    },
  ];

  Future<void> _makeCall(String number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making call: $e'),
            backgroundColor: _slate,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const BottomGap(color: Color(0xFFCDEFF7)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _background,
              Color(0xFFBFE3FF), // light blue
              Color(0xFFCDEFF7), // light teal
            ],
          ),
        ),
        child: CustomScrollView(
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
                    'Counseling Hotline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: -0.5,
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
                        Icons.phone_in_talk,
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
                padding: const EdgeInsets.all(_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Get Immediate Support',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _slate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These hotlines provide free, confidential support from trained professionals. Help is just a call away.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ..._hotlines
                        .map((hotline) => _buildHotlineCard(hotline))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotlineCard(Map<String, dynamic> hotline) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: (hotline['gradient'] as List<Color>)[0].withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_borderRadius),
          onTap: () => _makeCall(hotline['number']),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: (hotline['gradient'] as List<Color>)[0].withOpacity(
                  0.18,
                ),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: hotline['gradient']),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (hotline['gradient'] as List<Color>)[0]
                            .withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(hotline['icon'], color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotline['name'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _slate,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hotline['description'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: hotline['gradient']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.call, color: Colors.white, size: 22),
                    onPressed: () => _makeCall(hotline['number']),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
