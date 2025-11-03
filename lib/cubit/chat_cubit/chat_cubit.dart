import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/message_model.dart';
import 'chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  Stream<List<MessageModel>> getMessages(String receiverId) {
    final uid = currentUserId;

    return _firestore
        .collection("messages")
        .where("senderId", isEqualTo: uid)
        .where("receiverId", isEqualTo: receiverId)
        .snapshots()
        .asyncMap((event) async {
      final sentMessages =
          event.docs.map((e) => MessageModel.fromMap(e.data())).toList();

      final receivedSnapshot = await _firestore
          .collection("messages")
          .where("senderId", isEqualTo: receiverId)
          .where("receiverId", isEqualTo: uid)
          .get();

      final receivedMessages =
          receivedSnapshot.docs.map((e) => MessageModel.fromMap(e.data())).toList();

      final all = [...sentMessages, ...receivedMessages];
      all.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      emit(ChatLoaded(all));
      return all;
    });
  }

  Future<void> sendMessage(String receiverId, String msg) async {
    try {
      final uid = currentUserId;

      final message = MessageModel(
        senderId: uid,
        receiverId: receiverId,
        message: msg,
        timestamp: DateTime.now(),
        isSeen: false,
      );

      await _firestore.collection("messages").add(message.toMap());
      emit(ChatSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
