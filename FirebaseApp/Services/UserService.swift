import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL),
                let city = dict["city"] as? String,
                let languages = dict["languages"] as? String,
                let description = dict["description"] as? String,
                let typeuser = dict["typeuser"] as? String,
                let usrfee = dict["usrfee"] as? String,
                let typefee = dict["typefee"] as? String,
                let avaliability = dict["avaliability"] as? [String] {
            
                userProfile = UserProfile(uid: snapshot.key, username: username, photoURL: url, city: city, languages: languages, description: description,typeuser:typeuser,usrfee:usrfee,typefee:typefee,avaliability:avaliability)
            }
            
            completion(userProfile)
        })
    }
    
}


