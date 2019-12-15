import UIKit
import Firebase
import SwiftKeychainWrapper
class SettingsViewController: UITableViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let currentUser = KeychainWrapper.standard.string(forKey: "uid")

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
    }

}
