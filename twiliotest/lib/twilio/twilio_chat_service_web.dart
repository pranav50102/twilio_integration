import 'dart:js_util' show promiseToFuture, callMethod, getProperty, allowInterop, jsify;
import 'dart:js' as js;

class TwilioChatServiceWeb{

  dynamic _client;

  Future<bool> initConversationClient() async{
    final token = '';
    final hasTwilio = js.context.hasProperty('Twilio');
    if (!hasTwilio) {
      print('Twilio SDK not loaded yet.');
      return false;
    }
    await promiseToFuture(callMethod(js.context['Twilio']['Conversations']['Client'], 'create', [token])).then((client){
      _client = client;
    });
    return true;
  //   js.context.callMethod('eval', ["""
  //   window.twilioClient = Twilio.Conversations.Client.create('${'accesstoken'}');
  //   window.twilioClient.then(client => {
  //     window.twilioConversationsClient = client;
  //     console.log("Twilio client initialized.");
  //   }).catch(error => {
  //     console.error("Twilio client init error", error);
  //   });
  // """]);
  }

  Future<String> createConversation(String name)async{
    if(_client == null){
      await initConversationClient();
    }
    final result = await promiseToFuture(callMethod(_client, 'createConversation', [
     jsify({'friendlyName': name})
    ]));
    print('Conversation created: ${getProperty(result, 'sid')}');
    return getProperty(result, 'sid') as String;
  }

  Future<dynamic> joinConversation(String conversationId) async {
    final conversation = await promiseToFuture(callMethod(
      _client,
      'getConversationBySid',
      [conversationId],
    ));

    final joinedConversation = await promiseToFuture(callMethod(
      conversation,
      'join',
      [],
    ));

    print('Joined conversation: ${joinedConversation['sid']}');
    return joinedConversation;
  }

  Future<void> sendMessage(dynamic conversation,String message) async{
    final result = callMethod(conversation, 'sendMessage', [message]);
    print('message sent : $result');
  }

  Future<void> subscribeAndSetListener(dynamic conversation)async{
    callMethod(conversation, 'on', [
      'messageAdded',
      allowInterop((message) {
        final author = getProperty(message, 'author');
        final body = getProperty(message, 'body');
        print('New message from $author: $body');

        // You can also call a Dart method here
        handleIncomingMessage(author, body);
      })
    ]);
  }

  void handleIncomingMessage(dynamic author,dynamic body){
    print('Message received : ${body}');
  }

  Future<void> addParticipant(dynamic conversation, String identity) async {
    await promiseToFuture(callMethod(conversation, 'add', [identity]));
    print('Added participant: $identity');
  }


}