//
//  NetworkActivityView.swift
//  WoofiePie
//
//  Created by Ravi on 14/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIButton{
    func startAnimating(){
       let activity = NVActivityIndicatorView(frame:
        self.bounds
        , type: .ballPulse, color: nil, padding: nil)
        activity.tag = 1991
        activity.startAnimating()
        addSubview(activity)
        self.isEnabled = false

    }

    func stopAnimating(){
        self.isEnabled = true
        for v in self.subviews{
            if v.tag == 1991
            {
                v.removeFromSuperview()
            }
        }
    }

}
