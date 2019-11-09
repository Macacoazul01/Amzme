import UIKit
import Firebase
import Foundation

protocol NewPostVCDelegate {
    func didUploadPost(withID id:String)
}

class ProfileViewController: UIViewController, UITextViewDelegate {
    var selecionada : String?
    var botoes : [String]!
    var typeusr : String!
    var typefee : String!
    let checked = UIImage(named: "checked_checkbox")
    let unchecked = UIImage(named: "unchecked_checkbox")
    var delegate:NewPostVCDelegate?
    
    
    @IBOutlet weak var AddLanguage: UIButton!
    @IBOutlet weak var ProfileLanguages: UITextField!
    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var HomeTownText: UITextField!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var containner2: SWComboxView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    @IBOutlet weak var HostButton: UIButton!
    @IBOutlet weak var ProButton: UIButton!
    @IBOutlet weak var GuestButton: UIButton!
    @IBOutlet weak var SearchCityButton: UIButton!
    @IBOutlet weak var FeeText: UITextField!
    @IBOutlet weak var PerPersonButton: UIButton!
    @IBOutlet weak var DayButton: UIButton!
    @IBOutlet weak var HourButton: UIButton!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    @IBOutlet weak var FullDays: UIStackView!
    @IBOutlet weak var Feetitle: UILabel!
    @IBOutlet weak var PersonTitle: UILabel!
    @IBOutlet weak var DayTitle: UILabel!
    @IBOutlet weak var HourTitle: UILabel!
    @IBOutlet weak var DaysName: UIStackView!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet var ProfView: UIView!
    
    var imagePicker:UIImagePickerController!
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        guard let userProfile = UserService.currentUserProfile else { return }
        UsernameText.text = userProfile.username
        HomeTownText.text = userProfile.city
        DescriptionText.text = userProfile.description
        ProfileLanguages.text = userProfile.languages
        FeeText.text = userProfile.usrfee
        typeusr = userProfile.typeuser
        typefee = userProfile.typefee
        botoes = userProfile.avaliability
        formatbuttons(lista: botoes)
        DescriptionText.layer.borderColor = UIColor(red: 0.1333, green: 0.0941, blue: 0.1569, alpha: 1.0).cgColor
        DescriptionText.layer.borderWidth = 1.0
        DescriptionText.layer.cornerRadius = 5
        if typeusr == "1" {
            GuestButton.setImage(unchecked, for:[])
            HostButton.setImage(checked, for:[])
            ProButton.setImage(unchecked, for:[])
            descHeight.constant = 150
            ProfView.layoutIfNeeded()
        }
        else if typeusr == "2" {
            GuestButton.setImage(unchecked, for:[])
            HostButton.setImage(checked, for:[])
            ProButton.setImage(checked, for:[])
            DescriptionText.height = 150
        }
        else if typeusr == "3" {
            GuestButton.setImage(checked, for:[])
            HostButton.setImage(unchecked, for:[])
            ProButton.setImage(unchecked, for:[])
            FullDays.alpha = 0
            Feetitle.alpha = 0
            PersonTitle.alpha = 0
            DayTitle.alpha = 0
            HourTitle.alpha = 0
            FeeText.alpha = 0
            DaysName.alpha = 0
            PerPersonButton.alpha = 0
            DayButton.alpha = 0
            HourButton.alpha = 0
            descHeight.constant = 200
            ProfView.layoutIfNeeded()
        }
        else{
            GuestButton.setImage(unchecked, for:[])
            HostButton.setImage(unchecked, for:[])
            ProButton.setImage(unchecked, for:[])
            FullDays.alpha = 0
            Feetitle.alpha = 0
            PersonTitle.alpha = 0
            DayTitle.alpha = 0
            HourTitle.alpha = 0
            FeeText.alpha = 0
            DaysName.alpha = 0
            PerPersonButton.alpha = 0
            DayButton.alpha = 0
            HourButton.alpha = 0
            descHeight.constant = 200
            ProfView.layoutIfNeeded()
        }
        
        if typefee == "1" {
            PerPersonButton.setImage(checked, for:[])
            DayButton.setImage(unchecked, for:[])
            HourButton.setImage(unchecked, for:[])
        }
        else if typefee == "2" {
            PerPersonButton.setImage(unchecked, for:[])
            DayButton.setImage(checked, for:[])
            HourButton.setImage(unchecked, for:[])
        }
        else if typefee == "3" {
            PerPersonButton.setImage(unchecked, for:[])
            DayButton.setImage(unchecked, for:[])
            HourButton.setImage(checked, for:[])
        }
        else {
            PerPersonButton.setImage(unchecked, for:[])
            DayButton.setImage(unchecked, for:[])
            HourButton.setImage(unchecked, for:[])
        }
        
