import Foundation


class Post {
    var id:String
    var author:UserProfile
    var createdAt:Date
    var typepost:String
    
    
    init(id:String, author:UserProfile,timestamp:Double,typepost:String) {
        self.id = id
        self.author = author
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        self.typepost = typepost

    }
    
    static func parse(_ key:String, _ data:[String:Any]) -> Post? {
        
        if let author = data["author"] as? [String:Any],
            let uid = author["uid"] as? String,
            let username = author["username"] as? String,
            let photoURL = author["photoURL"] as? String,
            let city = author["city"] as? String,
            let languages = author["languages"] as? String,
            let description = author["description"] as? String,
            let typeuser = author["typeuser"] as? String,
            let url = URL(string:photoURL),
            let usrfee = author["usrfee"] as? String,
            let typefee = author["typefee"] as? String,
            let avaliability = author["avaliability"] as? [String],
            let timestamp = data["timestamp"] as? Double,
            let typepost = data["typepost"] as? String{

            let userProfile = UserProfile(uid: uid, username: username, photoURL: url,city:city,languages:languages,description:description, typeuser: typeuser, usrfee: usrfee, typefee: typefee, avaliability:avaliability)
            return Post(id: key, author: userProfile, timestamp:timestamp,typepost:typepost)
            
        }
        
        return nil
    }
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}



