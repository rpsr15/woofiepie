//
//  ChatVC.swift
//  WoofiePie
//
//  Created by Ravi on 24/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
class ChatVC: JSQMessagesViewController {
    var delegate: chatHolderVC!
    var conversationId : String!
    let incomingSource = MessageAvatarAndBubbleImageDataSource(sourceType: .Incoming)
    let outgoingSource = MessageAvatarAndBubbleImageDataSource(sourceType: .Outgoing)
    
    
    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ravi message viewcontroller did load")
        self.senderId = UserDefaults.standard.value(forKey: "uid") as! String
        self.senderDisplayName = "sef"
        self.conversationId = delegate.conversation.conversationId
        // Do any additional setup after loading the view.
      //
        self.loadMessages()
//        ref.child("Users").child(self.senderId).child("conversations").child(self.conversationId).child("hasRead").setValue(true)
        
    }
    
    
    func loadMessages(){
        print(#function)
       
        ref.child("Users").child(self.senderId).child("conversations").child(self.conversationId).child("messages").observe(.value, with: { (snapshot) in
            // all messages have been read
            
              let data = snapshot.children.allObjects as! [FIRDataSnapshot]
            var lst = [Message]()
            for eachData in data {
                let dict = eachData.value as! [String:Any]
                if  let message = Message(data: dict){
                    
                    lst.append(message)
                }
            }
            self.messages = lst
           
            self.collectionView.reloadData()
           
        }) { (error) in
            displayMessage(title: "error loading conversations.Please contact support team", message: nil, presenter: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
        self.senderId = delegate.selfid
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
      
       
        let message = Message(senderid: self.senderId, textBody: text, mediaPath: nil, createdOn: NSDate().timeIntervalSince1970, isMedia: false)
        self.messages.append(message)
       ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(conversationId).child("lastUpdated").setValue(NSDate().timeIntervalSince1970)
        ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(conversationId).child("messages").childByAutoId().setValue(message.getDictionary())
         ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(conversationId).child("messages").childByAutoId().setValue(message.getDictionary()) { (error, ref) in
            if let error = error {
                print("error setting  value \(error)")
            }
            print(ref)
        }
       ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(conversationId).child("lastUpdated").setValue(NSDate().timeIntervalSince1970)
       if self.senderId == self.delegate.conversation.party1{
            ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(self.conversationId).child("hasRead").setValue(false)
       }
       else {
ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(self.conversationId).child("hasRead").setValue(false)
        }
    
        
        self.finishSendingMessage(animated: true)
      
        
    }
   
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("camera button presssed")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
       let message = messages[indexPath.row]
        return message.getJSQMessage()
    
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let senderid = self.messages[indexPath.row].senderid
        if senderid == self.senderId{
            return outgoingSource
        }
        else {
           return incomingSource
        }
        
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let senderid = self.messages[indexPath.row].senderid
        if senderid == self.senderId{
            return outgoingSource
        }
        else {
            return incomingSource
        }
        

    }
    
    

}