        self.profileImageView.image = nil
        ImageService.getImage(withURL: userProfile.photoURL) { image, url in
            if userProfile.photoURL.absoluteString == url.absoluteString {
                self.profileImageView.image = image
            } else {
                print("Not the right image")
            }
            
        }
        
        setupCombox()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func checkBtnClick(_ sender: UIButton) {
        //typefee
        switch sender.tag{
            
        case 100:
            changebuttoncheck(but: HostButton){ success in
                if success {
                    if self.typeusr == "3" {
                        self.GuestButton.setImage(self.unchecked, for:[])
                    }
                    self.typeusr = "1"
                    self.FullDays.alpha = 1
                    self.Feetitle.alpha = 1
                    self.PersonTitle.alpha = 1
                    self.DayTitle.alpha = 1
                    self.HourTitle.alpha = 1
                    self.FeeText.alpha = 1
                    self.DaysName.alpha = 1
                    self.PerPersonButton.alpha = 1
                    self.DayButton.alpha = 1
                    self.HourButton.alpha = 1
                    self.descHeight.constant = 150
                    self.ProfView.layoutIfNeeded()
                } else {
                    self.ProButton.setImage(self.unchecked, for:[])
                    if self.typeusr == "1"{
                        self.typeusr = "0"
                    }
                    
                }
            }
        case 101:
            changebuttoncheck(but: ProButton){ success in
                if success {
                    self.HostButton.setImage(self.checked, for:[])
                    self.GuestButton.setImage(self.unchecked, for:[])
                    self.typeusr = "2"
                    self.FullDays.alpha = 1
                    self.Feetitle.alpha = 1
                    self.PersonTitle.alpha = 1
                    self.DayTitle.alpha = 1
                    self.HourTitle.alpha = 1
                    self.FeeText.alpha = 1
                    self.DaysName.alpha = 1
                    self.PerPersonButton.alpha = 1
                    self.DayButton.alpha = 1
                    self.HourButton.alpha = 1
                    self.descHeight.constant = 150
                    self.ProfView.layoutIfNeeded()
                } else {
                    if self.typeusr == "2"{
                        self.typeusr = "0"
                    }
                }
            }
        case 102:
            changebuttoncheck(but: GuestButton) { success in
                if success {
                    if self.typeusr == "1" || self.typeusr == "2" {
                        self.ProButton.setImage(self.unchecked, for:[])
                        self.HostButton.setImage(self.unchecked, for:[])
                    }
                    self.FullDays.alpha = 0
                    self.Feetitle.alpha = 0
                    self.PersonTitle.alpha = 0
                    self.DayTitle.alpha = 0
                    self.HourTitle.alpha = 0
                    self.FeeText.alpha = 0
                    self.DaysName.alpha = 0
                    self.PerPersonButton.alpha = 0
                    self.DayButton.alpha = 0
                    self.HourButton.alpha = 0
                    self.descHeight.constant = 200
                    self.ProfView.layoutIfNeeded()
                    self.typeusr = "3"
                } else {
                    if self.typeusr == "3"{
                        self.typeusr = "0"
                    }
                }
            }
        case 103:
            changebuttoncheck(but: PerPersonButton){ success in
                if success {
                    self.DayButton.setImage(self.unchecked, for:[])
                    self.HourButton.setImage(self.unchecked, for:[])
                    self.typefee = "1"
                } else {
                    if self.typefee == "1"{
                        self.typefee = "0"
                    }
                }
            }
        case 104:
            changebuttoncheck(but: DayButton) { success in
                if success {
                    self.PerPersonButton.setImage(self.unchecked, for:[])
                    self.HourButton.setImage(self.unchecked, for:[])
                    self.typefee = "2"
                } else {
                    if self.typefee == "2"{
                        self.typefee = "0"
                    }
                }
            }
        case 105:
            changebuttoncheck(but: HourButton) { success in
                if success {
                    self.PerPersonButton.setImage(self.unchecked, for:[])
                    self.DayButton.setImage(self.unchecked, for:[])
                    self.typefee = "3"
                } else {
                    if self.typefee == "3"{
                        self.typefee = "0"
                    }
                }
            }
            
        default: break
            
        }
    }
    @IBAction func AvaliabilityBtnClick(_ sender: UIButton) {
        if let button = self.view.viewWithTag(sender.tag) as? UIButton{
            if button.backgroundColor == nil{
                botoes[sender.tag-1] = "1"
                button.backgroundColor = UIColor(red: 47/255, green: 172/255, blue: 73/255, alpha: 1.0)
            }
            else{
                botoes[sender.tag-1]="0"
                button.backgroundColor = nil
            }
            
        }
        
    }
    
