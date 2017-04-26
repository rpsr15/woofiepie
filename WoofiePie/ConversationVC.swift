//
//  ConversationVC.swift
//  WoofiePie
//
//  Created by Ravi on 24/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
class ConversationVC: UIViewController {
    
     var conversations = [Conversation]()
     var conversationList = [String]()
     var currentUserId : String!
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserId = UserDefaults.standard.value(forKey: "uid") as! String
        //load full comversations by getting ids and then details
        print(#function)
        self.loadConversations()
      
    }
    
    
    
    func loadConversations(){
        print(#function)
        ref.child("Users").child(self.currentUserId).child("conversations").observe(.value, with: { (snap) in
            var cnvs = [Conversation]()
            for i in snap.children.allObjects as! [FIRDataSnapshot]{
                if let conversation = Conversation(firData: i){
                    print("success parsing conversation data")
                    if conversation.messages.count > 0 {
                          cnvs.append(conversation)
                    }
                  
                }
                
            }
            // sort cnvs as per lst updated
            let sortedConversations = cnvs.sorted(by: { (c1, c2) -> Bool in
                return c1.lastUpdated > c2.lastUpdated
            })
            self.conversations = sortedConversations
           
                self.tableView.reloadData()
            
        }) { (error) in
            print(error)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatVC"{
            let dest = segue.destination as! chatHolderVC
            let conv = sender as! Conversation
            dest.conversation = conv
    }

}
}

extension ConversationVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationCell
        let conversation = self.conversations[indexPath.row]
       print("hasRead \(conversation.hasRead)")
        if conversation.hasRead == false {
            cell.hasReadButton.isHidden = false
        }
        else {
            cell.hasReadButton.isHidden = true
        }
        
        cell.configureCell(useridOfOtherUser: conversation.idOfOtherUser(senderuserid: self.currentUserId), latestMessage: conversation.messages.last?.text ?? "")
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let conv = self.conversations[indexPath.row]
        performSegue(withIdentifier: "chatVC", sender: conv)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let conversation = self.conversations[indexPath.row]
            confirmDelete(conversation: conversation)
        }
    }
    
    func confirmDelete(conversation : Conversation){
        let vc = UIAlertController(title: "Confirm Delete?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            ref.child("Users").child(self.currentUserId).child("conversations").child(conversation.conversationId).child("messages").setValue(nil)
        }
        vc.addAction(cancelAction)
        vc.addAction(deleteAction)
        self.present(vc, animated: true, completion: nil)
    }
    
}
