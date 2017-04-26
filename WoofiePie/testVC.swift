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
    @IBOutlet weak var useridField : UITextField!
    
    var randomImages = ["Unknown-1","Unknown-2","Unknown-3","Unknown-4","Unknown-5","Unknown-6","Unknown-7","Unknown-8","Unknown-9","Unknown-10"]
    @IBOutlet weak var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func check(_ sender : UIButton){
         let userid = UserDefaults.standard.value(forKey: "uid") as! String
        if let uid = self.useridField.text{
            let conversationManager = ConversationManager(userid: userid)
            conversationManager.initializeConversation() { (result) in
                print(result)
               let resultOfTest =  conversationManager.doesChatExist(user: uid)
                if resultOfTest.1{
                    print("chat exists")
                    let conversation = resultOfTest.0!
                    print(conversation)
                }
                else {
                    conversationManager.startNewConversationWith(user: uid, completion: { (conversation) in
                        print(conversation)
                    })
                }
            }
            
        }
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
      
       
        
       
    }
   

}
