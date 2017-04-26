//
//  ProfileImageHolder.swift
//  TestProject
//
//  Created by Ravi on 07/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
@IBDesignable
class ProfileImageHolder: UIView {

    @IBInspectable var profileImage : UIImage?{
        didSet{
            self.imageHolder.image = profileImage
        }
    }
    
    fileprivate var imageHolder : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    @IBInspectable var borderWidth : CGFloat = 0.0
        {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.black
        {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor :  UIColor = UIColor.black
        {
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0.0
        {
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize.zero {
        didSet{
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 1.0 {
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
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
        let radius = frame.height < frame.width ? frame.height/2 : frame.width / 2
        layer.cornerRadius = radius
        imageHolder.layer.cornerRadius = radius
        addSubview(imageHolder)
        self.centerXAnchor.constraint(equalTo: imageHolder.centerXAnchor, constant: 0).isActive = true
        self.centerYAnchor.constraint(equalTo: imageHolder.centerYAnchor, constant: 0).isActive = true
        self.widthAnchor.constraint(equalTo: imageHolder.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: imageHolder.heightAnchor).isActive = true
        
    }

}
