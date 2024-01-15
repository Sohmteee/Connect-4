import 'dart:convert';

import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/data.dart';
import 'package:http/http.dart' as http;

class ComputerPlayer extends Player {
  Position? lastPlayedPosition;
  int humanPlayerNumber;
  ComputerPlayer(super.number, {required this.humanPlayerNumber});

  String boardToString() => gameBoard.map((row) => row.join()).join();

  Future<int> play() async {
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https('kevinalbs.com',
            'connect4/back-end/index.php/getMoves?board_data=${boardToString()}&player=2'),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }
    return 0;
  }
}
