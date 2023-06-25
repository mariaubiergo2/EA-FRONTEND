import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  ChatMessage(
    {required this.senderName,
    required this.messageContent,
    required this.timeSent,
    required this.roomId,
    required this.photoURL});

  final String messageContent;
  final String senderName;
  final Timestamp timeSent;
  final String roomId;
  final String photoURL;

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'messageContent': messageContent,
      'timeSent': timeSent,
      'roomId': roomId,
      'photoURL': photoURL,
    };
  }
}
