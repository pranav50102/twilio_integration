import 'package:flutter/foundation.dart' as kWeb; // for kIsWeb
import 'package:twiliotest/identity.dart';
import 'package:twiliotest/twilio/twilio_interop.dart';

class TwilioChatService {
  final TwilioWebInterop _twilio = TwilioWebInterop();

  Future<void> initialize() async {
    print('Token: $accessToken');
    final result = await _twilio.initialize(accessToken);
    print('Initialized: $result');
  }

  Future<void> createConversation({
    String? uniqueName,
    String? friendlyName,
    bool isPrivate = false,
  }) async {
    final result = await _twilio.createConversation(
      uniqueName: conversation,
      friendlyName: conversation,
      isPrivate: isPrivate,
    );
    print('Created conversation: $result');
  }

  Future<void> addParticipant(String conversationSid, String identity) async {
    final result = await _twilio.addParticipant(conversationSid, identity);
    print('Added participant: $result');
  }

  Future<void> joinConversation(String sid) async {
    await _twilio.joinConversation(sid);
    print('Joined conversation: $sid');
  }

  Future<void> leaveConversation(String sid) async {
    await _twilio.leaveConversation(sid);
    print('Left conversation: $sid');
  }

  Future<void> sendMessage(String sid, String message) async {
    await _twilio.sendMessage(sid, message);
    print('Sent message: "$message" to conversation: $sid');
  }

  Future<void> getMessages(String sid, {int limit = 50}) async {
    final messages = await _twilio.getMessages(sid, limit);
    print('Messages: $messages');
  }

  Future<void> getSubscribedConversations() async {
    final conversations = await _twilio.getSubscribedConversations();
    print('Subscribed conversations: $conversations');
  }

  Future<void> getConversationBySid(String sid) async {
    final conversation = await _twilio.getConversationBySid(sid);
    print('Conversation by SID: $conversation');
  }

  Future<void> subscribeToConversation(String conversationSid) async {
    _twilio.subscribeToConversation(conversationSid);
    print('Subscribed to conversation updates for: $conversationSid');
  }

  void registerMessageListener() {
    _twilio.registerMessageListener((message) {
      print('Message received: $message');
    });
    print('Message listener registered.');
  }
}

