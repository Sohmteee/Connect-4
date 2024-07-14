// ignore_for_file: use_build_context_synchronously

import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/main.dart';
import 'package:connect4/screens/rooms/room.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  @override
  void initState() {
    super.initState();
    roomKey = TextEditingController();
    roomName = TextEditingController();
  }

  @override
  void dispose() {
    roomName.dispose();
    roomKey.dispose();
    super.dispose();
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
              'Create Room',
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
              text: 'CREATE',
              onPressed: () async {
                playTap(context);

                Future<bool> roomsContains(String roomKey) async {
                  return room.doc(roomKey).get().then((doc) => doc.exists);
                }

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
                } else if (await roomsContains(roomName.text)) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Room already exists!',
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
                            future: room.doc(roomName.text).set({
                              'name': roomName.text,
                              'key': roomKey.text,
                              'players': 1,
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingAnimationWidget.inkDrop(
                                  color: backgroundColor!,
                                  size: 50.sp,
                                );
                              }
                              return Dialog(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.w, 20.h, 0.w, 20.h),
                                  decoration: const BoxDecoration(),
                                  child: Text(
                                    'Room created!',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            });
                      });

                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/waiting-room');
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
