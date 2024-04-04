import 'dart:math';

import 'package:bandaid/model/message.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/profile_page.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:bandaid/utils/chat_functions.dart';
import 'package:bandaid/utils/user_functions.dart';
import 'package:bandaid/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class DMPage extends StatefulWidget {
  final User receiver;
  final User sender;

  DMPage({required this.receiver, required this.sender});
  @override
  _DMPageState createState() =>
      _DMPageState(receiver: receiver, sender: sender);
}

class _DMPageState extends State<DMPage> {
  List<Message> messages = [];

  TextEditingController _messageController = TextEditingController();

  final User receiver;
  final User sender;
  final receiverColor = const Color.fromARGB(204, 238, 238, 238);
  final senderColor = Colors.purple[400];
  final receiverTextColor = Colors.black;
  final senderTextColor = Colors.white;
  bool loading = true;

  IO.Socket? _socket;

  void initState() {
    super.initState();
    _connectSocket();
    _fetchMessages();
    loading = false;
  }

  void _connectSocket() async {
    var token = await readAuthToken();
    // Connect to the Socket.IO server
    _socket = IO.io(
        serverBaseUrl,
        IO.OptionBuilder()
            .setAuth({
              'Authorization': token,
            })
            .setPath('/ws/sockets.io')
            .setTransports(['websocket'])
            .build());
    _socket?.connect();

    _socket?.onConnect((data) => print('Socket.IO connection established'));
    _socket?.onConnectError((data) => print('Connect Error: $data'));
    _socket?.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket?.on(
      'private_dm',
      (data) => {
        setState(() {
          print('Message received: $data');
          messages.insert(
              0,
              Message(
                  timestamp: DateTime.now(),
                  content: data["content"],
                  sender_id: receiver.id,
                  receiver_id: sender.id));
        })
      },
    );
  }

  void _fetchMessages() async {
    var sender = await getCurrentUserDetails(context);
    var fetchedDms = await getUserDms(receiver.id, sender.id);

    setState(() {
      messages = fetchedDms;
    });
  }

  void _sendMessage(content) async {
    var token = await readAuthToken();
    var data = {
      "content": content,
      "receiver_id": receiver.id,
      "auth_token": token,
    };
    _socket?.emit('private_dm', data);
    setState(() {
      messages.insert(
          0,
          Message(
              timestamp: DateTime.now(),
              content: data["content"],
              sender_id: sender.id,
              receiver_id: receiver.id));
    });
  }

  _DMPageState({required this.receiver, required this.sender});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[400],
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => {
                    Navigator.pop(Get.context!),
                    _socket?.disconnect(),
                    _socket?.dispose()
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(Get.context!).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(user_id: receiver.id))),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(receiver.getImageStatic()),
                    maxRadius: 20.sp,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        receiver.getName().substring(0, min(receiver.getName().length, 20)),
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
           Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      messages[index].selected = !messages[index].selected;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15.sp,
                      right: 15.sp,
                      top: 10.sp,
                      bottom: 8.sp,
                    ),
                    child: Align(
                      alignment: (messages[index].sender_id == receiver.id
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[index].sender_id == receiver.id
                                  ? receiverColor
                                  : senderColor),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              messages[index].content,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: messages[index].sender_id == receiver.id
                                    ? receiverTextColor
                                    : senderTextColor,
                              ),
                            ),
                          ),
                          if (messages[index].selected) SizedBox(height: 8.sp),
                          if (messages[index].selected)
                            Text(
                              DateFormat('jm')
                                  .format(messages[index].timestamp)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color.fromARGB(181, 126, 124, 124),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.sp),
            height: 10.h,
            child: Row(
              children: [
                SizedBox(width: 15.sp),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  height: 5.25.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    onPressed: () {
                      _sendMessage(_messageController.text);
                      _messageController.clear();
                    },
                    child: Icon(
                      CupertinoIcons.arrow_up,
                      color: Colors.white,
                      size: 3.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
