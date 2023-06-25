import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(ChatMessage chatMessage) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatMessage.roomId)
        .collection('messages')
        .add(chatMessage.toMap());
  }

  Future<List<ChatMessage>> getMessages(String roomId) async {
    final querySnapshot = await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timeSent', descending: true)
        .get();

    List<ChatMessage> chatMessages = [];

    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data();
      try{
        String t = data['timeSent'];
        DateTime time =DateTime.parse(t);
        
        ChatMessage chatMessage = ChatMessage(
          senderName: data['senderName'],
          messageContent: data['messageContent'],
          timeSent: Timestamp.fromDate(time),
          roomId: data['roomId'],
          photoURL: data['photoURL'],
        );
        chatMessages.add(chatMessage);
        
      } catch (e) {
        ChatMessage chatMessage = ChatMessage(
          senderName: data['senderName'],
          messageContent: data['messageContent'],
          timeSent: data['timeSent'],
          roomId: data['roomId'],
          photoURL: data['photoURL'],
        );
        chatMessages.add(chatMessage);
      }
      
    }

    return chatMessages;
  }
}
