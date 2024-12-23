import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/data.dart';
import 'package:connect4/main.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'room.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  @override
  void initState() {
    super.initState();
    roomName = TextEditingController();
    roomKey = TextEditingController();
  }

  @override
  void dispose() {
    roomName.dispose();
    roomKey.dispose();
    super.dispose();
  }

  Future<void> addPlayerToRoom() async {
    var doc = privateRooms.doc(roomName.text);
    var docSnapshot = await doc.get();

    if (docSnapshot.exists) {
      var players = List.from(docSnapshot.data()!['players']);
      players.add({
        'name': 'Joined',
        'number': 2,
        'avatar': 13,
        'id': playerID.toString(),
        'score': 0,
        'timeLeft': null,
      });
      await doc.update({'players': players});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            Text(
              'Join Room',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            TextField(
              controller: roomName,
              style: TextStyle(
                color: Colors.grey[100],
              ),
              decoration: const InputDecoration(
                labelText: 'Room Name',
                border: OutlineInputBorder(),
              ),
              onTapOutside: (e) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              ],
              maxLength: 10,
              textInputAction: TextInputAction.next,
            ),
            const Spacer(),
            TextField(
              controller: roomKey,
              style: TextStyle(
                color: Colors.grey[100],
              ),
              decoration: const InputDecoration(
                labelText: 'Room Key',
                border: OutlineInputBorder(),
              ),
              onTapOutside: (e) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              maxLength: 6,
            ),
            const Spacer(flex: 4),
            GameButton(
              text: 'JOIN',
              onPressed: () async {
                playTap(context);

                if (roomName.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Room name is empty!',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      });
                } else if (roomKey.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Room key is empty!',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder(
                        future:
                            privateRooms.doc(roomName.text).get().then((doc) {
                          if (doc.exists &&
                              doc.data()!['key'] == roomKey.text) {
                            return true;
                          }
                          return false;
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color: backgroundColor!,
                                size: 50.sp,
                              ),
                            );
                          }

                          if (snapshot.data == true) {
                            addPlayerToRoom().then((_) {
                              Navigator.pushNamed(context, '/waiting-room');
                            });

                            return Dialog(
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
                                decoration: const BoxDecoration(),
                                child: Text(
                                  'Room found!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            return Dialog(
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
                                decoration: const BoxDecoration(),
                                child: Text(
                                  'Room does not exist!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
