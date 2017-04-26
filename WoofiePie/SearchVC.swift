//
//  SearchVC.swift
//  WoofiePie
//
//  Created by Ravi on 10/04/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class SearchVC: UIViewController ,CLLocationManagerDelegate , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var searchStack: UIStackView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var genderTextField: ListPickerTextField!
    @IBOutlet weak var breedTextField: ListPickerTextField!
    @IBOutlet weak var topVIewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView : UIView!
    private var selfLocation : Location?
    private var isTopViewExpanded  = false
    private var locationManager : CLLocationManager!
    private var userId : String!
    private var pets = [Pet]()
    
    @IBOutlet weak var expandButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.breedTextField.list = breeds
        self.genderTextField.list = ["Male",
        "Female"]
        self.userId = UserDefaults.standard.value(forKey: "uid") as! String
        // Do any additional setup after loading the view.
        ref.child("Users").child(self.userId).child("location").observe(.value, with: { (snap) in
       
            if let location = snap.value as? String{
                if location == ""{
                   self.setUserLocation()
                }
                else {
                    let comps = location.components(separatedBy: ",")
                    let city = comps.first
                    let country = comps.last
                    let state = comps[comps.startIndex.advanced(by: 1)]
                    if let l = Location(countryName: country ?? "", stateName: state , cityName: city ?? ""){
                        self.selfLocation = l
                    }
                }
             
            }
          
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    func setUserLocation(){
        if locationManager == nil {
            self.locationManager = CLLocationManager()
            
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1000.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
    
    }
        // MARK: IBOutlets
    
    func loadSearchView(){
        let breedTextField = UITextField(frame:
        CGRect(x: 0, y: 0, width: 100, height: 30))
            self.topView.addSubview(breedTextField)
        
    }
    
    @IBAction func findButtonPressed(_ sender : Any){
        
            if let currentLocation = self.selfLocation , let breed = self.breedTextField.text , breed != "" , let gender = genderTextField.text , gender != "" {
                
                            ref.child("Users").queryOrdered(byChild: "location").queryEqual(toValue: currentLocation.getLocationString()).observe(.value
                                , with: { (snap) in
                                       var newPets = [Pet]()
                                  //  print("initial pet list")
                                  //  print(newPets)
                                    if let people =  snap.children.allObjects as? [FIRDataSnapshot]{
                                        for personData in people {
                                          //  print(personData.key)
                                            ///print(personData.value)
                                            _ = personData.key
                                            if let personInfo = personData.value as? [String:Any]{
                                                if let p = UserProfile(dictionaryData: personInfo){
                                                    if let pets = p.pets , p.userId != self.userId{
                                                      //  print("pets for \(p.name) are")
                                                       // print(pets)
                                                        let filteredPet =   pets.filter({ (pet) -> Bool in
                                                            return (pet.breed == breed) && (pet.sex == gender)
                                                        })
                                                       // print("filtered pets for \(p.name) are")
                                                      //  print(filteredPet)
                                                        newPets.append(contentsOf: filteredPet)
                                                        
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    //print("final pet list is")
                                    //print(newPets)
                                  self.pets = newPets
                                    if self.pets.count == 0 {
                                    //displayMessage(title: "No Pets found.", message: "Please check filters", presenter: self)
                                    }
                              self.tableView.reloadData()
                            }, withCancel: { (error) in
                                print(error)
                            })
               takeCareOfTopView()
            }
            else {
                displayMessage(title: "Please check all text fields", message: nil, presenter: self)
            }

        

    }
    
    @IBAction func searchExpandButtonDidPress(_ sender : Any){
        takeCareOfTopView()
    }
    
    func takeCareOfTopView(){
        
        if isTopViewExpanded{
            self.topVIewHeightConstraint.constant = 58
            self.isTopViewExpanded = false
            self.searchStack.isHidden = true
            self.view.endEditing(true)
            self.mainLabel.isHidden = false
            let img = UIImage(named: "search")
            self.expandButton.setImage(img, for: .normal)
        }
        else {
            self.topVIewHeightConstraint.constant = 250
            self.isTopViewExpanded = true
            self.searchStack.isHidden = false
            self.mainLabel.isHidden = true
            let img = UIImage(named: "cancel")
            self.expandButton.setImage(img, for: .normal)
            
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let placemark = placemarks?.first{
                    if let location = Location(data: placemark){
                       ref.child("Users").child(self.userId).child("location").setValue(location.getLocationString())
                        self.selfLocation = location
                    }
                }
            })
        }
    }
    
    
    // MARK: UITableViewDataSource , UITableViewDelegate
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let pet = self.pets[indexPath.row]
        let petCell = tableView.dequeueReusableCell(withIdentifier: "petCell") as! PetCell
        petCell.configureCell(pet: pet)
        return petCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = self.pets[indexPath.row]
        assert(pet.ownderId != nil )
        let owner = pet.ownderId
        
        performSegue(withIdentifier: "searchToProfileDisplay", sender: owner)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToProfileDisplay"{
            let ownerId = sender as! String
            let destinationController = segue.destination as! ProfileDisplayVC
            destinationController.profileId = ownerId
        }
    }
    
    
   

}
