import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twiliotest/identity.dart';

import 'access_tokn.dart';

class TwilioChatService{

  late TwilioChatConversation twilioChat;



  Future<bool> initTwilio() async {
    try {
      twilioChat = TwilioChatConversation();
      // Use the Twilio helper libraries in your back end web services to create access tokens for both Android and iOS platform. However you can use this method to generate access token for Android.
      // final token = AccessToken().generateAccessToken(identity: 'user_1');
      final token = await twilioChat.generateToken(accountSid: 'accountSid', apiKey: 'apiKey', apiSecret: 'apiSecret', identity: identity, serviceSid: 'serviceSid');
      print("access token : $token");
      final result = await twilioChat.initializeConversationClient(accessToken: token ?? '');
      print("in initTwilio");
      print("twilio initialization result ${result}");
      if(result?.toLowerCase() == 'authentication failed'){
        return false;
      }
      else{
        return true;
      }
    } on Exception catch (e) {
      print("twilio initialization error : $e");
      return false;
    }
  }

  Future<String> createConversation(String conversationName,String identity)async{
    print('in create conversation');
    final String? result = await twilioChat.createConversation(conversationName:conversationName, identity: identity);
    print("create conversation result ${result}");
    return result ?? '';
  }

  Future<void> joinConversation(String conversationId)async{
    final String? result = await twilioChat.joinConversation(conversationId: conversationId);
    print("join conversation result ${result}");
  }

  Future<List<dynamic>> getConversationList()async{
    final result = await twilioChat.getConversations() ?? [];
    print("get conversation result ${result}");
    return result;
  }

  Future<void> subscribeToConversation(String conversationId)async{
    // final result = await twilioChat.receiveMessages(conversationId: conversationId);
    twilioChat.subscribeToMessageUpdate(conversationSid: conversationId);
    // print("receive message result ${result}");
    twilioChat.onMessageReceived.listen((val){
      print("message received : ${val}");
    });
    // print("receive message result ${result}");
  }

  Future<List<dynamic>> getMessages(String conversationId)async{
    final result = await twilioChat.getMessages(conversationId: conversationId) ?? [];
    print("get message result ${result}");
    return result;
  }

  Future<void> sendMessage(String message,conversationId)async{
    final result = await twilioChat.sendMessage(message:message,conversationId:conversationId);
    print("send message result ${result}");
  }
  Future<void> addParticipant(String conversationId)async{
    print("in add participant");
    try {
      final String? result = await twilioChat.addParticipant(participantName:identity,conversationId:conversationId);
      print("send message result ${result}");
    } on Exception catch (e) {
      print("Add participant exception : $e");
    }
  }

}