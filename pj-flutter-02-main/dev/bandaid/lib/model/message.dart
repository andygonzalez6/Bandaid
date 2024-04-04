class Message {
  final DateTime timestamp;
  final String content;
  final sender_id;
  final receiver_id;
  bool selected = false;

  Message({
    required this.timestamp,
    required this.content,
    required this.sender_id,
    required this.receiver_id,
  });

  void messagePrint() {
    print(
        "Sender: $sender_id, Reciever: $receiver_id, Content: $content, TimeStamp: $timestamp");
  }
}
