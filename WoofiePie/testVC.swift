//
//  testVC.swift
//  WoofiePie
//
//  Created by Ravi on 20/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import FirebaseStorage
class testVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    
    func downloadImage(name :String , completion : @escaping (UIImage) -> ()){
        
        var alreadyFound  = false
        if let data = findImageInCache(with: name) , let image = UIImage(data: data){
             print("image found in cache")
            completion(image)
            alreadyFound = true
           
            
        }
        
        let ref = storage.reference().child("PetImages/\(name)")
        ref.data(withMaxSize: 1024*1024) { (data, error) in
            if let _ = error {
                print("error has occurred")
                return
            }
            if let data = data {
                if let image = UIImage(data: data){
                    cacheImage(image: image, imageName: name)
                    if !alreadyFound{
                        completion(image)
                    }
                }
            }
        }
    }
    
    @IBAction func loadPressed(_ sender : UIButton){
      let newView = ContactListView(frame:
        CGRect(x: 20, y: 20, width: 200, height: 200)
        )
       self.view.addSubview(newView)
        
       
    }
   

}
