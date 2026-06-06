import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _apiKey = '';

  final List<String> _suggestions = [
    'Do I need a visa from India to Dubai? 🇦🇪',
    'What to do during 5hr layover at DXB? ✈️',
    'Best currency to carry to Singapore? 💰',
    'Is laptop safe in checked baggage? 💻',
    'Tips for long layovers? 😴',
    'Best airport lounges at LHR? 🛋️',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'assistant',
      'text':
          'Hi! I\'m your AI Travel Assistant ✈️\n\nI can help you with:\n• Visa requirements\n• Layover tips\n• Airport information\n• Currency advice\n• Travel hacks\n\nWhat would you like to know?',
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messageController.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();
    try {
      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$_apiKey';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'You are a helpful travel assistant for the Layover Friends app. Help travelers with visa requirements, airport tips, layover activities, currency advice, and travel hacks. Keep responses concise and friendly. User question: $text',
                },
              ],
            },
          ],
        }),
      );
      final data = json.decode(response.body);
      final reply = data['candidates'] != null
          ? data['candidates'][0]['content']['parts'][0]['text']
          : data.toString();
      setState(() {
        _messages.add({'role': 'assistant', 'text': reply});
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'text': 'Error: $e'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🤖', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text('AI Travel Assistant'),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF00BFA5),
                            child: Text('🤖', style: TextStyle(fontSize: 14)),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 40,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF00BFA5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF00BFA5),
                          child: Text('🤖', style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF00BFA5)
                                : const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 16),
                            ),
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_messages.length == 1)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(_suggestions[index]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00BFA5).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _suggestions[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about travel...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF00BFA5),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black, size: 18),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
