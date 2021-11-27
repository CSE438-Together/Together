//
//  MyEventViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

class MyEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myEventTableView: UITableView!
    @IBOutlet weak var message: MessageLabel!
    private var profilePhotoCache: [UIImage?] = []
    private let defaultImage = UIImage(systemName: "person")
    var refreshControl = UIRefreshControl()
    var myEvents: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.myEventTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        setupTableView()
        refreshControl.attributedTitle = NSAttributedString(string: "refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        myEventTableView.refreshControl = refreshControl
        refreshPosts()
    }
    
    func setupTableView(){
        myEventTableView.dataSource = self
        myEventTableView.delegate = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        myEventTableView.register(nib, forCellReuseIdentifier: "cell")
        myEventTableView.estimatedRowHeight = 85.0
        myEventTableView.rowHeight = UITableView.automaticDimension
        myEventTableView.separatorColor = UIColor.clear
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = myEventTableView.bounds
        gradientlayer.colors = [UIColor.white.cgColor, UIColor(named: "bgLightBlue")!.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        myEventTableView.backgroundView = UIImageView(image: GradientColor.image(fromLayer: gradientlayer))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myEventTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let postCell = cell as? PostTableViewCell else { return cell }
        
        postCell.postTitle.text = myEvents[indexPath.row].title
        postCell.from.text = myEvents[indexPath.row].departurePlace
        postCell.to.text = myEvents[indexPath.row].destination
        postCell.numOfMembers.text = "\(myEvents[indexPath.row].members!.count) / \(myEvents[indexPath.row].maxMembers!)"
        if(myEvents[indexPath.row].members!.count == myEvents[indexPath.row].maxMembers!){
            postCell.numOfMembers.textColor = UIColor.systemRed
        }
        if let setTime = myEvents[indexPath.row].departureTime {
            if(setTime > Temporal.DateTime(Date())){
                postCell.shadowView.backgroundColor = UIColor(named: "bgGreen")
            }else {
                postCell.shadowView.backgroundColor = UIColor(named: "bgRed")
        }
        
        }
        postCell.when.text = myEvents[indexPath.row].departureTime.toString()
        profilePhotoCache.append(defaultImage)
        postCell.userAvatar.image = defaultImage
        guard let owner = myEvents[indexPath.row].owner else { return postCell }

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
        showPostDetailViewController(post: myEvents[indexPath.row])
    }
    
    @objc func refreshPosts() {
        DispatchQueue.global().async {
            guard let user = Amplify.Auth.getCurrentUser() else {return}
            let keys = Post.keys
            self.myEvents = API.getAll(where: keys.owner == user.username, sort: .descending(keys.departureTime))
        }
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: MyEventViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }
}

extension MyEventViewController: NewPostViewDelegate {
    func handleSuccess() {
        refreshPosts()
        message.showSuccessMessage("Post Sent")
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to send Post")
    }
}
