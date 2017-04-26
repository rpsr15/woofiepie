//
//  PetCell.swift
//  WoofiePie
//
//  Created by Ravi on 20/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class PetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage : ProfileImageHolder!
    @IBOutlet weak var petName : UILabel!
    @IBOutlet weak var breed : UILabel!
    @IBOutlet weak var age : UILabel!
    @IBOutlet weak var sexLogo : UIButton!
    @IBOutlet weak var backgroundContainerView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        backgroundContainerView.layer.cornerRadius = 5.0    
       
    }
    
    
    
    
    func configureCell(pet : Pet){
        print(pet)
        self.petName.text = pet.name
        breed.text = pet.breed
        age.text = pet.getAge()
        print(pet)
        //set gender button
        if let imagePath = pet.petImagePath , imagePath != "" {
            downloadImage(name: pet.petId!, directory: "PetImages", completion: { (image) in
                DispatchQueue.main.async {
                    self.profileImage.profileImage = image
                }
            })
        }
        if pet.sex == "Male"{
            sexLogo.setTitle(" ♂", for: .normal)
            
            sexLogo.backgroundColor = MALE_BLUE
        }else {
            sexLogo.setTitle(" ♀", for: .normal)
            sexLogo.backgroundColor = FEMALE_PINK
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension Int{
    func string() -> String{
        return "\(self)"
    }
}




func downloadImage(name : String ,directory: String, completion: @escaping (_ image : UIImage) -> () ) {
    //check if file has already been archived
    var alreadyFound  = false
    if let data = findImageInCache(with: name) , let image = UIImage(data: data){
        print("image found in cache")
        completion(image)
        alreadyFound = true
        
        
    }
    
    let ref = storage.reference().child(directory).child(name)
    print("download ref is \(ref)")
    ref.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
        if let error = error {
            print("error occured donwload image \(error)")
        }
        else {
            if let data = data , let image = UIImage(data: data){
                print("pet image donwload successfully")
                cacheImage(image: image, imageName: name)
                if !alreadyFound{
                    completion(image)
                }
              
            }
        }
}
}
