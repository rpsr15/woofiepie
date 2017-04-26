//
//  ProfileCellTableViewCell.swift
//  WoofiePie
//
//  Created by Ravi on 30/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ProfileCellTableViewCell: UITableViewCell {
    var user :UserProfile?
    @IBOutlet weak var profileImage : ProfileImageHolder!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var locationLabel :UILabel!
    @IBOutlet weak var messageButton: RoundedUIButton!
    @IBOutlet weak var followButton: RoundedUIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func didPressFollowButton(_ sender: Any) {
    }
    func configureCell(user : UserProfile , type : ProfileListType){
        self.nameLabel.text = user.name
        self.locationLabel.text = user.location
        downloadImage(name: user.userId!, directory: "UserImages") { (image) in
            DispatchQueue.main.async {
                self.profileImage.profileImage = image
            }
        }
    }
    
    

}
