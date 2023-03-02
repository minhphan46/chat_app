import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  // check this message is mine ?
  final bool isMe;
  final Key? key;
  final String username;

  MessageBubble(this.message, this.username, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: !isMe
                    ? EdgeInsets.only(left: 15)
                    : EdgeInsets.only(right: 15),
                child: Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey[300]
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.only(
                    left: 8, right: 8, top: 3, bottom: 10),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.titleMedium!.color,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
