import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/models/chat_model.dart';
import 'package:firebase_chat/models/message_model.dart';
import 'package:firebase_chat/models/user_data.dart';
import 'package:firebase_chat/models/user_model.dart';
import 'package:firebase_chat/services/storage_service.dart';
import 'package:firebase_chat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  Future<User> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return User.fromDoc(userDoc);
  }

  Future<List<User>> searchUsers(String currentUserId, String name) async {
    QuerySnapshot usersSnap = await usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .getDocuments();
    List<User> users = [];
    usersSnap.documents.forEach((doc) {
      User user = User.fromDoc(doc);
      if (user.id != currentUserId) {
        users.add(user);
      }
    });
    return users;
  }

  Future<bool> createChat(
    BuildContext context,
    String name,
    File file,
    List<String> users,
  ) async {
    String imageUrl = await Provider.of<StorageService>(context, listen: false)
        .uploadChatImage(null, file);

    List<String> memberIds = [];
    Map<String, dynamic> memberInfo = {};
    Map<String, dynamic> readStatus = {};
    for (String userId in users) {
      memberIds.add(userId);

      User user = await getUser(userId);
      Map<String, dynamic> userMap = {
        'name': user.name,
        'email': user.email,
        'token': user.token,
      };
      memberInfo[userId] = userMap;

      readStatus[userId] = false;
    }
    await chatsRef.add({
      'name': name,
      'imageUrl': imageUrl,
      'recentMessage': 'Chat created',
      'recentSender': '',
      'recentTimestamp': Timestamp.now(),
      'memberIds': memberIds,
      'memberInfo': memberInfo,
      'readStatus': readStatus,
    });
    return true;
  }

  void sendChatMessage(Chat chat, Message message) {
    chatsRef.document(chat.id).collection('messages').add({
      'senderId': message.senderId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': message.timestamp,
    });
  }

  void setChatRead(BuildContext context, Chat chat, bool read) async {
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    chatsRef.document(chat.id).updateData({
      'readStatus.$currentUserId': read,
    });
  }
}
