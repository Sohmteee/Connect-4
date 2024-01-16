import 'dart:convert';

import 'package:connect4/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Player {
  int number;
  String? name;
  int? score;

  String boardToString() => gameBoard.map((row) => row.join()).join();

  Future<List<int>> getHint() async {
    try {
      var response = await http.post(
          Uri.https('kevinalbs.com', 'connect4/back-end/index.php/getMoves'),
          body: {
            'board_data': boardToString(),
            'player': number.toString(),
          });

      Map<String, dynamic> moves = jsonDecode(response.body);
      debugPrint('Response body: $moves');

      // iterate through the map and find the largest value
      int max = 0;
      List<int> maxIndexes = [];

      max = moves.values.fold(0, (prev, element) {
        int intValue = int.tryParse(element.toString()) ?? 0;
        return intValue > prev ? intValue : prev;
      });

      maxIndexes = moves.entries
          .where((element) {
            int intValue = int.tryParse(element.value.toString()) ?? 0;
            return intValue == max;
          })
          .map((element) => int.parse(element.key))
          .toList();

      debugPrint('Max Index: $maxIndexes($max)');
      return maxIndexes;
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Player(this.number);
}
