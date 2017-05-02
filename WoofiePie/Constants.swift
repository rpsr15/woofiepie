//
//  Constants.swift
//  WoofiePie
//
//  Created by Ravi on 06/03/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let storage = FIRStorage.storage()
let storageRef = storage.reference()
var iskeyboardup = false

let APP_BLUE_COLOR = UIColor(red: 72.0/255.0, green: 162.0/255.0, blue: 122.0/255.0, alpha: 1.0)
let FEMALE_PINK = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
let MALE_BLUE = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let APP_SAFFRON_COLOR = UIColor(red: 253.0/255.0, green: 149.0/255.0, blue: 107.0/255.0, alpha: 1.0)


 var ref : FIRDatabaseReference =  FIRDatabase.database().reference()


func isUserNameUnique(userName : String, completion : @escaping (_ isUnique : Bool) -> () ) {
    ref.child("users").observe(.value, with: { (snapshot) in
        for c in snapshot.children.allObjects as! [FIRDataSnapshot]{
           
            if (c.key == userName){
              completion(false)
            }
        
        }
    }) { (error) in
        print(error)
    }
    completion(true)

}



func displayMessage(title: String? , message: String? , presenter: UIViewController){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        alertController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(okAction)
    presenter.present(alertController, animated: true, completion: nil)
    
}
func registerForKeyBoardNotification(sender : Any , selector : Selector){
    NotificationCenter.default.addObserver(sender, selector: selector, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(sender, selector: selector, name: .UIKeyboardWillHide, object: nil)
}

func deRegisterForKeyBoardNotification(sender : Any){
    NotificationCenter.default.removeObserver(sender)
}

enum AnimalType : String{
    case dog = "Dog"
//    case cat = "Cat"
//    case horse = "Horse"
//    case bird = "Bird"
    
    
    static let allVaues : [String] = [dog.rawValue]
}

let breeds = ["Airedale Terrier",
              "Affenpinscher",
              "Afghan Hound",
              "Akita",
              "Alaskan Malamute",
              "American English Coonhound",
              "American Eskimo Dog (Miniature)",
              "American Eskimo Dog (Standard)",
              "American Eskimo Dog (Toy)",
              "American Foxhound",
              "American Hairless Terrier",
              "American Staffordshire Terrier",
              "American Water Spaniel",
              "Anatolian Shepherd Dog",
              "Australian Cattle Dog",
              "Australian Shepherd",
              "Australian Terrier",
              "Azawakh",
              "Basenji",
              "Basset Hound",
              "Beagle",
              "Bearded Collie",
              "Beauceron",
              "Bedlington Terrier",
              "Belgian Malinois",
              "Belgian Sheepdog",
              "Belgian Tervuren",
              "Bergamasco",
              "Berger Picard",
              "Bernese Mountain Dog",
              "Bichon Frisé",
              "Black and Tan Coonhound",
              "Black Russian Terrier",
              "Bloodhound",
              "Bluetick Coonhound",
              "Boerboel",
              "Border Collie",
              "Border Terrier",
              "Borzoi",
              "Boston Terrier",
              "Bouvier des Flandres",
              "Boxer",
              "Boykin Spaniel",
              "Briard",
              "Brittany",
              "Brussels Griffon",
              "Bull Terrier",
              "Bull Terrier (Miniature)",
              "Bulldog",
              "Bullmastiff",
              "Clumber Spaniel",
              "Cairn Terrier",
              "Canaan Dog",
              "Cane Corso",
              "Cardigan Welsh Corgi",
              "Cavalier King Charles Spaniel",
              "Cesky Terrier",
              "Chesapeake Bay Retriever",
              "Chihuahua",
              "Chinese Crested Dog",
              "Chinese Shar Pei",
              "Chinook",
              "Chow Chow",
              "Cirneco dell'Etna",
              "Cocker Spaniel",
              "Collie",
              "Coton de Tulear",
              "Curly-Coated Retriever",
              "Dogue de Bordeaux",
              "Dachshund",
              "Dalmatian",
              "Dandie Dinmont Terrier",
              "Doberman Pinscher",
              "English Cocker Spaniel",
              "English Foxhound",
              "English Setter",
              "English Springer Spaniel",
              "English Toy Spaniel",
              "Entlebucher Mountain Dog",
              "Field Spaniel",
              "Finnish Lapphund",
              "Finnish Spitz",
              "Flat-Coated Retriever",
              "French Bulldog",
              "German Pinscher",
              "German Shepherd Dog",
              "German Shorthaired Pointer",
              "German Wirehaired Pointer",
              "Giant Schnauzer",
              "Glen of Imaal Terrier",
              "Golden Retriever",
              "Gordon Setter",
              "Great Dane",
              "Great Pyrenees",
              "Greater Swiss Mountain Dog",
              "Greyhound",
              "Harrier",
              "Havanese",
              "Irish Terrier",
              "Ibizan Hound",
              "Icelandic Sheepdog",
              "Irish Red and White Setter",
              "Irish Setter",
              "Irish Water Spaniel",
              "Irish Wolfhound",
              "Italian Greyhound",
              "Japanese Chin",
              "Keeshond",
              "Kerry Blue Terrier",
              "Komondor",
              "Kuvasz",
              "Labrador Retriever",
              "Lagotto Romagnolo",
              "Lakeland Terrier",
              "Leonberger",
              "Lhasa Apso",
              "Löwchen",
              "Miniature Schnauzer puppy",
              "Maltese",
              "Manchester Terrier",
              "Mastiff",
              "Miniature American Shepherd",
              "Miniature Bull Terrier",
              "Miniature Pinscher",
              "Miniature Schnauzer",
              "Nova Scotia Duck-Tolling Retriever",
              "Neapolitan Mastiff",
              "Newfoundland",
              "Norfolk Terrier",
              "Norwegian Buhund",
              "Norwegian Elkhound",
              "Norwegian Lundehund",
              "Norwich Terrier",
              "Old English Sheepdog",
              "Otterhound",
              "Pharaoh Hound",
              "Papillon",
              "Parson Russell Terrier",
              "Pekingese",
              "Pembroke Welsh Corgi",
              "Petit Basset Griffon Vendéen",
              "Plott",
              "Pointer",
              "Polish Lowland Sheepdog",
              "Pomeranian",
              "Poodle",
              "Portuguese Podengo Pequeno",
              "Portuguese Water Dog",
              "Pug",
              "Puli",
              "Pumi",
              "Pyrenean Shepherd",
              "Rat Terrier",
              "Redbone Coonhound",
              "Rhodesian Ridgeback",
              "Rottweiler",
              "Russell Terrier",
              "St. Bernard",
              "Saluki",
              "Samoyed",
              "Schipperke",
              "Scottish Deerhound",
              "Scottish Terrier",
              "Sealyham Terrier",
              "Shetland Sheepdog",
              "Shiba Inu",
              "Shih Tzu",
              "Siberian Husky",
              "Silky Terrier",
              "Skye Terrier",
              "Sloughi",
              "Smooth Fox Terrier",
              "Soft-Coated Wheaten Terrier",
              "Spanish Water Dog",
              "Spinone Italiano",
              "Staffordshire Bull Terrier",
              "Standard Schnauzer",
              "Sussex Spaniel",
              "Swedish Vallhund",
              "Tibetan Mastiff",
              "Tibetan Spaniel",
              "Tibetan Terrier",
              "Toy Fox Terrier",
              "Treeing Walker Coonhound",
              "Vizsla",
              "West Highland White Terrier",
              "Weimaraner",
              "Welsh Springer Spaniel",
              "Welsh Terrier",
              "Whippet",
              "Wire Fox Terrier",
              "Wirehaired Pointing Griffon",
              "Wirehaired Vizsla",
              "Xoloitzcuintli",
              "Yorkshire Terrier",]

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


func uploadImage(image: UIImage, imageName: String , directory : String , completion: @escaping (_ Result : Bool)->()){
    let ref = storageRef.child(directory).child(imageName)
      guard let pngdata = UIImagePNGRepresentation(image) else {return }
    ref.put(pngdata, metadata: nil) { (data, error) in
        if let error = error {
            print("error uploading data \(error)")
            completion(false)
            return
        }
        if let _ = data {
            completion(true)
        }
    }
}




func cacheImage(image : UIImage, imageName : String){
    
    DispatchQueue.global().async {
        if let data = UIImagePNGRepresentation(image) {
            if let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first{
                let file = (directory as NSString).appendingPathComponent(imageName)
                let pathURl = URL(fileURLWithPath:file)
                do {
                    try data.write(to: pathURl)
                     print("saved image in cache \(imageName)")
                }
                catch{
                    print(error)
                }
                
            }
        }
    }
}
func findImageInCache(with name : String) -> Data?{
    
    
    if let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first{
        let file = (directory as NSString).appendingPathComponent(name)
        let pathURL = URL(fileURLWithPath: file)
        do {
            let data = try Data(contentsOf: pathURL)
            print("found image in cache \(name)")
          return data
        }
        catch{
            print(error)
            return nil
        }
    }
    return nil
}


