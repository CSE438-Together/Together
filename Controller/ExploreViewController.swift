//
//  ExploreViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var message: MessageLabel!
    
    private var refreshControl = UIRefreshControl()
    private var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.exploreTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private var profilePhotoCache: [UIImage?] = []
    private let searchController = UISearchController()
    private let defaultImage = UIImage(systemName: "person")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let purpleToPink = CAGradientLayer()
        purpleToPink.frame = tabBarController!.tabBar.bounds
        purpleToPink.colors = [UIColor(named: "bgPurple")!.cgColor, UIColor(named: "bgPink")!.cgColor]
        purpleToPink.locations = [0, 1]
        purpleToPink.startPoint = CGPoint(x: 1.0, y: 0.0)
        purpleToPink.endPoint = CGPoint(x: 0.0, y: 0.0)
        tabBarController!.tabBar.layer.insertSublayer(purpleToPink, at: 0)
        
//        let layer = CAGradientLayer()
//        layer.frame = (navigationController?.navigationBar.bounds)!
//        layer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
//        self.navigationController?.navigationBar.layer.insertSublayer(layer, at: 0)
//        self.navigationController?.navigationBar.setBackgroundImage(GradientColor.image(fromLayer: layer), for: .default)
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "bgYellow")
        
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        setupTableView()
        refreshControl.attributedTitle = NSAttributedString(string: "refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        exploreTableView.refreshControl = refreshControl
        refreshPosts()
    }
    
    func setupTableView(){
        exploreTableView.dataSource = self
        exploreTableView.delegate = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        exploreTableView.register(nib, forCellReuseIdentifier: "cell")
        exploreTableView.estimatedRowHeight = 85.0
        exploreTableView.rowHeight = UITableView.automaticDimension
        exploreTableView.separatorColor = UIColor.clear
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = exploreTableView.bounds
        gradientlayer.colors = [UIColor.white.cgColor, UIColor(named: "bgLightBlue")!.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        exploreTableView.backgroundView = UIImageView(image: GradientColor.image(fromLayer: gradientlayer))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exploreTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let postCell = cell as? PostTableViewCell else { return cell }
        
        postCell.postTitle.text = posts[indexPath.row].title
        postCell.from.text = posts[indexPath.row].departurePlace
        postCell.to.text = posts[indexPath.row].destination
        postCell.numOfMembers.text = "\(posts[indexPath.row].members!.count) / \(posts[indexPath.row].maxMembers!)"
        if(posts[indexPath.row].members!.count == posts[indexPath.row].maxMembers!){
            postCell.numOfMembers.textColor = UIColor.systemRed
        }
        if let setTime = posts[indexPath.row].departureTime {
            if(setTime > Temporal.DateTime(Date())){
                postCell.shadowView.backgroundColor = UIColor(named: "bgGreen")
            }else {
                postCell.shadowView.backgroundColor = UIColor(named: "bgRed")
        }
        
        }
        postCell.when.text = posts[indexPath.row].departureTime.toString()
        profilePhotoCache.append(defaultImage)
        postCell.userAvatar.image = defaultImage
        guard let owner = posts[indexPath.row].owner else { return postCell }

        Amplify.Storage.downloadData(key: owner) {
            result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    postCell.userAvatar.image = image
                }
                self.profilePhotoCache[indexPath.row] = image
            case .failure(_):
                break
            }
        }
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPostDetailViewController(post: posts[indexPath.row])        
    }    
    
    @objc func refreshPosts() {
        self.refreshControl.beginRefreshing()
        DispatchQueue.global().async { [self] in
            let keys = Post.keys
            posts = API.getAll(sort: .descending(keys.departureTime))
            profilePhotoCache = [UIImage?](repeating: defaultImage, count: posts.count)
        }
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: ExploreViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }    
}

extension ExploreViewController: NewPostViewDelegate {
    func handleSuccess() {
        refreshPosts()
        message.showSuccessMessage("Post Sent")
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to Send Post")
    }
}
