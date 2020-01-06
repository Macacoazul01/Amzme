import UIKit
import Firebase

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
        let title = "Are you sure you want to log out?"
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
               try Auth.auth().signOut()
               UserDefaults.standard.set(false, forKey: "logged")
               Database.database().reference().removeAllObservers()
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let conroller = UINavigationController(rootViewController: Login())
               appDelegate.window?.rootViewController = conroller
            } catch {
                debugPrint("Error Occurred while logging out!")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
