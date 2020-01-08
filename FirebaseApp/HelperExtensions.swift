import UIKit
//import Alamofire
func lineDraw(viewLi:UIView)
{
        let border = CALayer()
        let width = CGFloat(1.0)
    border.borderColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: viewLi.frame.size.height - width, width:  viewLi.frame.size.width, height: viewLi.frame.size.height)
        border.borderWidth = width
        viewLi.layer.addSublayer(border)
        viewLi.layer.masksToBounds = true
}
extension Date
{
    func calenderTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        } else if months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        } else if days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
        }
    }
    
}
extension Date {
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
extension UIButton {
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
}

extension UIView {
    
    /**
     Adds a vertical gradient layer with two **UIColors** to the **UIView**.
     - Parameter topColor: The top **UIColor**.
     - Parameter bottomColor: The bottom **UIColor**.
     */
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
//MARK: Visual Constraints
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func center_X(item: UIView) {
        center_X(item: item, constant: 0)
    }
    
    func center_X(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView) {
        center_Y(item: item, constant: 0)
    }
    
    func dataForViewAsImage() -> Data?{
        let size = frame.size
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let i = UIGraphicsGetImageFromCurrentImageContext(),
            let data = i.jpegData(compressionQuality: 1.0)
            else {return nil}
        UIGraphicsEndImageContext()
        
        return data
    }
}


//MARK: Colors Used
extension UIColor {
    
    //MARK: function
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    //MARK: Colors
    static let lighterBlack = UIColor(r: 234, g: 234, b: 234)
    static let textfiled = UIColor(r: 250, g: 250, b: 250)
    static let blueInstagram = UIColor(r: 69, g: 142, b: 255)
    static let blueInstagramLighter = UIColor(r: 69, g: 142, b: 195)
    static let blueButton = UIColor(r: 80, g: 104, b: 246)
    static let buttonUnselected = UIColor(white: 0, alpha: 0.25)
    static let shareBackground = UIColor(r: 240, g: 240, b: 240)
    static let searchBackground = UIColor(r: 230, g: 230, b: 230)
    static let seperator = UIColor(white: 0, alpha: 0.50)
    static let highlightedButton = UIColor(r: 17, g: 154, b: 237)
    static let save = UIColor(white: 0, alpha: 0.3)
}

//MARK: Image Extensions
//extension UIImageView {
    //func loadImage(_ url: String, completion: (() -> Void)? = nil) {
        //if let image = cache.object(forKey: url as AnyObject) {
            //self.image = image
           // return
        //}
        //Alamofire.request(url).responseData { response in
            //if let data = response.data {
               // let image = UIImage(data: data)
               // DispatchQueue.main.async {
                //    self.image = image
                 //   if let image = image {
                  //       cache.setObject(image, forKey: url as AnyObject)
                   // }
                  //  completion?()
                //}
            //}
       // }
    //}
//}





