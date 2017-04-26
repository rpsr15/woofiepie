//
//  ProfileVC.swift
//  WoofiePie
//
//  Created by Ravi on 06/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class ProfileVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UIGestureRecognizerDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate , CLLocationManagerDelegate{
    // MARK: IBOutlets
    @IBOutlet weak var userProfileHolder : ProfileImageHolder!
    @IBOutlet weak var userName : UILabel!
    @IBOutlet weak var locationName : UILabel!
    @IBOutlet weak var petList : UITableView!
    @IBOutlet weak var followersLabel : UILabel!
    @IBOutlet weak var followingLabel : UILabel!
    var userId: String!
    private var userProfile : UserProfile?
    private var locationManager : CLLocationManager?
    // MARK: IBActions
    
    
    private var pets = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userId = UserDefaults.standard.value(forKey: "uid") as! String
        
        self.downloadProfilePhoto(for: self.userId)
        //setup gesture recognizers
        
        let imageChangetapRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeUserImage(sender:)))
        imageChangetapRecognizer.delegate = self
        self.userProfileHolder.addGestureRecognizer(imageChangetapRecognizer)
        
        
        
        let nameTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeName(sender:)))
        nameTappedRecognizer.delegate = self
            self.userName.addGestureRecognizer(nameTappedRecognizer)
        self.userName.isUserInteractionEnabled = true
        
        let locationTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateLocation(sender:)))
        locationTappedRecognizer.delegate = self
        self.locationName.isUserInteractionEnabled = true
        locationName.addGestureRecognizer(locationTappedRecognizer)
        
        let followersTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(followersLabelTapped(sender:)))
        followersTappedRecognizer.delegate = self
        followersLabel.isUserInteractionEnabled = true
        followingLabel.isUserInteractionEnabled = true
            self.followersLabel.addGestureRecognizer(followersTappedRecognizer)
        
        
        let followingTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped(sender:)))
        followersTappedRecognizer.delegate = self
        self.followingLabel.addGestureRecognizer(followingTappedRecognizer)
        
        //load names
        if let userNameText = UserDefaults.standard.value(forKey: "userName") as? String{
            self.userName.text = userNameText
        }
        if let location = UserDefaults.standard.value(forKey: "location") as? String{
            self.locationName.text = location
        }
        else {
            locationName.text = "Location Not Provided"
        }
        //TODO: set the saved progile image
        petList.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        getUserDetails(userId: self.userId)
       
        
        
        
    }
    
    func followingLabelTapped(sender: Any){
        
        let type = ProfileListType.FollowingList
        performSegue(withIdentifier: "followerOrFollowingVC", sender: type)
    }
    
    func followersLabelTapped(sender: Any){
    
        let type = ProfileListType.FollowersList
        performSegue(withIdentifier: "followerOrFollowingVC", sender: type)
    }
    
    func changeUserImage(sender : Any){
        print(#function)
        //TODO: update images
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionView = UIAlertController(title: "Update Image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        let selectPhoto = UIAlertAction(title: "Image Gallery", style: .default) { (action) in
            //select photo from library
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            //take photo
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        actionView.addAction(selectPhoto)
        actionView.addAction(takePhoto)
        actionView.addAction(cancelAction)
       
        self.present(actionView, animated: true, completion: nil)
        
        
    }
    func updateName(name : String){
        ref.child("Users").child(self.userId).child("name").setValue(name)
    }
    
    func changeName(sender: Any){
     
        let alertController = UIAlertController(title: "Update Name", message: nil, preferredStyle: .alert)
      
        alertController.addTextField { (textfield) in
            
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            //upate
            if let newName = alertController.textFields?.first?.text{
                self.updateName(name: newName)
            }
           
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
       
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
           self.present(alertController, animated: true, completion: nil)
    }
    
    func updateLocation(sender : Any){
        print(#function)
        
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = 5000.0
        locationManager?.requestLocation()
        
    }
    
    
    
    
    
    func getUserDetails(userId : String){
        
        
        ref.child("Users").child(userId).observe(.value, with: { (snapshot) in
            if  let userData = snapshot.value as? [String : Any]{
                if let person = UserProfile(dictionaryData: userData){
                    
                    self.userProfile = person
                    
                    
                    if let allPets = person.pets{
                        self.pets = allPets
                    }
                    self.petList.reloadData()
                    DispatchQueue.main.async {
                        //updateui
                         let followerCount = person.followers.count
                        print(followerCount)
                        if followerCount > 0{
                        
                            self.followersLabel.text = "\(followerCount)"
                        }
                        let followingCount = person.following.count
                        if followingCount > 0{
                            self.followingLabel.text = "\(followingCount)"
                        }
                        self.userName.text = person.name
                        if person.location != "" {
                            self.locationName.text = person.location
                        }
                        else {
                            self.locationName.text = "Location Not Provided"
                        }
                    }
                }
                
                
            }
        })
        
    }
    // MARK: UIImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //TODO: setimage to button background
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if let compressedImage = image.resized(toWidth: 80.0){
              self.userProfileHolder.profileImage = compressedImage
                // upload this image
                
                self.uploadImage(fileName: self.userId, image: compressedImage)
                
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(fileName: String, image : UIImage){
        cacheImage(image: image, imageName: self.userId)
        let ref = storageRef.child("UserImages").child(fileName)
        guard let pngdata = UIImagePNGRepresentation(image) else {return }
        ref.put(pngdata, metadata: nil) { (data, error) in
            if let error = error {
                print("error uploading data \(error)")
                return
            }
        }
    }
    
    func downloadProfilePhoto(for user: String){
       var imageset = false
        if let imageData = findImageInCache(with: user){
            if let image = UIImage(data: imageData){
                DispatchQueue.main.async {
                    self.userProfileHolder.profileImage = image
                    imageset = true
                }
            }
            
        }
       
    let ref = storageRef.child("UserImages").child(user)
        ref.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("error occurred downloading image \(error)")
                return
            }
            if let data = data {
                DispatchQueue.global().async {
                    if let image = UIImage(data: data){
                        if !imageset{
                            self.userProfileHolder.profileImage = image
                        }
                        cacheImage(image: image, imageName: self.userId)
                    }
                }
            }
            
        }
        
    }
    
    
    // MARK: UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "petCell") as! PetCell
        cell.alpha = 0.5
        let pet = pets[indexPath.row]
        cell.configureCell(pet: pet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
        let pet = self.pets[indexPath.row]
            confirmDeletePet(pet: pet)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: move to edit window
        let pet = self.pets[indexPath.row]
        performSegue(withIdentifier: "editPet", sender: pet )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPet"{
        
        let destination = segue.destination as! AddAPetVC
            destination.mode = .EditPet
            destination.currentPet = sender as? Pet
        }
        
        if segue.identifier == "followerOrFollowingVC"{
        let destination = segue.destination as! ProfileList
            destination.type = sender as! ProfileListType
            destination.delegate = self
        }
    }
    // MARK: LocationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let placemark = placemarks?.first{
                    if let location = Location(data: placemark){
                        ref.child("Users").child(self.userId).child("location").setValue(location.getLocationString())
                        
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error getting location \(error)")
    }
    
    
    func confirmDeletePet(pet : Pet){
        let actionController = UIAlertController(title: "Confirm Delete?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            //
            ref.child("Users").child(self.userId).child("pets").child(pet.petId).setValue(nil)
            self.petList.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        
        actionController.addAction(deleteAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    

  

}


