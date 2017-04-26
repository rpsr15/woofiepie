//
//  RoundedUIButton.swift
//  WoofiePie
//
//  Created by Ravi on 09/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedUIButton : UIButton{
   @IBInspectable var borderColor : UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
   @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
            
        }
    }
    
   @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
        setupView()
    }
   override init(frame: CGRect) {
        super.init(frame: frame)
    setupView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView(){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    
    
}
