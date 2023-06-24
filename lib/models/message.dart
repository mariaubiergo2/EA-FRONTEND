class ChatMessage {
  ChatMessage(
      {required this.senderName,
      required this.messageContent,
      required this.timeSent,
      required this.roomId});

  final String messageContent;
  final String senderName;
  final String timeSent;
  final String roomId;

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'messageContent': messageContent,
      'timeSent': timeSent,
      'roomId': roomId,
    };
  }
}
