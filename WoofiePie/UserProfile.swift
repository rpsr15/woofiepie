//
//  UserProfile.swift
//  WoofiePie
//
//  Created by Ravi on 20/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import Foundation
import CoreLocation
class UserProfile : NSObject {
    var userId : String!
    var name : String!
    var location : String!
    var email : String!
    var followers = [String]()
    var following = [String]()
    private var _pets = [Pet]()
    var pets : [Pet]?{
        get{
            if _pets.count == 0 {
                return nil
            }
            else {
            return self._pets
            }
        }
        
    }
    override var description: String{
        return userId+name+" "+location+email
    }
    func updatePets(pets: [Pet]){
        self._pets = pets
    }
    
    // method to add a pet to owner
    func addPet( pet : Pet){
       // var pet = pet
      //  pet.owner = self
        self._pets.append(pet)
    }
    convenience init?(dictionaryData : [String : Any]) {
        
        guard let userId = dictionaryData["userId"] as? String else {return nil}
        
        guard let anEmail = dictionaryData["email"] as? String else {return nil}
        guard let locationName = dictionaryData["location"] as? String else { return nil }
        guard let personName = dictionaryData["name"] as? String else {return nil }
        
      
        
        
        if let pets = dictionaryData["pets"] as? [String : Any]{
           // print("ravi pets found")
            var petList = [Pet]()
            for p in pets{
             //   print(p)
                if let petData = p.value as? [String  : Any]{
               //     print("pet data found")
                    if let pet = Pet(dictionaryData: petData){
                  //      print("pet created")
                   //     print(pet)
                        petList.append(pet)
                    }
                }
                
            }
           
             self.init(userId : userId, name : personName, location: locationName , email:anEmail, pets:petList)
        }
        
        else {
          //  print("ravi pets not found")
             self.init(userId : userId, name : personName, location: locationName , email:anEmail, pets:nil)
        }
        if let followers = dictionaryData["followers"] as? [String : Any] {
          self.followers = Array(followers.keys)
        }
        
        if let following = dictionaryData["following"] as? [String : Any]{
           
             self.following = Array(following.keys)
        }
       
       
    }
    
    
    init(userId : String  , name : String , location : String? , email: String , pets : [Pet]? ){
       self.userId = userId
        self.name = name
        if location != nil{
            self.location = location
        }
        self.email = email
        if let pets = pets {
            self._pets = pets
        }
        
    }
    
    func getDictionary() -> [String : Any]{
       // if pets is nil return without pets
        if let pets = pets{
            return  ["userId":userId , "name":name , "location":location , "email":email , "pets": pets.map { (pet : Pet) -> [String : Any] in
                return pet.getDictionary()
                }]
        }
        else {
            return  ["userId":userId , "name":name , "location":location ?? "" , "email":email ]
        }
        
       
    }
    
    
}


struct Pet {
    var petId : String!
    var name : String!
    var birthDate : String!
    var breed : String!
    var category : String!
    var sex : String!
    var ownderId : String!
    var petImagePath : String!
     init?(dictionaryData : [String : Any]){
        guard let petid = dictionaryData["petid"] as? String  else {
            //print("pet id not found")
            return nil}
       
        guard let birthD = dictionaryData["birthDate"] as? String
            else {
                //print("birthday not found")
                return nil
                 }
        guard let breedName = dictionaryData["breed"] as? String
            else {
                //print("breed not found")
                return nil
        }
        guard let petImageProfilePath = dictionaryData["petImagePath"] as? String else {return nil}
        guard let categoryName = dictionaryData["category"] as? String else {
            
            return nil}
        guard let petName = dictionaryData["name"] as? String else {
            
            return nil}
        guard let gender = dictionaryData["sex"] as? String else {
            
            return nil}
        
        guard let ownerId = dictionaryData["ownerId"] as? String else {
            return nil
        }
        self.petId = petid
        self.name = petName
        self.birthDate = birthD
        self.breed = breedName
        self.category = categoryName
        self.sex = gender
        self.ownderId = ownerId
        self.petImagePath = petImageProfilePath
    }
    
    init(petid: String, name : String, birthDate:String , breed: String, category: String , sex: String, ownerId:String, profileImagePath : String) {
        self.name = name
        self.birthDate = birthDate
        self.breed = breed
        self.category = category
        self.sex = sex
        self.petId = petid
        self.ownderId = ownerId
        self.petImagePath = profileImagePath
       // self.owner = owner
    }
    func getDictionary() -> [String : Any]{
        return  ["petid" :petId, "name": name , "birthDate":birthDate , "breed":breed , "category":category , "sex":sex ,"ownerId":self.ownderId , "petImagePath":self.petImagePath]
        
    }
    func getAge() -> String{
        //date format is ""3/24/17""
       // print(birthDate)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "DD/MM/YY"
        let date = formatter.date(from: birthDate)
      //  print(date)
        
        assert(date != nil)
        return date!.getAge()
    }

    
}


extension Date{
    func getAge() -> String{
        var year = 0
        var month = 0
        let age = NSDate().timeIntervalSince(self)/(60*60*24*365)
        year = Int(age)
        month =   Int(Double(String(format:"%.1f" , age))!*10) - year*10
        return "\(year)years, \(month)months"
    }
}


class Location {
    var country : String
    var state : String
    var city : String
    init?(countryName : String , stateName : String , cityName: String) {
        if (countryName == "") || ((cityName == "")&&(stateName == "")) {
            return nil
        }
        self.country = countryName
        self.state = stateName
        self.city = cityName
    }
    
    func getLocationString() -> String {
        return self.city+","+self.state+","+self.country
    }
    convenience init?(data : CLPlacemark ) {
        let country = data.country
        let state = data.administrativeArea
        let city = data.subAdministrativeArea
        self.init(countryName: country ?? "", stateName: state ?? "", cityName: city ?? "")
    }
    var description : String{
        return "test" + (self.country ) + (self.city ) + (self.state )
    }
}

