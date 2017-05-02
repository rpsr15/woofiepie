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
class ChatVC: JSQMessagesViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
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
        ref.child("Users").child(self.senderId).child("conversations").child(self.conversationId).child("hasRead").setValue(true)
        
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
        displayMessage(title: "Not Supported", message: "Please check in updated version", presenter: self)
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        
//        let actionSheet = UIAlertController(title: "Select Media Source", message: nil, preferredStyle: .actionSheet)
//       if  UIImagePickerController.isSourceTypeAvailable(.camera){
//            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
//                //presrnt
//                imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true, completion: nil)
//            })
//        
//        actionSheet.addAction(cameraAction)
//        }
//        
//        let imageAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
//            //preset gallrey
//            imagePicker.sourceType = .photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        actionSheet.addAction(imageAction)
//        actionSheet.addAction(cancelAction)
//        self.present(actionSheet, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let key = UIImagePickerControllerOriginalImage
        if let image = info[key] as? UIImage{
            let uniqueName = self.senderId+String(Int(NSDate().timeIntervalSince1970))
            let message = Message(senderid: self.senderId, textBody: "", mediaPath: uniqueName, createdOn: NSDate().timeIntervalSince1970, isMedia: true)
            uploadImage(image: image, imageName: uniqueName, directory: "conversations", completion: { (result) in
                if result{
                    //append message and upload it
                    self.messages.append(message)
                    //upload data to firebase
                    ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(self.conversationId).child("lastUpdated").setValue(NSDate().timeIntervalSince1970)
                    ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(self.conversationId).child("messages").childByAutoId().setValue(message.getDictionary())
                    ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(self.conversationId).child("messages").childByAutoId().setValue(message.getDictionary()) { (error, ref) in
                        if let error = error {
                            print("error setting  value \(error)")
                        }
                        print(ref)
                    }
                    ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(self.conversationId).child("lastUpdated").setValue(NSDate().timeIntervalSince1970)
                    if self.senderId == self.delegate.conversation.party1{
                        ref.child("Users").child(self.delegate.conversation.party2).child("conversations").child(self.conversationId).child("hasRead").setValue(false)
                    }
                    else {
                        ref.child("Users").child(self.delegate.conversation.party1).child("conversations").child(self.conversationId).child("hasRead").setValue(false)
                    }
                    
                    
                    self.finishSendingMessage(animated: true)
                    
                }
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    

}


