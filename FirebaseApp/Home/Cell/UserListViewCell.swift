import UIKit

class UserListViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var FavFlag: UIImageView!
    @IBOutlet weak var AvalCount: UILabel!
    @IBOutlet weak var ProImage: UIImageView!
    @IBOutlet weak var Star1: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star5: UIImageView!
    @IBOutlet weak var CityText: UILabel!
    @IBOutlet weak var PriceText: UILabel!
    @IBOutlet weak var Monday: UIButton!
    @IBOutlet weak var Tuesday: UIButton!
    @IBOutlet weak var Wednesday: UIButton!
    @IBOutlet weak var Thursday: UIButton!
    @IBOutlet weak var Friday: UIButton!
    @IBOutlet weak var Saturday: UIButton!
    @IBOutlet weak var Sunday: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //FavFlag.alpha = 0
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    weak var post:Post?
    
    func set(post:Post) {
        
        self.post = post
        usernameLabel.text = post.author.username
        CityText.text = post.author.city
        PriceText.text = post.author.usrfee + " per " + decodefee(i: post.author.typefee)
        Star1.alpha = 1
        Star2.alpha = 1
        Star3.alpha = 1
        Star4.alpha = 1
        Star5.alpha = 1
        AvalCount.text = "(100)"
        var langs = post.author.languages.replacingOccurrences(of: " ", with: "")
        let lenlang = langs.count
        var i = 1
        while i <= lenlang {
            if let theLabel = self.viewWithTag(i) as? UILabel {
                self.viewWithTag(i)?.alpha = 1
                theLabel.text = String(langs.first!)
                langs.removeFirst(1)
            }
            i = i + 1
        }
        if Int(post.author.typeuser)! == 2 {
            ProImage.alpha = 1
        }
        find1(list: post.author.avaliability)
        profileImageView.image = nil
        ImageService.getImage(withURL: post.author.photoURL) { image, url in
            guard let _post = self.post else { return }
            if _post.author.photoURL.absoluteString == url.absoluteString {
                self.profileImageView.image = image
            } else {
                print("Not the right image")
            }
            
        }
    }
    func find1(list:[String]){
        var i = 1
        while i < 8 {
            let fim = 8*i
            var c = fim - 8
            if let thebutton = self.viewWithTag(i+10) as? UIButton {
                thebutton.isEnabled = false
                while c < fim {
                    if list[c] == "1"{
                        //thebutton.titleLabel?.textColor = UIColor.systemBlue
                        thebutton.backgroundColor = UIColor(red: 47/255, green: 172/255, blue: 73/255, alpha: 1.0)
                        thebutton.isEnabled = true
                        break
                    }
                    c = c + 1
                }
                
            }
            i = i + 1
        }
        
    }
    func decodefee(i:String) -> String{
        if i == "1"{
            return "Person"
        }
        else if i == "2"{
            return "Day"
        }
        else if i == "3"{
            return "Hour"
        }
        else { return "" }
    }
    
}
