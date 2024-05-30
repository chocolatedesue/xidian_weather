import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // 引入 flutter_markdown 包
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    // _loadMessages();
    _checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.onPrimary;
    return
        // theme: ThemeData(
        //   primarySwatch: Theme.of(context).colorScheme.onPrimary,
        // ),
        Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Column(
                  crossAxisAlignment: message.sender == '我'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: message.sender == '我' ? 16 : 50,
                        right: message.sender == '我' ? 50 : 16,
                        bottom: 4,
                      ),
                      child: Text(
                        message.sender == '我' ? '我' : '天气小助手',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: message.sender == '我'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: message.sender == '我'
                            ? const EdgeInsets.only(
                                left: 16, right: 24, top: 12, bottom: 12)
                            : const EdgeInsets.only(
                                left: 24, right: 16, top: 12, bottom: 12),
                        margin: EdgeInsets.only(
                          left: message.sender == '我' ? 50 : 16,
                          right: message.sender == '我' ? 16 : 50,
                          top: 4,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: message.sender == '我'
                              ? Colors.blue[200]
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: MarkdownBody(
                                data: message.content,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: message.sender == '我'
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSecondary,
                                  ),
                                  strong: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  listBullet:  const TextStyle(
                                    color: Colors.black54,
                                  )
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${message.timestamp.hour}:${message.timestamp.minute}',
                              style: TextStyle(
                                color: message.sender == '我'
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: '输入消息...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      final newMessage = Message(
        sender: '我',
        content: _textController.text,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(newMessage);
      });
      _textController.clear();
      _saveMessages();

      _autoReply();
    }
  }

  void _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages.map((message) => message.toJson()).toList();
    await prefs.setString('messages', jsonEncode(messagesJson));
  }

  void _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages');
    if (messagesJson != null) {
      final messagesList = jsonDecode(messagesJson) as List;
      setState(() {
        _messages =
            messagesList.map((message) => Message.fromJson(message)).toList();
      });
    }
  }

  void _autoReply() async {
    String rawString = '''
明天的西安天气如下：
- **27日（明天）**：预计有**小雨转阴**，最高气温**30℃**，最低气温**20℃**¹²。
- **出行建议**：
    - 雨雪期间能见度较低，道路湿滑，高海拔山区易出现积雪结冰，请注意防范。
    - 请携带雨具，穿着舒适的鞋子，以应对可能的雨水和湿滑路面。
    - 如果需要外出，请关注交通状况，避免高速公路和山区道路，以减少不必要的风险。
    - 注意保暖，根据天气情况选择合适的服装。
    - 如果您驾车出行，请保持谨慎驾驶，遵守交通规则。
    - 随时关注天气预警和交通信息，以便及时调整出行计划。
- 请注意保持安全，祝您出行愉快！🌧️🚗
''';
    await Future.delayed(const Duration(seconds: 1));

    final autoReplyMessage = Message(
      sender: '自动回复',
      content: rawString,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(autoReplyMessage);
    });
    _saveMessages();
  }

  void _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    // final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final isFirstTime = true;
    if (isFirstTime) {
      final helloMessage = Message(
        sender: '自动回复',
        content: '你好！我是天气小助手，有什么可以帮助你的吗？',
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(helloMessage);
      });
      _saveMessages();
      await prefs.setBool('isFirstTime', false);
    }
  }
}