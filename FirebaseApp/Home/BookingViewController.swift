//
//  BookingViewController.swift
//  FirebaseApp
//
//  Created by Adm on 19/10/19.
//  Copyright © 2019 Robert Canton. All rights reserved.
//

import UIKit
import Firebase



class BookingViewController: UIViewController {
    var ref:Post?
    var botoes : [String]!
    var refdate: Date!
    var delegate:NewPostVCDelegate?
    @IBOutlet weak var HostImage: UIImageView!
    @IBOutlet weak var HostName: UILabel!
    @IBOutlet weak var HostGrad: UIImageView!
    @IBOutlet weak var HostPost: UILabel!
    @IBOutlet weak var WeekDate: UILabel!
    @IBOutlet weak var ObservationText: UITextField!
    @IBOutlet weak var GuestCount: SWComboxView!
    @IBOutlet weak var Sumcount: UILabel!
    @IBOutlet weak var BookButton: UIButton!
    @IBOutlet weak var MessageButton: UIBarButtonItem!
    @IBOutlet weak var LeftArrow: UIButton!
    @IBOutlet weak var RightArrow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupCombox()
        HostName.text = ref!.author.username
        HostPost.text = ref!.author.description
        Sumcount.text = ref!.author.usrfee
        botoes = ref!.author.avaliability
        formatbuttons(lista: botoes)
        self.HostImage.image = nil
        ImageService.getImage(withURL: ref!.author.photoURL) { image, url in
            if self.ref!.author.photoURL.absoluteString == url.absoluteString {
                self.HostImage.image = image
            } else {
                print("Not the right image")
            }
            
        }
        var langs = ref!.author.languages.replacingOccurrences(of: " ", with: "")
        let lenlang = langs.count
        var i = 1
        while i <= lenlang {
            if let theLabel = self.view.viewWithTag(i+100) as? UILabel {
                self.view.viewWithTag(i+100)?.alpha = 1
                theLabel.text = String(langs.first!)
                langs.removeFirst(1)
            }
            i = i + 1
        }
        refdate = Date().startOfWeek
        formatweekdays(SetDate:refdate)
        LeftArrow.isEnabled = false
        // Do any additional setup after loading the view.
    }
    func formatbuttons(lista:[String]) {
        var i = 0
        let fim = lista.count
        while (i < fim)
        {
            if let button = self.view.viewWithTag(i+1) as? UIButton{
                if lista[i] == "0"{
                   button.backgroundColor = nil
                   button.isEnabled = false
                    button.alpha = 0.5
                }
                //else{
                    //button.backgroundColor = UIColor(red: 47/255, green: 172/255, blue: 73/255, alpha: 1.0)
                //}
            }
            i+=1;
        }
    }
    func setupCombox() {
        //start from 0
        GuestCount.dataSource = self
        GuestCount.delegate = self
        GuestCount.showMaxCount = 4
        GuestCount.defaultSelectedIndex = 0
    }
    func formatweekdays(SetDate:Date){
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yy"
        var dateref = SetDate.startOfWeek!
        self.WeekDate.text = dateFormatterPrint.string(from: dateref) + " to " + dateFormatterPrint.string(from: SetDate.endOfWeek!)
        var i = 0
        dateFormatterPrint.dateFormat = "dd/MM"
        while (i < 7)
        {
            if let theLabel = self.view.viewWithTag(i+200) as? UILabel {
                theLabel.text = dateFormatterPrint.string(from: dateref)
            }
            dateref = Calendar.current.date(byAdding: .day, value: 1, to: dateref)!
            i+=1;
        }
        
    }
    
    @IBAction func LeftClick(_ sender: Any) {
        refdate = Calendar.current.date(byAdding: .day, value: -7, to: refdate)!
        formatweekdays(SetDate: refdate)
        if refdate == Date().startOfWeek{
            LeftArrow.isEnabled = false
        }
    }
    @IBAction func RightClick(_ sender: Any) {
        refdate = Calendar.current.date(byAdding: .day, value: 7, to: refdate)!
        formatweekdays(SetDate: refdate)
        LeftArrow.isEnabled = true
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
    
    @IBAction func BookingClick(_ sender: Any) {
        var refp: DatabaseReference!
        refp = Database.database().reference()
        guard let userProfile = UserService.currentUserProfile else { return }
        let postRef = refp.child("posts").childByAutoId()

        
        let postObject = [
            "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString,
                "city": userProfile.city,
                "description": ObservationText.text!,
                "languages": userProfile.languages,
                "usrfee": Sumcount.text! ,
                "avaliability": botoes!,
                "typeuser": "3",
                "typefee": ref?.author.typefee ?? "3"
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
        //ref?.author.uid
        //ref?.author.uid
    }
    func isNumeric(a: String) -> Bool {
      return Double(a) != nil
    }
    
}
extension BookingViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }
}

extension BookingViewController : SWComboxViewDelegate {
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
    }
    
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        let tax:String = ref?.author.usrfee ?? "0"
        let texto:String = object as! String
        if isNumeric(a: tax){
            let taxcorrect:Int = Int(tax) ?? 0
            let textcorrect:Int = Int(texto) ?? 0
            Sumcount.text = String(taxcorrect * textcorrect)
        }
        else{
            Sumcount.text = "Free"
        }
        
       
        //print("index - \(index) selected - \(object) combo \(withCombox)")
        //selecionada = object as? String
    }
}
