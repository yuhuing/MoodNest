import 'dart:async';
import '../widgets/bottom_gap.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final AIService _aiService = AIService();

  // Consistent design with other screens
  static const Color _primaryBlue = Color(0xFF4A9FE8);
  static const Color _deepBlue = Color(0xFF2F7CC2);
  static const Color _teal = Color(0xFF3AA8CF);
  static const Color _lightSlate = Color(0xFF94A3B8);
  static const Color _background = Color(0xFFF5FAFF);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _primaryTextColor = Color(0xFF1E293B);
  static const double _spacing = 16.0;

  @override
  void initState() {
    super.initState();
    // Send initial greeting from the AI
    _addInitialBotMessage();
  }

  Future<void> _addInitialBotMessage() async {
    setState(() {
      _isTyping = true;
    });
    final initialResponse = await _aiService.getResponse(
      "Hello, this is the user's first time opening the chat.",
    );
    _addBotMessage(initialResponse);
    setState(() {
      _isTyping = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _handleUserMessage(String message) async {
    if (message.trim().isEmpty) return;

    _addUserMessage(message);
    _textController.clear();

    setState(() {
      _isTyping = true;
    });

    final response = await _aiService.getResponse(message);
    _addBotMessage(response);

    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const BottomGap(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
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
                        'AI Support Companion',
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
                            Icons.psychology_rounded,
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
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.wifi_tethering_rounded,
                          color: AppColors.navy,
                          size: 20,
                        ),
                        onPressed: _testAPIConnection,
                        tooltip: 'Test API Connection',
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= _messages.length) {
                      return _buildTypingIndicator();
                    }
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  }, childCount: _messages.length + (_isTyping ? 1 : 0)),
                ),
              ],
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? _primaryBlue : _cardBackground,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : _primaryTextColor,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(
            20,
          ).copyWith(bottomLeft: Radius.zero),
        ),
        child: const SizedBox(
          width: 50,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TypingDot(),
              _TypingDot(delay: Duration(milliseconds: 200)),
              _TypingDot(delay: Duration(milliseconds: 400)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _cardBackground,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleUserMessage,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: _lightSlate.withOpacity(0.8)),
                    filled: true,
                    fillColor: _cardBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_primaryBlue, _teal]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryBlue.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => _handleUserMessage(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testAPIConnection() async {
    setState(() {
      _isTyping = true;
    });

    final result = await _aiService.testConnection();
    if (!mounted) return; // user left the screen while the test ran

    setState(() {
      _isTyping = false;
    });

    if (result.success) {
      _addBotMessage("✅ API Connection Test: SUCCESS! ${result.message}");
    } else {
      _addBotMessage("❌ API Connection Test: FAILED. ${result.message}");
    }
  }
}

class _TypingDot extends StatefulWidget {
  final Duration delay;
  const _TypingDot({this.delay = Duration.zero});

  @override
  __TypingDotState createState() => __TypingDotState();
}

class __TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
