//
//  SignUpVC.swift
//  WoofiePie
//
//  Created by Ravi on 10/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class SignUpVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    // MARK: IBOUTLET
    
    

    private var currentUser : FIRUser?
    @IBOutlet weak var signUpButton: RoundedUIButton!
    @IBOutlet weak var cancelButton : RoundedUIButton!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    @IBAction func cancelPressed(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpPressed(_ sender: Any) {
        cancelButton.isEnabled = false
        signUpButton.startAnimating()
     
        if let name = displayName.text , name != "" , let email = emailTextField.text , email != "" , let pass = passwordTextField.text , pass != "" {
            (sender as? UIButton)?.startAnimating()
            
            
            // register user with email and password
            
            FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                if error != nil {
                    displayMessage(title: error?.localizedDescription, message: nil, presenter: self)
                    self.cancelButton.isEnabled = true
                    (sender as? UIButton)?.stopAnimating()

                }
                else if user != nil {
                    print("ravi user created moving to  tabbar")
                    let newUser = UserProfile(userId: user!.uid, name: name, location: nil, email: email, pets: nil)
                    let userDict = newUser.getDictionary()
                    ref.child("Users").child(user!.uid).setValue(userDict)
                    //TODO: move to main screen
                    UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()

                    self.dismiss(animated: true, completion: nil)
                    
                }
                else {
                    displayMessage(title: "Error occured.Please try again", message: nil, presenter: self)
                    self.cancelButton.isEnabled = true
                    (sender as? UIButton)?.stopAnimating()
                    
                }
            })
            
            
        }
        else {
            displayMessage(title: "Please check all text fields", message: nil, presenter: self)
            (sender as? UIButton)?.stopAnimating()
            cancelButton.isEnabled = true
            signUpButton.stopAnimating()
        }
        
        
        
       
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayName.becomeFirstResponder()
    }
 
    
  

}


  extension  SignUpVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == displayName{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
            signUpPressed(textField)
        }
        
        return true
    }
}
