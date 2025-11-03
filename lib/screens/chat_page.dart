import 'package:chatapp/cubit/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverName}"),
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatCubit.getMessages(widget.receiverId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == chatCubit.currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  decoration: const InputDecoration(
                    hintText: "Type message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (msgController.text.trim().isNotEmpty) {
                    chatCubit.sendMessage(widget.receiverId, msgController.text);
                    msgController.clear();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
