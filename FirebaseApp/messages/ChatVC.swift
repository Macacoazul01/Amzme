import UIKit
import Firebase
import SwiftKeychainWrapper

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var messageDetail = [MessageDetail]()
    var filteredData = [MessageDetail]()
    
    var isSearching = false
    var detail: MessageDetail!
    var userProfile:UserProfile!
    
    var currentUser: String!
    
    var recipient: String!
    
    var messageId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = KeychainWrapper.standard.string(forKey: "uid")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        Database.database().reference().child("users/profile").child(currentUser!).child("messages").observe(.value, with: { (snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.messageDetail.removeAll()
                
                for data in snapshot {
                    
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
        
            self.tableView.reloadData()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageVC {
            
            destinationViewController.recipient = recipient
            
            destinationViewController.messageId = messageId
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }else {
            
            return messageDetail.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData: MessageDetail!
        
        if isSearching {
            messageData = filteredData[indexPath.row]
            
        } else {
            messageData = messageDetail[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? messageDetailCell {
            
            cell.configureCell(messageDetail: messageData)
            
            return cell
        } else {
        
            return messageDetailCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipient = messageDetail[indexPath.row].recipient
        
        messageId = messageDetail[indexPath.row].messageRef.key
        
        performSegue(withIdentifier: "toMessages", sender: nil)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            
            view.endEditing(true)
            
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            filteredData = messageDetail.filter({ $0.recipient.lowercased().contains(searchText.lowercased()) })
            
            tableView.reloadData()
        }
    }
    @IBAction func signOut(_ sender: AnyObject) {
        
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
        dismiss(animated: true, completion: nil)
    }
}
















