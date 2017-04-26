//
//  ListPickerTextField.swift
//  WoofiePie
//
//  Created by Ravi on 10/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ListPickerTextField: UITextField , UIPickerViewDelegate , UIPickerViewDataSource{
    var list =  [String]()
   
   
    
    
    @IBInspectable var doneButtonTitleColorNormal : UIColor = UIColor.black{
        didSet{
            self.doneButton.setTitleColor(doneButtonTitleColorNormal, for: .normal)
        }
    }
    @IBInspectable var doneButtonTitleColorHighlighted : UIColor = UIColor.gray{
        didSet{
            self.doneButton.setTitleColor(doneButtonTitleColorHighlighted, for: .highlighted)
        }
    }
    
    @IBInspectable var doneButtonBackgroundColor : UIColor = UIColor.lightGray{
        didSet{
            self.doneButton.backgroundColor = doneButtonBackgroundColor
        }
    }
    
    
    
    private  var doneButton : UIButton = {
        //let width = self.bounds.width
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let button = UIButton(frame: frame)
        
        button.titleLabel?.isHidden = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.8
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 18.0)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private var listPicker : UIPickerView =
        {
       let picker = UIPickerView()
            picker.backgroundColor = UIColor.white
            return picker
    }()
    
    
    override init(frame : CGRect){
        super.init(frame : frame)
        setupView()
    }
    
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
     
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    func setupView(){
        listPicker.delegate = self
        listPicker.dataSource = self
        self.inputView = self.listPicker
        self.inputAccessoryView = self.doneButton
        doneButton.addTarget(self, action: #selector(self.doneButtonPressed(button:)), for: .touchUpInside)
    }
    func doneButtonPressed(button : UIButton){
        if list.count != 0{
            let index = listPicker.selectedRow(inComponent: 0)
            let animalType = list[index]
            self.text = animalType
        }
       
        if let aDelegate = self.delegate{
            if let shouldReturn = aDelegate.textFieldShouldReturn?(self){
                if shouldReturn{
                    self.resignFirstResponder()
                }
            }
        }
    }
    // MARK: UIPickerVie)!wDelelgate , UIPickerViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.list[row]
    }
  
}
