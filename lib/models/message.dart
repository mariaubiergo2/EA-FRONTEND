class ChatMessage {
  ChatMessage(
      {required this.senderName,
      required this.messageContent,
      required this.timeSent});

  final String messageContent;
  final String senderName;
  final String timeSent;
}
