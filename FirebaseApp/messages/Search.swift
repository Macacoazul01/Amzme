import Foundation
import Firebase
import SwiftKeychainWrapper

class Search {
    
    private var _username: String!
    
    private var _photoURL: String!
    
    private var _userKey: String!
    
    private var _userRef: DatabaseReference!
    
    var currentUser = UserDefaults.standard.object(forKey: "uid") as? String
    
    var username: String {
        
        return _username
    }
    
    var photoURL: String {
        
        return _photoURL
    }
    
    var userKey: String{
        
        return _userKey
    }
    
    init(username: String, photoURL: String) {
        
        _username = username
        
        _photoURL = photoURL
    }
    
    init(userKey: String, postData: Dictionary<String, AnyObject>) {
        
        _userKey = userKey
        
        if let username = postData["username"] as? String {
            
            _username = username
        }
        
        if let photoURL = postData["photoURL"] as? String {
            
            _photoURL = photoURL
        }
        
        _userRef = Database.database().reference().child("messages").child(_userKey)
    }
}
