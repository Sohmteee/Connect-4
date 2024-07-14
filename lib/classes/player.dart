import 'dart:convert';

import 'package:connect4/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Player {
  int number;
  String? name;
  int? avatar;
  String id;
  int score = 0;
  int? timeLeft;

  String boardToString() => gameBoard.map((row) => row.join()).join();

  void clearScore() => score = 0;

  Future<List<int>?> getHints() async {
    try {
      var response = await http.post(
          Uri.https('kevinalbs.com', 'connect4/back-end/index.php/getMoves'),
          body: {
            'board_data': boardToString(),
            'player': number.toString(),
          });

      Map<String, dynamic> hints = jsonDecode(response.body);
      debugPrint('Response body: $hints');

      // iterate through the map and find the largest value
      int max = hints['0'];
      List<int> hintIndexes = [];

      for (int move in hints.values) {
        if (move > max) {
          max = move;
          hintIndexes = [int.parse(hints.keys.first)];
        } else if (move == max) {
          hintIndexes.add(int.parse(hints.keys.first));
        }
      }

      hintIndexes = hints.entries
          .where((element) {
            int intValue = int.tryParse(element.value.toString()) ?? 0;
            return intValue == max;
          })
          .map((element) => int.parse(element.key))
          .toList();

      debugPrint('Hint Indexes: $hintIndexes');
      return hintIndexes;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Player(
      {required this.name,
      required this.number,
      required this.avatar,
      required this.id,
      this.score = 0,
      this.timeLeft});

  toMap() {
    return {
      'number': number,
      'name': name,
      'avatar': avatar,
      'id': id,
      'score': score,
      'timeLeft': timeLeft,
    };
  }
}
