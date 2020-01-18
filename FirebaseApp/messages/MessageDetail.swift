import Foundation
import Firebase


class MessageDetail {
    
    private var _recipient: String!
    
    //private var _recipName: String!
    
    private var _messageKey: String!
    
    private var _lastmessage: String!
    
    private var _messageRef: DatabaseReference!
    
    var currentUser = UserDefaults.standard.object(forKey: "uid") as? String
    
    var recipient: String {
        
        return _recipient
    }
    
    //var recipName: String {
        
       // return _recipName
    //}
    
    var messageKey: String {
        
        return _messageKey
    }
    
    var lastmessage: String {
        
        return _lastmessage
    }
    
    var messageRef: DatabaseReference {
        
        return _messageRef
    }
    
    init(recipient: String) {
        
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            
            _recipient = recipient
            
            _lastmessage = messageData["lastmessage"] as? String
        }
        
        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
    }
}

















