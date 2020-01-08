import UIKit
import Firebase
enum AlertMessages: String {
    case registrationFailed = "User registration failed."
    case registrationSucceeded = "User account has been created."
    case loginFailed = "Provied credentials are invalid."
    case sendResetFailed = "No accounts found for this email address."
    case sendResetSuccess = "Reset link successfully sent."
    case postShareFailed = "Error occured whle sharing your post."
}


func createErrorAlert(message: AlertMessages) -> UIAlertController{
    let alert = UIAlertController(title: "Aw, Snap!", message: message.rawValue, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    return alert
}


func createSuccessAlert(message: AlertMessages) -> UIAlertController{
    let alert = UIAlertController(title: "Success!", message: message.rawValue, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    return alert
}

func createSettingsAlertController(title: String, message: String) -> UIAlertController {

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
     UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
    }

    alertController.addAction(cancelAction)
    alertController.addAction(settingsAction)
    return alertController

}
