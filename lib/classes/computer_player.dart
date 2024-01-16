import 'dart:convert';
import 'dart:math';

import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/data.dart';
import 'package:http/http.dart' as http;

class ComputerPlayer extends Player {
  Position? lastPlayedPosition;
  int humanPlayerNumber;
  ComputerPlayer(super.number, {required this.humanPlayerNumber});

  Future<int> play() async {
    try {
      var response = await http.post(
          Uri.https('kevinalbs.com', 'connect4/back-end/index.php/getMoves'),
          body: {
            'board_data': boardToString(),
            'player': number.toString(),
          });

      Map<String, dynamic> moves = jsonDecode(response.body);
      print('Response body: $moves');

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

      print('Max Index: $maxIndexes($max)');
      return maxIndexes.length == 1
          ? maxIndexes[0]
          : maxIndexes[Random().nextInt(maxIndexes.length)];
    } catch (e) {
      print('Error: $e');
      int columnIndex = Random().nextInt(7);
      List column = List.generate(
        6,
        (rowIndex) => gameBoard[rowIndex][columnIndex],
      );

      while (column.every((disc) => disc != 0)) {
        columnIndex = Random().nextInt(7);
        column = List.generate(
          6,
          (rowIndex) => gameBoard[rowIndex][columnIndex],
        );
      }

      print('Played Randomly');
      return columnIndex;
    }
  }
}
