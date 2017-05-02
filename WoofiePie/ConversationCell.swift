//
//  ConversationCell.swift
//  WoofiePie
//
//  Created by Ravi on 24/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var profileImage : ProfileImageHolder!
    @IBOutlet weak var receiverNameLabel : UILabel!
    @IBOutlet weak var latestMessage : UILabel!
    @IBOutlet weak var hasReadButton : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.hasReadButton.isHidden = true
    }

    func configureCell(useridOfOtherUser : String , latestMessage : String){
        
        downloadImage(name: useridOfOtherUser, directory: "UserImages") { (image) in
            DispatchQueue.main.async {
            self.profileImage.profileImage = image
            }
        }
        ref.child("Users").child(useridOfOtherUser).child("name").observe(.value, with: { (dataSnapshot) in
            if let name = dataSnapshot.value as? String{
                DispatchQueue.main.async {
                    self.receiverNameLabel.text = name
                }
            }
        })
        
        self.latestMessage.text = latestMessage
        //set image of other user
    }
    

}
