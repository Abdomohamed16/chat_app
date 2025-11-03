import 'package:chatapp/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}
 
class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}

class ChatSent extends ChatState {}
