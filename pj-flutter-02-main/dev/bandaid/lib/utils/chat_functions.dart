import 'dart:convert';

import 'package:bandaid/model/message.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<Message>> getUserChatMessages(int user_id) async {
  var url =
      Uri.parse(getServerApiUrl(ChatRouterEndPoints.getAllMessage(user_id)));
  var httpHeader = {'Content-Type': 'application/json'};
  List<Message> myMessages = [];

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      var messages = jsonDecode(response.body)["data"];
      for (var message in messages) {
        Message dm = Message(
            timestamp: DateTime.parse(message["timestamp"]),
            content: message["content"],
            sender_id: message["sender_id"],
            receiver_id: message["receiver_id"]);
        myMessages.add(dm);
      }
      myMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return myMessages;
    }
    if (response.statusCode == 404) {
      return myMessages;
    } else {
      throw Exception("Unable to fetch messages");
    }
  } catch (e) {
    // Handle exceptions
    throw e;
  }
}

Future<List<Message>> getUserDms(int correspondant_id, int user_id) async {
  var url = Uri.parse(
      getServerApiUrl(ChatRouterEndPoints.getCurrentUserDms(correspondant_id)));
  var httpHeader = await buildHTTPHeader();
  List<Message> myMessages = [];

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      var messages = jsonDecode(response.body)["data"];
      for (var message in messages) {
        Message dm = Message(
            timestamp: DateTime.parse(message["timestamp"]),
            content: message["content"],
            sender_id: message["sender_id"],
            receiver_id: message["receiver_id"]);
        myMessages.add(dm);
      }
      myMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return myMessages;
    } else {
      throw Exception("Unable to fetch dms");
    }
  } catch (e) {
    throw e;
  }
}

Future<void> sendDm(String content, int sender_id, int receiver_id) async {
  var url = Uri.parse(getServerApiUrl(ChatRouterEndPoints.createMessage));
  var httpHeader = await buildHTTPHeader();

  try {
    Map<String, dynamic> message = {
      "sender_id": sender_id,
      "receiver_id": receiver_id,
      "content": content,
    };
    http.Response response =
        await http.post(url, headers: httpHeader, body: jsonEncode(message));
    if (response.statusCode == 201) {
      print("Message sucessfully sent!");
      return;
    } else {
      throw Exception("Unable to send message");
    }
  } catch (e) {
    // Handle exceptions
    throw e;
  }
}
