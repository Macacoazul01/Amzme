import UIKit

class HostListViewCell: UITableViewCell  {
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var Fav: UIImageView!
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var Hours: UILabel!
    @IBOutlet weak var Reject: UIButton!
    @IBOutlet weak var Accept: UIButton!
    @IBOutlet weak var UserText: UILabel!
    @IBOutlet weak var Star1: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star5: UIImageView!
    @IBOutlet weak var AvaliationCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //UserImage.layer.cornerRadius = UserImage.bounds.height / 2
        //UserImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    weak var post:Post?
    
    func set(post:Post) {
        
        self.post = post
        UserName.text = post.author.username
        City.text = post.author.city
        UserText.text = post.author.description
        Star1.alpha = 1
        Star2.alpha = 1
        Star3.alpha = 1
        Star4.alpha = 1
        Star5.alpha = 1
        AvaliationCount.text = "(100)"
        Day.text = post.author.avaliability[0]
        Hours.text = post.author.avaliability[1]
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
        
        UserImage.image = nil
        ImageService.getImage(withURL: post.author.photoURL) { image, url in
            guard let _post = self.post else { return }
            if _post.author.photoURL.absoluteString == url.absoluteString {
                self.UserImage.image = image
            } else {
                print("Not the right image")
            }
            
        }
    }
    @IBAction func RejectClick(_ sender: Any) {
        print("deletou")
    }
    @IBAction func AcceptClick(_ sender: Any) {
        print("aceitou")
    }
    
}
