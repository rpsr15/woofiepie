//
//  ConversationManager.swift
//  WoofiePie
//
//  Created by Ravi on 23/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import Foundation
import Firebase

class ConversationManager {
    
    private var userId : String
    
    
    init(userid: String) {
        self.userId = userid
    }
    var conversations = [Conversation]()
    
     func doesChatExist(user : String) -> (Conversation?, Bool){
        for  c in self.conversations{
            if c.hasUser(user: user){
                return (c,true)
            }
        }
        return (nil,false)
     }
    
    
     func initializeConversation( completion : @escaping (_ success : Bool) -> ()){
        ref.child("Users").child(userId).child("conversations").observe(.value, with: { (snap) in
            var cnvs = [Conversation]()
            for i in snap.children.allObjects as! [FIRDataSnapshot]{
                if let conversation = Conversation(firData: i){
                    cnvs.append(conversation)
                }
            }
            
            self.conversations = cnvs
            completion(true)
        }) { (erro) in
            print(erro.localizedDescription)
            completion(false)
        }
    }
    
    func startNewConversationWith(user: String , completion: (Conversation) -> ()){
      let uidOfReceiver = user
        let uidOfSender = UserDefaults.standard.value(forKey: "uid") as! String
        let conversationId = uidOfSender+uidOfReceiver
        // add conversation references to both users
        
        ref.child("Users").child(uidOfSender).child("conversations").child(conversationId).child("party1").setValue(userId)
         ref.child("Users").child(uidOfSender).child("conversations").child(conversationId).child("party2").setValue(user)
        ref.child("Users").child(uidOfReceiver).child("conversations").child(conversationId).child("party1").setValue(userId)
        ref.child("Users").child(uidOfReceiver).child("conversations").child(conversationId).child("party2").setValue(user)
       
        
        let conversation = Conversation(id: conversationId, sender: uidOfSender, receiver: uidOfReceiver,messages:nil)
        completion(conversation)
    }

    
}
