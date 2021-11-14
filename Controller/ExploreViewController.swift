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
    
    var refreshControl = UIRefreshControl()
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.exploreTableView.reloadData()
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
        postCell.numOfMembers.text = "\(posts[indexPath.row].maxMembers ?? 2)"
        postCell.when.text = posts[indexPath.row].departureTime.toString()
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
//        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
        // lbx: change to PostDetailViewController
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.post = posts[indexPath.row]
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
        
    }    
    
    @objc func refreshPosts() {
        DispatchQueue.global().async {
            let keys = Post.keys
            self.posts = API.getAll(sort: .descending(keys.departureTime))
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
