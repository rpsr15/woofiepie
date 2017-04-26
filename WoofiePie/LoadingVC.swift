//
//  LoadingVC.swift
//  WoofiePie
//
//  Created by Ravi on 28/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class LoadingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let activity = NVActivityIndicatorView(frame:
            CGRect(x: 0, y: 0, width: 50, height: 50)
            , type: NVActivityIndicatorType.ballPulse, color: APP_SAFFRON_COLOR, padding: nil)
        self.view.addSubview(activity)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isloggedIn(){
            print("ravi user already logged in ")
            performSegue(withIdentifier: "loadingToMainTabBar", sender: nil)
        }
        else {
            print("ravi user is not logged in. loggin in")
            
            
            performSegue(withIdentifier: "loadingToLogin", sender: nil)
        }
    }
    
    func isloggedIn() -> Bool{
        if (UserDefaults.standard.value(forKey: "uid") != nil){
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

}
