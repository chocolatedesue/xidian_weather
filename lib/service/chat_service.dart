import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/model/message.dart';

class ChatService {
  // final List<Message> _messages = [];
  // final _textController = TextEditingController();
  late final GenerativeModel _model;
  ChatService(String apiKey) {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }


  // final _model = GenerativeModel(
      // model: 'gemini-1.5-flash', apiKey: Platform.environment['API_KEY']!);

  Future<String> generateResponse(String input) async {
    final content = [Content.text(input)];

    // try 
    final response = await _model.generateContent(
      content,
    );
    return response.text == null ? 'No output' : response.text!;
  }
}
