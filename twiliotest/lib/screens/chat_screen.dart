import 'package:flutter/material.dart';
import 'package:twiliotest/util/utils.dart';
import '../twilio/twilio_chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  late TwilioChatService twilioChatService;
  // late ChatServiceInterface twilioChatServiceWeb;
  List<dynamic>? messages;
  List<dynamic>? conversations;
  bool? isSuccess;
  String conversationId = 'conversationId';
  String platform = '';
  dynamic conversationObj;
  @override
  void initState() {
    platform = Utils().getPlatform().toLowerCase();
    // if(platform == 'android'){
    //   print('platform check');
    //    twilioChatService = TwilioChatService();
    //   initializeTwilioAndroid();
    // }
    // else if(platform =='web'){
    //   twilioChatServiceWeb  = WebInterface().getTWilioWeb();
    //   initializeTwilioWeb();
    // }
    print("in chat screen");
    super.initState();
  }

  // void initializeTwilioWeb() async{
  //   final isSuccess = await twilioChatServiceWeb.initConversationClient();
  //   await Future.delayed(Duration(seconds: 3));
  //   if(isSuccess){
  //     // await twilioChatServiceWeb.createConversation();
  //     await Future.delayed(Duration(seconds: 3));
  //     final conversation = await twilioChatServiceWeb.joinConversation(conversationId);
  //     await twilioChatServiceWeb.addParticipant(conversation,identity);
  //     await twilioChatServiceWeb.subscribeAndSetListener(conversation);
  //     conversationObj = conversation;
  //   }
  //
  // }

  void initializeTwilioAndroid() async{
     isSuccess = await twilioChatService.initTwilio();
    // messages = await twilioChatService.getMessages('1234');
    print('is Initialization success : $isSuccess');
    await setupConversation(isSuccess ?? false);
  }

  Future<void> createConversation()async{
    if(isSuccess == true){
      // await twilioChatService.createConversation('conversation_4','conversation_@4');
      conversations = await twilioChatService.getConversationList();
      print('conversation list : $conversations');
      // await twilioChatService.joinConversation();
      // await Future.delayed(Duration(seconds: 3));
      // await twilioChatService.addParticipant();
    }
  }
  Future<void> setupConversation(bool isSuccess)async{
    if(isSuccess){
      // conversationId = await twilioChatService.createConversation('conversation_6','conversation_@6');
      conversations = await twilioChatService.getConversationList();
      print('conversation list : $conversations');
      await twilioChatService.joinConversation(conversationId);
      await Future.delayed(Duration(seconds: 3));
      await twilioChatService.addParticipant(conversationId);
      await twilioChatService.subscribeToConversation(conversationId);
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              controller: messageController,
            ),
            ElevatedButton(
              onPressed: ()async{
                if(platform == 'web'){
                  // twilioChatServiceWeb.sendMessage(conversationObj, messageController.text);
                }
                else if(platform == 'android'){
                  await twilioChatService.sendMessage(
                      messageController.text, conversationId);
                }
                else{

                }
                // await twilioChatService.addParticipant();
              },
              child: Text('send'),
            ),
            ElevatedButton(
              onPressed: ()async{
                if(platform == 'android'){
                  await twilioChatService.getMessages(conversationId);
                }
              },
              child: Text('get messages'),
            ),
            ElevatedButton(
              onPressed: ()async{
                if(platform == 'android'){
                  final list = await twilioChatService.getConversationList();
                  print("conversation list : $list");
                }
              },
              child: Text('get conversations'),
            ),
            ElevatedButton(
              onPressed: ()async{
                if(platform == 'android'){
                  await createConversation();
                }
              },
              child: Text('create conversations'),
            ),
            ElevatedButton(
              onPressed: ()async{
                if(platform == 'android'){
                  await twilioChatService.subscribeToConversation(
                      conversationId);
                }
                else if(platform == 'web'){
                  // await twilioChatServiceWeb.subscribeAndSetListener(conversationObj);
                }
              },
              child: Text('receive messages conversations'),
            ),
          ],
        ),
      ),
    );
  }
}
