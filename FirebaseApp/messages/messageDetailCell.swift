import UIKit
import Firebase
import SwiftKeychainWrapper

class messageDetailCell: UITableViewCell {
    
    @IBOutlet weak var recipientImg: UIImageView!
    
    @IBOutlet weak var recipientName: UILabel!
    
    @IBOutlet weak var chatPreview: UILabel!
    
    var messageDetail: MessageDetail!
    
    var userPostKey: DatabaseReference!
    
    let currentUser = UserDefaults.standard.object(forKey: "uid") as? String

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(messageDetail: MessageDetail) {
        
        self.messageDetail = messageDetail
        
        let recipientData = Database.database().reference().child("users/profile").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let photoURL = data["photoURL"]
            
            self.chatPreview.text = messageDetail.lastmessage
            
            self.recipientName.text = data["username"] as? String
            
            let ref = Storage.storage().reference(forURL: photoURL! as! String)
            ref.getData(maxSize: 100000, completion: { (data, error) in
                
                if error != nil {
                    print("could not load image")
                } else {
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            self.recipientImg.image = img
                        }
                    }
                }
            })
        })
    }
}
