    func changebuttoncheck(but:UIButton,completion: @escaping ((_ success:Bool)->())){
        if but.currentImage == checked{
            but.setImage(unchecked, for:[])
            completion(false)
        }
        else {
            but.setImage(checked, for:[])
            completion(true)
        }
    }
    
    @IBAction func ButtonAddLanguage(_ sender: Any) {
        if selecionada == nil || selecionada == "Select Language" {
            
        }
        else{
            ProfileLanguages.text = ProfileLanguages.text! + " " +  selecionada!.prefix(1)
            selecionada = nil
            containner2.reloadViewWithIndex(0)
      
        }
        
    }
    @IBAction func SaveProfileButton(_ sender: Any) {
        self.saveProfile { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.resetForm()
            }
        }
    }

    
    func saveProfile(completion: @escaping ((_ success:Bool)->())) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userProfile = UserService.currentUserProfile else { return }
        
        let storageRef = Storage.storage().reference().child("user/\(userProfile.uid)")
        storageRef.delete{ error in
            if error != nil {
                print("avisar")
            }
        }
        
        guard let image = profileImageView.image else { return }
        uploadProfileImage(image) { (url) in
            if url != nil {
                ref.child("users/profile/\(userProfile.uid)/photoURL").setValue(url?.absoluteString)
            }
        }
        let userref = ref.child("users/profile/\(userProfile.uid)")
        let userObject = [
            "username": UsernameText.text!,
            "city": HomeTownText.text!,
            "languages": ProfileLanguages.text!,
            "description": DescriptionText.text!,
            "typeuser": typeusr!,
            "usrfee": FeeText.text!,
            "typefee": typefee!,
            "avaliability": botoes!
            ] as [String:Any]
        
        userref.setValue(userObject)
        if typeusr == "1" || typeusr == "2"{
            
            let postRef = ref.child("posts/\(userProfile.uid)")
            //let postRef = ref.child("posts").childByAutoId()

            
            let postObject = [
                "author": [
                    "uid": userProfile.uid,
                    "username": UsernameText.text ?? "Username",
                    "photoURL": userProfile.photoURL.absoluteString,
                    "city": HomeTownText.text ?? "City",
                    "description": DescriptionText.text ?? "",
                    "languages": ProfileLanguages.text ?? "",
                    "usrfee": FeeText.text ?? "Free",
                    "avaliability": botoes!,
                    "typeuser": typeusr ?? "1",
                    "typefee": typefee ?? "3"
                ],
                "timestamp": [".sv":"timestamp"],"typepost": "1"
                ] as [String:Any]
            
            postRef.setValue(postObject, withCompletionBlock: { error, ref in
                if error == nil {
                    self.delegate?.didUploadPost(withID: ref.key!)
                } else {
                    // Handle the error
                }
            })
        }
        completion(true)
        }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error saving your profile", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func setupCombox() {
        //start from 0
        containner2.dataSource = self
        containner2.delegate = self
        containner2.showMaxCount = 4
        containner2.defaultSelectedIndex = 0
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Failed to download url:", error!)
                        return
                    }
                    completion(url)
                }
                
            } else {
                // failed
                completion(nil)
            }
        }
    }

    func formatbuttons(lista:[String]) {
        var i = 0
        let fim = lista.count
        while (i < fim)
        {
            if let button = self.view.viewWithTag(i+1) as? UIButton{
                if lista[i] == "0"{
                   button.backgroundColor = nil
                }
                else{
                    button.backgroundColor = UIColor(red: 47/255, green: 172/255, blue: 73/255, alpha: 1.0)
                }
            }
            i+=1;
        }
    }

    @IBAction func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
   
}

extension ProfileViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["Select Language","🇦🇺 - English","🇧🇷 - Português", "🇪🇸 - Español", "🇩🇪 - Deutsch", "🇨🇳 - Chinese", "🇫🇷 - French"]
        
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }
}

extension ProfileViewController : SWComboxViewDelegate {
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
    }
    
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object) combo \(withCombox)")
        selecionada = object as? String
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
