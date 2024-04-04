import 'package:bandaid/model/message.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/dm.dart';
import 'package:bandaid/utils/chat_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessagingPage extends StatefulWidget {
  final user;
  final userlist;
  MessagingPage({required this.user, required this.userlist});
  @override
  _MessagingState createState() =>
      _MessagingState(user: user, userlist: userlist);
}

class _MessagingState extends State<MessagingPage> {
  final User user;
  List<User> userlist;
  List<String>? latest_Messages;
  List<String>? message_Days;
  bool loading = true;
  _MessagingState({required this.user, required this.userlist});

  @override
  void initState() {
    super.initState();
    _fetchChatLogs();
  }

  Future<void> _fetchChatLogs() async {
    List<Message> fetchedChatLogs = await getUserChatMessages(user.id);

    if (fetchedChatLogs.isEmpty) {
      setState(() {
        latest_Messages = List.filled(userlist.length, "Send me a Message!");
        message_Days = List.filled(userlist.length, "");
        loading = false;
      });
    }

    Map<String, Message> latestMessagesMap = {};

    for (Message message in fetchedChatLogs) {
      String otherUserId = (user.id == message.sender_id)
          ? message.receiver_id.toString()
          : message.sender_id.toString();

      if (!latestMessagesMap.containsKey(otherUserId) ||
          message.timestamp
              .isAfter(latestMessagesMap[otherUserId]!.timestamp)) {
        latestMessagesMap[otherUserId] = message;
      }
    }

    List<String> allUserIds =
        userlist.map((user) => user.id.toString()).toList();

    List<String> sortedUserIds = allUserIds
        .where((userId) => latestMessagesMap.containsKey(userId))
        .toList()
      ..sort((a, b) => latestMessagesMap[b]!
          .timestamp
          .compareTo(latestMessagesMap[a]!.timestamp));

    sortedUserIds
        .addAll(allUserIds.where((userId) => !sortedUserIds.contains(userId)));

    List<String> latestMessages = List.filled(
        userlist.length, "Send me a Message!",
        growable: true); // Default value
    List<String> messageDays =
        List.filled(userlist.length, "", growable: true); // Default value

    for (int i = 0; i < sortedUserIds.length; i++) {
      String userId = sortedUserIds[i];
      Message? latestMessage = latestMessagesMap[userId];

      if (latestMessage != null) {
        String dayDifference = _calculateDayDifference(latestMessage.timestamp);
        latestMessages[i] = latestMessage.content;
        messageDays[i] = dayDifference;
      }
    }

    setState(() {
      userlist.sort((a, b) => sortedUserIds
          .indexOf(a.id.toString())
          .compareTo(sortedUserIds.indexOf(b.id.toString())));
      latest_Messages = latestMessages;
      message_Days = messageDays;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? ListView.builder(
            padding: EdgeInsets.only(top: 16.sp),
            itemCount: userlist.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DMPage(
                            receiver: userlist[index],
                            sender: user,
                          ))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.sp, vertical: 15.sp),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userlist[index].getImageStatic()),
                          maxRadius: 20.sp,
                        ),
                        SizedBox(
                          width: 16.sp,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  userlist[index].getName(),
                                  style: TextStyle(fontSize: 17.sp),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  latest_Messages?[index] ??
                                      "Send me a Message!",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          message_Days?[index] ?? "",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ));
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

String _calculateDayDifference(DateTime messageTimestamp) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));

  if (messageTimestamp.isAfter(today)) {
    return 'Today';
  } else if (messageTimestamp.isAfter(yesterday)) {
    return 'Yesterday';
  } else {
    int dayDifference = today.difference(messageTimestamp).inDays;
    return '$dayDifference days ago';
  }
}
