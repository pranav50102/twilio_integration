console.log("twilio_wrapper.js loaded");

let chatClient = null;

window.initTwilio = function(token) {
  console.log("Token received:", token);
  return Twilio.Conversations.Client.create(token)
    .then(client => {
      chatClient = client; // Store client for reuse
      console.log("Twilio client initialized.");
      return "success";
    })
    .catch(err => {
      console.error("Twilio init error:", err);
      throw err;
    });
};

window.getSubscribedConversations = async function() {
  try {
    if (!chatClient) return [];
    const paginator = await chatClient.getSubscribedConversations();
    return paginator.items.map(c => ({
      sid: c.sid,
      friendlyName: c.friendlyName,
      uniqueName: c.uniqueName
    }));
  } catch (error) {
    console.error("getSubscribedConversations error:", error);
    throw error;
  }
};

window.getConversationBySid = async function(sid) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.getConversationBySid(sid);
    return {
      sid: convo.sid,
      friendlyName: convo.friendlyName,
      uniqueName: convo.uniqueName
    };
  } catch (error) {
    console.error("getConversationBySid error:", error);
    throw error;
  }
};

window.sendMessageToConversation = async function(sid, message) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.getConversationBySid(sid);
    return await convo.sendMessage(message);
  } catch (error) {
    console.error("sendMessageToConversation error:", error);
    throw error;
  }
};

window.joinConversation = async function(sid) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.getConversationBySid(sid);
    return await convo.join();
  } catch (error) {
    console.error("joinConversation error:", error);
    throw error;
  }
};

window.leaveConversation = async function(sid) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.getConversationBySid(sid);
    return await convo.leave();
  } catch (error) {
    console.error("leaveConversation error:", error);
    throw error;
  }
};

window.getMessages = async function(sid, limit = 50) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.getConversationBySid(sid);
    const paginator = await convo.getMessages(limit);
    return paginator.items.map(msg => ({
      sid: msg.sid,
      body: msg.body,
      author: msg.author,
      dateCreated: msg.dateCreated
    }));
  } catch (error) {
    console.error("getMessages error:", error);
    throw error;
  }
};

window.registerMessageListener = function(callback) {
  if (!chatClient) {
    console.warn("registerMessageListener: Client not initialized");
    return;
  }

  try {
    // Attach listener for all existing conversations
    chatClient.getSubscribedConversations().then(paginator => {
      paginator.items.forEach(convo => {
        convo.on('messageAdded', msg => callback({
          sid: msg.sid,
          body: msg.body,
          author: msg.author,
          dateCreated: msg.dateCreated
        }));
      });
    });

    // Attach listener for new conversations
    chatClient.on('conversationAdded', convo => {
      convo.on('messageAdded', msg => callback({
        sid: msg.sid,
        body: msg.body,
        author: msg.author,
        dateCreated: msg.dateCreated
      }));
    });

    console.log("registerMessageListener: Listeners registered");
  } catch (error) {
    console.error("registerMessageListener error:", error);
  }
};

window.createConversation = async function(options) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const convo = await chatClient.createConversation(options);
    return {
      sid: convo.sid,
      uniqueName: convo.uniqueName,
      friendlyName: convo.friendlyName
    };
  } catch (error) {
    console.error("createConversation error:", error);
    throw error;
  }
};

window.addParticipant = async function(conversationSid, identity) {
  try {
    if (!chatClient) throw new Error("Client not initialized");
    const conversation = await chatClient.getConversationBySid(conversationSid);
    const participant = await conversation.add(identity);
    return {
      sid: participant.sid,
      identity: participant.identity
    };
  } catch (error) {
    console.error("addParticipant error:", error);
    throw error;
  }
};

window.getObjectKeys = function(obj) {
  return Object.keys(obj);
};

console.log("twilio_wrapper.js completely loaded");