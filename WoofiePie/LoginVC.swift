//
//  LoginVC.swift
//  WoofiePie
//
//  Created by Ravi Rathore on 08/07/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginVC : UIViewController  {
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    
    // MARK : IBACTIONS
    
    @IBAction func loginPressed(_ sender : Any){
     
        if let email = emailTextField.text , email != "" , let password = passwordTextField.text ,password != "" {
               (sender as? UIButton)?.startAnimating()
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    displayMessage(title: error.localizedDescription, message: nil, presenter: self)
                    self.passwordTextField.text = ""
                    self.emailTextField.text = ""
                    (sender as? UIButton)?.stopAnimating()
                }
                    
                    
                else if user?.uid != nil {
                    
                    //ceck if use is in blocked list
                    print("ravi login successfull \(user)")
                    (sender as? UIButton)?.stopAnimating()
                    UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "loginToTabBarVC", sender: nil)
                }
            })
        }
        else{
            displayMessage(title: "Please check email and password", message: nil, presenter: self)
            (sender as? UIButton)?.stopAnimating()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isloggedIn(){
        performSegue(withIdentifier: "loginToTabBarVC", sender: nil)
        }
        
    }
    func isloggedIn() -> Bool{
        if (UserDefaults.standard.value(forKey: "uid") != nil){
            return true
        }
        return false
    }

   
}

extension LoginVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
            loginPressed(textField)
        }
        return true
    }
}


