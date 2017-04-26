//
//  ProfileDisplayVC.swift
//  WoofiePie
//
//  Created by Ravi on 17/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase

class ProfileDisplayVC: UIViewController , UITableViewDataSource , UITableViewDelegate{
    var profileId : String!
    var selfProfileId : String!
    private var userProfile : UserProfile?
    private var pets = [Pet]()
    @IBOutlet weak var profileImage: ProfileImageHolder!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followButton: RoundedUIButton!
    private var cM : ConversationManager?
    @IBAction func didPressMessageButton(_ sender: Any) {
         cM = ConversationManager(userid: selfProfileId)
        if let cM = cM
        {cM.initializeConversation { (result) in
            if result{
                let chatResult = cM.doesChatExist(user: self.profileId)
                if chatResult.1{
                    let conv = chatResult.0!
                    // initialize chat window
                    self.presentChatVC(conversation: conv)
                }
                else {
                    cM.startNewConversationWith(user: self.profileId, completion: { (conversation) in
                        //initialize chat window
                        self.presentChatVC(conversation: conversation)
                    })
                }
            }
        }
        }
       // performSegue(withIdentifier: "profileToConversation", sender: <#T##Any?#>)
     
    }
    func presentChatVC(conversation : Conversation){
        self.cM = nil
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! chatHolderVC
        vc.conversation = conversation
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func didPressFollowButton(_ sender: UIButton) {
        
        
        //  ref.child("Users")
        print(#function)
        
        if sender.titleLabel?.text == "Follow"{
            ref.child("Users").child(profileId).child("followers").child(self.selfProfileId).setValue(true)
        ref.child("Users").child(self.selfProfileId).child("following").child(self.profileId).setValue(true)
            sender.setTitle("UnFollow", for: .normal)
        }
        else {
         ref.child("Users").child(profileId).child("followers").child(self.selfProfileId).removeValue()
            ref.child("Users").child(self.selfProfileId).child("following").child(self.profileId).removeValue()
            sender.setTitle("Follow", for: .normal)
        }
        
        
        
    }
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true
            , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.selfProfileId = UserDefaults.standard.value(forKey: "uid") as! String
        getUserDetails(userId: profileId)
        
        
    }
   
    
    func getUserDetails(userId : String){
        
        
        ref.child("Users").child(userId).observe(.value, with: { (snapshot) in
            if  let userData = snapshot.value as? [String : Any]{
                if let person = UserProfile(dictionaryData: userData){
                    
                    self.userProfile = person
                    
                    if person.followers.contains(self.selfProfileId){
                        
                        self.followButton.setTitle("UnFollow", for: .normal)
                    }
                    else {
                        self.followButton.setTitle("Follow", for: .normal)
                    }
                    if let allPets = person.pets{
                        self.pets = allPets
                    }
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        //updateui
                        self.nameLabel.text = person.name
                        if person.location != "" {
                            self.locationLabel.text = person.location
                        }
                        else {
                            self.locationLabel.text = "Location Not Provided"
                        }
                    }
                }
                
                
            }
        })
        
    }
    
    // MARK: UITableViewDelegate , UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "petCell") as! PetCell
        cell.alpha = 0.5
        let pet = pets[indexPath.row]
        cell.configureCell(pet: pet)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    
    
    
}
