import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/models/chat_model.dart';
import 'package:firebase_chat/models/message_model.dart';
import 'package:firebase_chat/models/user_data.dart';
import 'package:firebase_chat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Chat chat;
  final Message message;

  const MessageBubble(this.chat, this.message);

  _buildText(bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 12.0,
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );
  }

  _buildImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(message.imageUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.senderId ==
        Provider.of<UserData>(context, listen: false).currentUserId;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: isMe
                    ? const EdgeInsets.only(right: 12.0)
                    : const EdgeInsets.only(left: 12.0),
                child: Text(
                  isMe
                      ? '${timeFormat.format(message.timestamp.toDate())}'
                      : '${chat.memberInfo[message.senderId]['name']} • ${timeFormat.format(message.timestamp.toDate())}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                decoration: BoxDecoration(
                  color: message.imageUrl == null
                      ? isMe ? Colors.lightBlue : Colors.green[400]
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: message.imageUrl == null
                    ? _buildText(isMe)
                    : _buildImage(context),
              )
            ],
          ),
        ],
      ),
    );
  }
}
