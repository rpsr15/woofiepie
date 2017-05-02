//
//  ContactListView.swift
//  WoofiePie
//
//  Created by Ravi on 29/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ContactListView: UIView {
    // text for toplabel
    var topLabelText : String = "Select"{
        didSet{
            self.topLabel.text = topLabelText
        }
    }
    //title for cancel button
    var cancelButtonText : String = "Cancel"{
        didSet{
            self.cancelButton.titleLabel?.text = cancelButtonText
        }
    }
    func reloadList(){
        self.list.reloadData()
    }
    
    var tableViewDelegate : UITableViewDelegate? {
        didSet{
            self.list.delegate = tableViewDelegate
        }
    }
    
    var tableViewDataSource : UITableViewDataSource? {
        didSet{
            self.list.dataSource  = tableViewDataSource
        }
    }
    
    private let topLabel : UILabel =  {
        let label = UILabel()
        label.backgroundColor = APP_BLUE_COLOR
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    private let list : UITableView = {
    let table = UITableView()
        table.separatorStyle = .none
    return table
    }()
    
    private let cancelButton : RoundedUIButton = {
    let button = RoundedUIButton()
        button.backgroundColor = APP_SAFFRON_COLOR
        button.titleLabel?.textColor = UIColor.white
        button.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        button.layer.cornerRadius = 5.0
        
    return  button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }
    func cancelButtonPressed(){
       self.removeFromSuperview()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupControl(){
        // add shadow
        //self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.list.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(topLabel)
        self.addSubview(list)
        self.addSubview(cancelButton)
        //setup text for controls
        self.topLabel.text = self.topLabelText
        self.cancelButton.setTitle(self.cancelButtonText, for: .normal)
        
        //setup autolayout
        self.topLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.topAnchor.constraint(equalTo: self.topLabel.topAnchor, constant: 0).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.topLabel.bottomAnchor.constraint(equalTo: self.list.topAnchor, constant: 0).isActive = true
        self.list.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.list.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.list.bottomAnchor.constraint(equalTo: self.cancelButton.topAnchor, constant: -8).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    
}
