import Foundation

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    var city:String
    var languages:String
    var description:String
    var typeuser:String
    var usrfee:String
    var typefee:String
    var avaliability:[String]
    
    init(uid:String, username:String,photoURL:URL,city:String,languages:String,description:String,typeuser:String,usrfee:String,typefee:String,avaliability:[String]) {
    
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
        self.city = city
        self.languages = languages
        self.description = description
        self.typeuser = typeuser
        self.usrfee = usrfee
        self.typefee = typefee
        self.avaliability = avaliability
    }
}

