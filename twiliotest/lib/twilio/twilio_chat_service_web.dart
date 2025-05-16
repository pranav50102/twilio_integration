import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// JavaScript bindings for Twilio wrapper functions
@JS('initTwilio')
external JSPromise<JSString> initTwilio(String token);

@JS('getSubscribedConversations')
external JSPromise<JSArray> getSubscribedConversationsJs();

@JS('getConversationBySid')
external JSPromise<JSObject> getConversationBySidJs(String sid);

@JS('sendMessageToConversation')
external JSPromise<JSNumber> sendMessageToConversationJs(String sid, String message);

@JS('joinConversation')
external JSPromise<JSObject> joinConversationJs(String sid);

@JS('leaveConversation')
external JSPromise<JSObject> leaveConversationJs(String sid);

@JS('getMessages')
external JSPromise<JSArray> getMessagesJs(String sid, JSNumber limit);

@JS('registerMessageListener')
external void registerMessageListenerJs(JSFunction callback);

@JS('createConversation')
external JSPromise<JSObject> createConversationJs(JSObject? options);

@JS('addParticipant')
external JSPromise<JSObject> addParticipantJs(String conversationSid, String identity);

@JS('getObjectKeys')
external JSArray getObjectKeys(JSObject obj);

class TwilioWebInterop {
  /// Initialize the Twilio Conversations client with a JWT token
  Future<String> initialize(String token) async {
    try {
      print("token: $token");
      final jsResult = initTwilio(token);
      print("jsResult: $jsResult"); // Debug: Should print [object Promise]
      final result = await jsResult.toDart;
      print("Result: $result"); // Debug: Should print "success"
      return result.toString();
    } catch (e) {
      print("Error initializing Twilio: $e");
      rethrow;
    }
  }

  /// Get the list of subscribed conversations
  Future<List<dynamic>> getSubscribedConversations() async {
    try {
      final jsConversations = await getSubscribedConversationsJs().toDart;
      return jsObjectToDart(jsConversations);
    } catch (e) {
      print("Error getting subscribed conversations: $e");
      rethrow;
    }
  }

  /// Get messages from a conversation
  Future<List<dynamic>> getMessages(String sid, [int limit = 50]) async {
    try {
      final jsMessages = await getMessagesJs(sid, limit.toJS).toDart;
      return jsObjectToDart(jsMessages);
    } catch (e) {
      print("Error getting messages: $e");
      rethrow;
    }
  }

  /// Send a message to a conversation
  Future<void> sendMessage(String sid, String message) async {
    try {
      await sendMessageToConversationJs(sid, message).toDart;
    } catch (e) {
      print("Error sending message: $e");
      rethrow;
    }
  }

  /// Get a conversation by its SID
  Future<Map<String, dynamic>> getConversationBySid(String sid) async {
    try {
      final jsConversation = await getConversationBySidJs(sid).toDart;
      return jsObjectToDart(jsConversation);
    } catch (e) {
      print("Error getting conversation: $e");
      rethrow;
    }
  }

  /// Join a conversation
  Future<void> joinConversation(String sid) async {
    try {
      final result = await joinConversationJs(sid).toDart;
      // return result.toString();
    } catch (e) {
      print("Error joining conversation: $e");
      rethrow;
    }
  }

  /// Leave a conversation
  Future<void> leaveConversation(String sid) async {
    try {
      await leaveConversationJs(sid).toDart;
    } catch (e) {
      print("Error leaving conversation: $e");
      rethrow;
    }
  }

  /// Register a listener for new messages
  void registerMessageListener(void Function(Map<String, dynamic>) onMessage) {
    try {
      registerMessageListenerJs((JSObject message) {
        onMessage(jsObjectToDart(message));
      }.toJS);
    } catch (e) {
      print("Error registering message listener: $e");
      rethrow;
    }
  }

  /// Create a new conversation
  Future<Map<String, dynamic>> createConversation({
    String? uniqueName,
    String? friendlyName,
    bool isPrivate = false,
  }) async {
    try {
      final options = <String, dynamic>{
        if (uniqueName != null) 'uniqueName': uniqueName,
        if (friendlyName != null) 'friendlyName': friendlyName,
        if (isPrivate) 'attributes': {'private': isPrivate},
      }.jsify() as JSObject?;
      final jsConversation = await createConversationJs(options).toDart;
      return jsObjectToDart(jsConversation);
    } catch (e) {
      print("Error creating conversation: $e");
      rethrow;
    }
  }

  /// Add a participant to a conversation
  Future<Map<String, dynamic>> addParticipant(String conversationSid, String identity) async {
    try {
      final jsParticipant = await addParticipantJs(conversationSid, identity).toDart;
      return jsObjectToDart(jsParticipant);
    } catch (e) {
      print("Error adding participant: $e");
      rethrow;
    }
  }

  /// Subscribe to conversation events
  void subscribeToConversation(String sid) {
    // try {
    //   getConversationBySidJs(sid).toDart.then((conversation) {
    //     (conversation as JSObject).callMethod('on'.toJS, <JSAny?>[
    //       'updated'.toJS,
    //       ((JSObject event) {
    //         print("Conversation updated: ${jsObjectToDart(event)}");
    //       }).toJS,
    //     ]);
    //   });
    // } catch (e) {
    //   print("Error subscribing to conversation: $e");
    //   rethrow;
    // }
  }

  /// Convert JavaScript object to Dart map or list
  dynamic jsObjectToDart(JSAny? jsObj) {
    if (jsObj == null) return null;
    if (jsObj is JSArray) {
      return jsObj.toDart.map(jsObjectToDart).toList();
    }
    if (jsObj is JSObject) {
      final map = <String, dynamic>{};
      final keys = getObjectKeys(jsObj);
      for (var key in keys.toDart) {
        final value = jsObj.getProperty(key as JSString);
        map[key.toString()] = jsObjectToDart(value);
      }
      return map;
    }
    if (jsObj is JSString) return jsObj.toString();
    if (jsObj is JSNumber) return jsObj.toDartDouble;
    if (jsObj is JSBoolean) return jsObj.toDart;
    return jsObj;
  }
}