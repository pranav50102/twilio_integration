import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';

class TwilioWebInterop {

  final TwilioChatConversation _twilioChat = TwilioChatConversation();

  Future<String> initialize(String token) async {
    final result = await _twilioChat.initializeConversationClient(accessToken: token);
    print("twilio init result : $result");
    return "initialized";
  }

  Future<List<dynamic>> getSubscribedConversations() async {
    final conversations = await _twilioChat.getConversations();
    return conversations?.map((c) => c.toJson()).toList() ?? [];
  }

  Future<Map<String, dynamic>> getConversationBySid(String sid) async {
    // final conversation = await _twilioChat.getConversation(sid);
    // return conversation?.toJson() ?? {};
    return {};
  }

  Future<void> sendMessage(String sid, String message) async {
    await _twilioChat.sendMessage(message: message, conversationId: sid);
  }

  Future<void> joinConversation(String sid) async {
    await _twilioChat.joinConversation(conversationId: sid);
  }

  Future<void> leaveConversation(String sid) async {
    // await _twilioChat.leaveConversation(sid);
  }

  Future<List<dynamic>> getMessages(String sid, [int limit = 50]) async {
    final messages = await _twilioChat.getMessages(conversationId: sid,messageCount: limit);
    return messages?.map((m) => m.toJson()).toList() ?? [];
  }

  void registerMessageListener(Function(Map<String, dynamic>) onMessage) {
    _twilioChat.onMessageReceived.listen((message) {
      onMessage(message as Map<String,dynamic>);
    });
  }

  Future<Map<String, dynamic>> createConversation({
    String? uniqueName,
    String? friendlyName,
    bool isPrivate = false,
  }) async {
    final conversation = await _twilioChat.createConversation(
        conversationName: uniqueName ?? '',
      identity: friendlyName ?? '',
    );

    return {
      'sid': conversation,
    };
  }


  Future<Map<String, dynamic>> addParticipant(String conversationSid, String identity) async {
    final participant = await _twilioChat.addParticipant(participantName: identity, conversationId: conversationSid);

    return {
      'sid': participant,
    };
  }

  void subscribeToConversation(String conversationSid) async {
     _twilioChat.subscribeToMessageUpdate(conversationSid: conversationSid);
  }

  Future<String> generateToken(String accountSid,String apiKey,String apiSecret,String identity,String serviceSid) async {
    final token = await _twilioChat.generateToken(accountSid: accountSid, apiKey: apiKey, apiSecret: apiSecret, identity: identity, serviceSid: serviceSid);
    return token ?? '';
  }

  // This method is specific to web, not needed for mobile.
  // You can leave it empty or remove it from interface if not shared.
  Map<String, dynamic> jsToMap(dynamic jsObject) {
    return {};
  }
}
