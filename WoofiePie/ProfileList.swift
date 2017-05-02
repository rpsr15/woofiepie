//
//  ProfileList.swift
//  WoofiePie
//
//  Created by Ravi on 30/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

extension UITableView{
    func indexPathFor(view : UIView) -> IndexPath{
        let location = view.convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: location)!
    }
}
enum ProfileListType : String {
    case FollowersList = "followers"
    case FollowingList = "following"
}

class ProfileList: UIViewController  , UITableViewDelegate, UITableViewDataSource {
    
    
    var delegate : ProfileVC?
    @IBOutlet weak var topLabel : UILabel!
    @IBOutlet weak var profileListTableView : UITableView!
    
    
    @IBAction func backButtonPressed(sedner: Any){
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    
    var type : ProfileListType!
    private var uidList = [String]()
    private var userList = [UserProfile]()
    private var updatedList = false

    override func viewDidLoad() {
        profileListTableView.delegate = self
        profileListTableView.dataSource = self
        
        super.viewDidLoad()
         self.profileListTableView.contentInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 0, right: 0)
        if type == .FollowersList{
            topLabel.text = "Followers"
           
        }
        if type == .FollowingList{
            topLabel.text = "Following"
        }
        loadList(key: self.type.rawValue)

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func loadList(key: String){
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String{
             ref.child("Users").child(uid).child(key).observe(.value, with: { (snapshot) in
                if let dicts = snapshot.value as? [String:Any]{
                    let uids = Array(dicts.keys)
                    self.uidList = uids
                    //get user details
                    
                    self.loadPersonDetails()
                }
            
             }, withCancel: { (error) in
                print("ravi error getting list \(error)")
             })
        }
      
    }
    
    func loadPersonDetails(){
       
        self.userList = [UserProfile]()
        for uid in uidList{
            ref.child("Users").child(uid).observe(.value, with: { (snapshot) in
                if let data = snapshot.value as? [String : Any]{
                   if  let p = UserProfile(dictionaryData: data){
                        print(p)
                    self.userList.append(p)
                    if self.userList.count == self.uidList.count{
                        self.profileListTableView.reloadData()
                    }
                    }
                }
            }, withCancel: { (error) in
                print(error)
            })
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return   userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCellTableViewCell
        cell.alpha = 0.5
       let user = userList[indexPath.row]
        //let user = UserProfile(userId: "sdfds", name: "sdfds", location: "sdfds", email: "sdfds", pets: nil)
        cell.configureCell(user: user, type: self.type)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let person = self.userList[indexPath.row]
      performSegue(withIdentifier: "listToDisplay", sender: person.userId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDisplay"{
            let id = sender as! String
            let dest = segue.destination as! ProfileDisplayVC
            dest.profileId = id
    }
    }
   

}
