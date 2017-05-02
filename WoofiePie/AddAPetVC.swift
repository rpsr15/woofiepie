//
//  AddAPetVC.swift
//  WoofiePie
//
//  Created by Ravi on 20/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum Mode{
    case AddPet , EditPet
}

class AddAPetVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    var currentPet : Pet?
    var mode = Mode.AddPet
    var ownerId : String!
    var petImage : UIImage?
    
    
    
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var birthDayTextField : CustomTextFieldDateSelector!
    @IBOutlet weak var genderTextField : ListPickerTextField!
    @IBOutlet weak var breedTextField : ListPickerTextField!
    @IBOutlet weak var catergoryTextField : ListPickerTextField!
    @IBOutlet weak var profileImage : UIButton!
    @IBOutlet weak var addOrEditButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    // MARK: IBActions
    
    
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ownerId = UserDefaults.standard.value(forKey: "uid") as! String
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if auth.currentUser == nil {
                displayMessage(title: "user is not signed in ", message: nil, presenter: self)
                print("ravi error occured user not signed in ")
                UserDefaults.standard.set(nil, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        })
        
        
        //TODO: SetuptextFIelds
        genderTextField.list = ["Male","Female"]
        breedTextField.list = breeds
        catergoryTextField.list = ["Dog"]
        if mode == .EditPet{
            //set ui elements
            addOrEditButton.setTitle("Save", for: .normal)
            
            if let pet = currentPet{
                self.nameTextField.text = pet.name
                self.birthDayTextField.text = pet.birthDate
                self.genderTextField.text = pet.sex
                self.breedTextField.text = pet.breed
                self.catergoryTextField.text = pet.category
                //TODO: set profile image
                downloadImage(name: pet.petId, directory: "PetImages", completion: { (image) in
                    
                    DispatchQueue.main.async {
                        self.petImage = image
                        self.profileImage.setImage(image, for: .normal)
                    }
                    
                })
                
            }
            
        }
     
    }
    
    
    @IBAction func cancelPressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageSelectPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let imageSourceSelector = UIAlertController(title: "Set Profile Picture", message: nil, preferredStyle: .alert)
        //check if camera is available
        let albumAction = UIAlertAction(title: "Choose from Album", style: .default, handler: {
            action in
            //TODO: select photo from library
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                action in
                //TODO : select photo from camera
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            })
            imageSourceSelector.addAction(cameraAction)
        }
        imageSourceSelector.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            imageSourceSelector.dismiss(animated: true, completion: nil)
            
        }
        imageSourceSelector.addAction(cancelAction)
        
        present(imageSourceSelector, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //TODO: setimage to button background
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if let compressedImage = image.resized(toWidth: 80.0){
                profileImage.setBackgroundImage(compressedImage, for: .normal)
                self.petImage = compressedImage
                
            }
         
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPostPressed(_ sender : Any){

        if let name = nameTextField.text , name != "" , let birthDay = birthDayTextField.text , birthDay != "" ,
            let category = catergoryTextField.text , category != "" , let breed = breedTextField.text , breed != ""
            , let gender = genderTextField.text , gender != ""{
            
            // get the uid of user
            if let uid  = UserDefaults.standard.value(forKey: "uid"){
                let defaultString = ref.child("Users").child(uid as! String).child("pets").description()
                let petRef = ref.child("Users").child(uid as! String).child("pets").childByAutoId().description()
                
                
                var petid = ""
                
                if self.mode == .EditPet{
                    petid = (currentPet?.petId)!
                    
                }
                else {
                       petid =  (petRef as NSString).replacingOccurrences(of: defaultString+"/", with: "")
                }
              
                print("ravi"+petid)
                
                let newPet = Pet(petid: petid, name: name, birthDate: birthDay, breed: breed, category: category, sex: gender, ownerId:self.ownerId, profileImagePath: self.petImage == nil ? "" : petid)
                print("ravi addPostPressed uid found")
                ref.child("Users").child(uid as! String).child("pets").child(petid).setValue(newPet.getDictionary())
                if let photo = self.petImage{
                    //make buttons disbled
                    self.addOrEditButton.startAnimating()
                    self.cancelButton.isEnabled = false
                    
                    uploadImage(image: photo, name: newPet.petId, completed: {
                        self.addOrEditButton.stopAnimating()
                        self.cancelButton.isEnabled = true
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            else {
                // TODO: cant get uid force login
                displayMessage(title: "cant access uid", message: nil, presenter: self)
            }
            
            
            
        }
        else {
            displayMessage(title: "Please check all fields", message: nil, presenter: self)
        }
        
    
    }
    
}




extension AddAPetVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            birthDayTextField.becomeFirstResponder()
        }
        else if textField == birthDayTextField{
            breedTextField.becomeFirstResponder()
        }
        else if textField == breedTextField{
            genderTextField.becomeFirstResponder()
        }
        else if textField == genderTextField{
            textField.resignFirstResponder()
        }
        else {
            textField.resignFirstResponder()
           // return true
        }
        
        return true
    }
}

func uploadImage(image:UIImage , name: String , completed: @escaping () -> ()){
    if let data = UIImagePNGRepresentation(image){
    let ref = storage.reference().child("PetImages/\(name)")
        print("upload ref is \(ref)")
        let uploadTaask = ref.put(data, metadata: nil, completion: { (metadata, error) in
            guard let metadata  = metadata else {
            print("error occured")
                return
            }
            completed()
        })
    }
    
}
