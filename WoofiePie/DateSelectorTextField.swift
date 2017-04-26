//
//  DateSelectorTextField.swift
//  WoofiePie
//
//  Created by Ravi on 10/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit


import UIKit




@IBDesignable
class CustomTextFieldDateSelector: UITextField  {
    
  
    
    
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
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 3.0
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 18.0)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 10.0
        return button
    }()
    
  
    private  var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.layer.cornerRadius = 10.0
        picker.datePickerMode = .date
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.backgroundColor = UIColor.white
        
        //get the max and min date
        let timeZone = NSTimeZone.system
        
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let maxDate = NSDate()
        var comps = cal?.components(in: timeZone, from: maxDate as Date)
        comps?.yearForWeekOfYear! -= 30
        let minDate = cal?.date(from: comps!)
        picker.maximumDate = maxDate as Date
        picker.minimumDate = minDate
        return picker
    }()
    
    
    //MARK :- Initializer
    override init(frame: CGRect) {
      
        super.init(frame: frame)
        setUpTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
      
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
       
        super.prepareForInterfaceBuilder()
        setUpTextField()
       
    }
    
    override func awakeFromNib() {
     
        super.awakeFromNib()
        setUpTextField()
    }
    
  
    
    func setUpTextField(){
       
        //setup inputview
        self.inputAccessoryView = self.doneButton
        self.inputView = self.datePicker
        
        
        //setup input accessoryView
        self.doneButton.titleLabel?.isHidden = false
        doneButton.addTarget(self, action: #selector(self.doneButtonPressed(button:)), for: .touchUpInside)
        //add shadow to the button
        
        
        
        
    }
    func doneButtonPressed(button : UIButton){
       
        let selectedDate = self.datePicker.date
        print(selectedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let finalDate =  dateFormatter.string(from: selectedDate)
        // print(finalDate)
        self.text = finalDate
        
        if let aDelegate = self.delegate{
            if let shouldReturn = aDelegate.textFieldShouldReturn?(self){
                if shouldReturn{
                    self.resignFirstResponder()
                }
            }
        }
    }
 
}

