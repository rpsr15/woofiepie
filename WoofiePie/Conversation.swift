//
//  Conversation.swift
//  WoofiePie
//
//  Created by Ravi on 24/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase




// class for a message in a conversation , one message can only have a single media.
class Message {
    
    //MARK: Properties
    var senderid : String
    var timeStamp : TimeInterval
    var text : String
    var mediaPath : String
    var isMediaMessage : Bool
   
    //MARK: Initializers
    convenience init?(data:[String:Any]) {
        guard let isMediaMessage = data["isMediaMessage"] as? Bool else {
            print("couldnt convert ismediaMEsssage")
            return nil}
        guard let mediaPath = data["mediaPath"] as? String else {
            print("couldnt convert mediapath")
            return nil
        }
        guard let senderId = data["senderId"] as? String else {
            print("couldnt convert senderid")
            return nil
        }
        
        guard let text = data["text"] as? String else {
            print("couldnt convert text")
            return nil
        }
        
        guard let time = data["time"] as? String else {
            print("couldnt convert time")
            return nil}
      
      
        self.init(senderid: senderId, textBody: text, mediaPath: mediaPath, createdOn: Double(time)!, isMedia: isMediaMessage)
    }
    
    init(senderid : String  , textBody : String , mediaPath : String?, createdOn : TimeInterval, isMedia : Bool) {
        
        self.senderid = senderid
        self.isMediaMessage = isMedia
         self.text = textBody
        self.timeStamp = createdOn
        if mediaPath == nil || mediaPath == "" {
            self.mediaPath =  ""
            
        }
        else {
        self.mediaPath = mediaPath!
        }
      
    }
    
    
   func  getJSQMessage() -> JSQMessage{
    //TODO: take care of messages with media
    let createdOn = Date(timeIntervalSince1970: self.timeStamp)
   
        return JSQMessage(senderId: self.senderid, senderDisplayName: "sender", date: createdOn, text: self.text)
    }
    
    func getDictionary() -> [String : Any]{
        //TODO: take care of messages with media
        return ["senderId":self.senderid , "text":self.text,"time":String(self.timeStamp),"mediaPath":self.mediaPath,"isMediaMessage":self.isMediaMessage]
    }
    
   }

//each conversation is represented by a conversation id , each user has to keep track of conversations




class Conversation {
    var conversationId : String
    var party1 : String
    var party2 : String
    var messages  = [Message]()
    var hasRead  = true
    var lastUpdated : Double
    
    var description : String{
        return self.conversationId+self.party1+self.party2
    }
    convenience init(id : String , sender : String ,receiver : String,messages: [Message]? , lastUpdated : Double , hasRead :Bool) {
        self.init(id: id, sender: sender, receiver: receiver, messages: messages)
        self.lastUpdated = lastUpdated
        self.hasRead = hasRead
    }
    
    
    init(id : String , sender : String ,receiver : String,messages: [Message]?) {
        self.conversationId = id
        self.party1 = sender
        self.party2 = receiver
        if messages != nil {
            self.messages = messages!
        }
        
        
        self.lastUpdated = NSDate().timeIntervalSince1970
    }
    
    func idOfOtherUser(senderuserid : String) -> String{
        if self.party1 == senderuserid{
            return self.party2
        }
        else
        {
            return self.party1
        }
    }
    
    func hasUser(user:String) -> Bool{
        if user == self.party1 || user == self.party2{
            return true
        }
        return false
    }
    
    // return empty string if message count is zero
    
    convenience init?(firData : FIRDataSnapshot) {
       
       let id = firData.key
        guard let data = firData.value as? [String:Any] else {
            return nil
        }
        
        
        
        guard  let p1 = data["party1"] as? String ,  let p2 = data["party2"] as? String else {
            return nil
        }
        var msgs : [Message]?
        if let messages = data["messages"] as? [String:Any]{
            msgs = [Message]()
            for key in messages.keys{
                if let dict = messages[key] as? [String:Any]{
               
                    if let msg = Message(data: dict){
                        msgs?.append(msg)
                    }
                }
            }
        }
        
        if let messages = msgs , messages.count > 1{
            msgs = messages.sorted { (m1, m2) -> Bool in
                return m1.timeStamp < m2.timeStamp
            }

        }
        guard let hasRead = data["hasRead"] as? Bool else {
            return nil
        }
        guard let lastUpdated = data["lastUpdated"] as? Double else {return nil}
        self.init(id: id, sender: p1, receiver: p2,messages:msgs ,lastUpdated : lastUpdated , hasRead : hasRead)
        
    }
   
    
    
}

