import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futuresnapshot) {
        if (futuresnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true) // sort by time create
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                //return Text(chatDocs[index]['text']);
                return MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userId'] == futuresnapshot.data!.uid
                      ? true
                      : false,
                  key: ValueKey(chatDocs[index].id), // late need to add
                );
              },
            );
          },
        );
      },
    );
  }
}
