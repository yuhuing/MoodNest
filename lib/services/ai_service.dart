import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_key.dart';

// Result of the API connection test: whether it worked, and why.
class ConnectionTestResult {
  final bool success;
  final String message;
  const ConnectionTestResult(this.success, this.message);
}

class AIService {
  // Kept in api_key.dart, which is not uploaded to GitHub.
  static const String _apiKey = geminiApiKey;

  // Tried in order. If one model is busy or unavailable, the next is used.
  static const List<String> _modelNames = [
    'gemini-flash-latest',
    'gemini-flash-lite-latest',
    'gemini-2.5-flash',
  ];

  late final List<GenerativeModel> _models;

  AIService() {
    print('AIService: Initializing');
    _models = [
      for (final name in _modelNames)
        GenerativeModel(model: name, apiKey: _apiKey),
    ];
    print('AIService: Model initialized successfully');
  }

  // True for errors that usually go away if we wait (server busy, rate limit).
  bool _isTemporaryError(Object e) {
    final msg = e.toString();
    return msg.contains('503') ||
        msg.contains('UNAVAILABLE') ||
        msg.contains('high demand') ||
        msg.contains('429') ||
        msg.contains('RESOURCE_EXHAUSTED') ||
        msg.contains('overloaded');
  }

  // True when this model can't be used at all, so we skip straight to the next.
  bool _isModelUnavailable(Object e) {
    final msg = e.toString();
    return msg.contains('not found') || msg.contains('not supported');
  }

  // Tries each model, retrying busy ones a couple of times with a short wait.
  Future<GenerateContentResponse> _generateWithFallback(
    List<Content> content,
  ) async {
    Object? lastError;
    for (var i = 0; i < _models.length; i++) {
      for (var attempt = 1; attempt <= 2; attempt++) {
        try {
          print('AIService: Trying ${_modelNames[i]} (attempt $attempt)');
          return await _models[i].generateContent(content);
        } catch (e) {
          lastError = e;
          print('AIService: ${_modelNames[i]} failed: $e');
          if (_isModelUnavailable(e)) break; // go to next model
          if (!_isTemporaryError(e)) rethrow; // e.g. bad API key
          if (attempt < 2) {
            await Future.delayed(Duration(seconds: 2 * attempt));
          }
        }
      }
    }
    throw lastError ?? Exception('No AI model available');
  }

  // Checks that the API key works and at least one model answers.
  // Any non-empty reply counts as success: the AI won't always repeat
  // an exact phrase, so matching specific words gives false failures.
  Future<ConnectionTestResult> testConnection() async {
    try {
      print('AIService: Testing API connection...');
      final response = await _generateWithFallback([
        Content.text('Reply with a short greeting.'),
      ]);
      final text = response.text?.trim() ?? '';
      print('AIService: API Response: $text');
      if (text.isEmpty) {
        return const ConnectionTestResult(
          false,
          'Connected, but the AI sent an empty reply. Please try again.',
        );
      }
      return const ConnectionTestResult(
        true,
        'The Gemini API is working correctly.',
      );
    } catch (e) {
      print('AIService: API Test Failed - $e');
      return ConnectionTestResult(false, _explainError(e));
    }
  }

  // Turns a raw API error into a short reason a person can act on.
  String _explainError(Object e) {
    final msg = e.toString();
    if (_isTemporaryError(e)) {
      return 'Gemini is busy right now (too many requests). '
          'Your setup is fine, so please try again in a minute.';
    }
    if (msg.contains('API key') ||
        msg.contains('API_KEY') ||
        msg.contains('PERMISSION_DENIED') ||
        msg.contains('403')) {
      return 'The API key was rejected. Create a new key at '
          'aistudio.google.com and put it in ai_service.dart.';
    }
    if (_isModelUnavailable(e)) {
      return 'None of the Gemini models are available for this key.';
    }
    if (msg.contains('SocketException') ||
        msg.contains('Failed host lookup') ||
        msg.contains('ClientException')) {
      return 'No internet connection. Check your Wi-Fi or mobile data.';
    }
    return 'Unexpected error: $msg';
  }

  Future<String> getResponse(String userInput) async {
    if (_apiKey.startsWith('YOUR_API_KEY')) {
      return "Hello! Please add your API key in lib/services/ai_service.dart to enable the AI chatbot.";
    }

    print(
      'AIService: Sending message to Gemini API: "${userInput.substring(0, userInput.length > 50 ? 50 : userInput.length)}..."',
    );

    try {
      // Create a system prompt
      final systemPrompt =
          '''You are a friendly and supportive mental health assistant for an app called MoodNest. Your purpose is to help users who are feeling down, anxious, or are victims of cyberbullying. Provide comfort, encouragement, and helpful, safe advice. Keep your responses concise, empathetic, and easy to understand. Do not provide medical advice. If the user mentions self-harm, immediately provide a hotline number and encourage them to call.

User message: $userInput''';

      print('AIService: Calling Gemini API...');
      final response = await _generateWithFallback([
        Content.text(systemPrompt),
      ]);
      final text = response.text;

      print('AIService: Received response from Gemini API');

      if (text == null) {
        print('AIService: Response was null');
        return 'I am not sure how to respond to that. Could you try rephrasing?';
      }

      print('AIService: Response length: ${text.length} characters');
      return text;
    } catch (e) {
      // You can add more sophisticated error handling here.
      print('AIService: Error getting response from AI: $e');
      if (_isTemporaryError(e)) {
        return "I'm getting a lot of messages right now and couldn't reply. "
            'Please wait a moment and try again. 💙';
      }
      return 'Sorry, something went wrong and I can\'t respond right now. '
          'Please try again later.';
    }
  }
}
