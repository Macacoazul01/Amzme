import Foundation
import UIKit
import Firebase


class HomeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ProfileButton: UIBarButtonItem!
    var typeposts = UserDefaults.standard.object(forKey: "type") as! String
    var currentusr = UserDefaults.standard.object(forKey: "uid") as! String
    var tableView:UITableView!
    var cellHeights: [IndexPath : CGFloat] = [:]
    var namenib:String!
    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    var refreshControl:UIRefreshControl!
    var seeNewPostsButton:SeeNewPostsButton!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    var lastUploadedPostID:String?
    var postsRef:DatabaseReference {
        return Database.database().reference().child("posts")
    }
    
    var oldPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let lastPost = posts.last
        if lastPost != nil {
            let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    
    var newPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let firstPost = posts.first
        if firstPost != nil {
            let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if typeposts == "3"{
            namenib = "UserListViewCell"
        }
        else {
            namenib = "HostListViewCell"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
        
        let cellNib = UINib(nibName: namenib, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        seeNewPostsButton = SeeNewPostsButton()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -44)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        beginBatchFetch()
        listenForNewPosts()
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopListeningForNewPosts()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BookingSegue", sender: self)
    }
    func toggleSeeNewPostsButton(hidden:Bool) {
        if hidden {
            // hide it
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = -44.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            // show it
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = 12
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func handleRefresh() {
        let value:String
        if typeposts == "3"{
            value = "1"
        }
        else {
            value = "2"
        }
        toggleSeeNewPostsButton(hidden: true)
        
        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            let firstPost = self.posts.first
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != firstPost?.id {
                    if post.typepost  == value && post.id != self.currentusr {
                        tempPosts.insert(post, at: 0)
                    }
                }
            }
            if tempPosts.count > 0 {
                self.posts.insert(contentsOf: tempPosts, at: 0)
                
                let newIndexPaths = (0..<tempPosts.count).map { i in
                    return IndexPath(row: i, section: 0)
                }
                
                self.refreshControl.endRefreshing()
                self.tableView.insertRows(at: newIndexPaths, with: .top)
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
                self.listenForNewPosts()
            }
            else {
                self.toggleSeeNewPostsButton(hidden: true)
            }
            
            
        })
    }
    
    func fetchPosts(completion:@escaping (_ posts:[Post])->()) {
        let value:String
        if typeposts == "3"{
            value = "1"
        }
        else {
            value = "2"
        }
        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            
            let lastPost = self.posts.last
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != lastPost?.id {
                    if post.typepost  == value && post.id != self.currentusr{
                        tempPosts.insert(post, at: 0)
                    }
                }
            }
            
            return completion(tempPosts)
        })
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return posts.count
        case 1:
            return fetchingMore ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if namenib == "HostListViewCell" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HostListViewCell
                cell.set(post: posts[indexPath.row])
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! UserListViewCell
                cell.set(post: posts[indexPath.row])
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                
                self.listenForNewPosts()
            }
        }
    }
    
    var postListenerHandle:UInt?
    
    func listenForNewPosts() {
        
        guard !fetchingMore else { return }
        
        // Avoiding duplicate listeners
        stopListeningForNewPosts()
        
        postListenerHandle = newPostsQuery.observe(.childAdded, with: { snapshot in
            if snapshot.key != self.posts.first?.id,
                let data = snapshot.value as? [String:Any],
                (Post.parse(snapshot.key, data) != nil) {
                
                self.stopListeningForNewPosts()
                
                if snapshot.key == self.lastUploadedPostID {
                    self.handleRefresh()
                    self.lastUploadedPostID = nil
                } else {
                    self.toggleSeeNewPostsButton(hidden: false)
                }
            }
        })
    }
    
    func stopListeningForNewPosts() {
        if let handle = postListenerHandle {
            newPostsQuery.removeObserver(withHandle: handle)
            postListenerHandle = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookingSegue"{
            if let destination = segue.destination as? BookingViewController {
            destination.ref = self.posts[(tableView.indexPathForSelectedRow?.first)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            }
        }
        
        else if let newPostNavBar = segue.destination as? UINavigationController,
            let newPostVC = newPostNavBar.viewControllers[0] as? ProfileViewController {
            newPostVC.delegate = self
        }
    }
}

extension HomeViewController: NewPostVCDelegate {
    func didUploadPost(withID idf: String) {
        self.lastUploadedPostID = idf
        posts = posts.filter { idf == $0.id }
        self.tableView.reloadData()
        beginBatchFetch()
    }
}
