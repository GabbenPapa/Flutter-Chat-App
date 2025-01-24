import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';

  final _textController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    User? user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 1,
          color: Colors.grey[500],
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: const InputDecoration(
                    labelText: 'Send a message...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
              IconButton(
                color: Theme.of(context).colorScheme.primary,
                icon: const Icon(Icons.send),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
