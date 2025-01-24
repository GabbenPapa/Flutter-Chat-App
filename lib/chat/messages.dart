import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docsDocs = streamSnapshot.data?.docs;

            if (!snapshot.hasData) {
              return const Center(child: Text('No user logged in'));
            }
            return ListView.builder(
              reverse: true,
              itemCount: docsDocs!.length,
              itemBuilder: (ctx, index) => MessageBubble(
                docsDocs[index]['text'],
                docsDocs[index]['username'],
                docsDocs[index]['userImage'],
                docsDocs[index]['userId'] == snapshot.data!.uid,
                key: ValueKey(docsDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
