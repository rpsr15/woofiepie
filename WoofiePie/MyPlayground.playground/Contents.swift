import Foundation
let birthDate = "17/13/17"
let formatter = DateFormatter()
formatter.dateFormat = "MM/DD/YY"
formatter.dateStyle = .short
let date = formatter.date(from: birthDate)

