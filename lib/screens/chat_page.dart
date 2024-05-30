import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // 引入 flutter_markdown 包
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/cur_weatherInfo.dart';
import 'dart:convert';

import 'package:xidian_weather/model/message.dart';
// import 'package:xidian_weather/service/chat_service.dart';
import 'package:xidian_weather/service/dashscopeService.dart';
import 'package:xidian_weather/util/icon_map.dart';

class ChatPage extends StatefulWidget {
  final CurWeatherInfo weatherInfo;
  final AirInfo airInfo;
  const ChatPage({
    super.key,
    required this.weatherInfo,
    required this.airInfo,
  });

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

  _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('firstTime');
    if (firstTime == null || firstTime == true) {
      final welcomeMessage = Message(
        sender: '天气小助手',
        content: '你好，我是天气小助手，有什么可以帮助你的吗？',
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(welcomeMessage);
      });
      // prefs.setBool('firstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                    ),
                                    strong: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    listBullet: const TextStyle(
                                      color: Colors.black54,
                                    )),
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
      // _saveMessages();

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
    String prompt = '';
    for (Message message in _messages) {
      prompt += message.sender + '：' + message.content + '\n';
    }

    // if prompt length is too long, prompt user to clear the chat history
    if (prompt.length > 3000) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Chat history is too long, please clear it.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // final String rawString =
      //     await GetIt.instance<ChatService>().generateResponse(prompt);

      final rawString = await GetIt.instance<DashscopeAPI>()
          .sendMessage(prompt, widget.weatherInfo, widget.airInfo);

      // 如果在debug 模式，打印一下返回的内容
      if (kDebugMode) {
        print('rawString: $rawString');
      }

      await Future.delayed(const Duration(seconds: 1));

      final autoReplyMessage = Message(
        sender: '自动回复',
        content: rawString,
        timestamp: DateTime.now(),
      );
      if (mounted) {
        setState(() {
          _messages.add(autoReplyMessage);
        });
      }
      _saveMessages();
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to generate response: $e'),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
