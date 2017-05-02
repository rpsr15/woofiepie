//
//  chatHolderVC.swift
//  WoofiePie
//
//  Created by Ravi on 03/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class chatHolderVC: UIViewController {
    // MARK: Properties
    var conversation : Conversation!
    var selfid : String!
    var receiverId : String!
    var receiverName : String?
    var receiverImagePath : String?
    var receiverProfile : UserProfile?
    
    // MARK: IBOutlet
    @IBOutlet weak var receiverNameLabel: UILabel!
    
    //MARK: IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        // set has read to true
        ref.child("Users").child(selfid).child("conversations").child(conversation.conversationId).child("hasRead").setValue(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //load required userdetails
        selfid = UserDefaults.standard.value(forKey: "uid") as! String
        if selfid == conversation.party1{
            receiverId = conversation.party2
        }
        else {
            receiverId = conversation.party1
        }
        
        ref.child("Users").child(receiverId).observe(.value
            , with: { (snapshot) in
                if   let user = UserProfile(dictionaryData: snapshot.value as! [String : Any]){
                    self.receiverProfile = user
                    DispatchQueue.main.async {
                        self.receiverNameLabel.text = self.receiverProfile?.name
                    }
                }
                else {
                    displayMessage(title: "Unable to loadProfile", message: nil, presenter: self)
                }
                
        }) { (error) in
            print(error)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("ravi preparing for segue")
    
        if segue.identifier == "holderToChatVC"{
        let chatVc  = segue.destination as! ChatVC
        chatVc.delegate = self
        }
    }

    

}
