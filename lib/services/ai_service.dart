import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class AIService {
  static Future<Quote?> fetchCaption() async {
    try {
      // Simulate AI thinking delay
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.get(Uri.parse('https://dummyjson.com/quotes'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final quotes = data['quotes'] as List;

        // Pick a random quote
        final randomQuote = quotes[Random().nextInt(quotes.length)];

        // Convert to Quote model
        return Quote.fromJson(randomQuote);
      } else {
        debugPrint("Failed to fetch caption: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching caption: $e");
      return null;
    }
  }
}
