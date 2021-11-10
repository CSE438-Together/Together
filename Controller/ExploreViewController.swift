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
    
    var refreshControl = UIRefreshControl()
    var posts: [Post] = API.getAll() {
        didSet {
            exploreTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        refreshControl.attributedTitle = NSAttributedString(string: "refreshing...")
//        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        exploreTableView.addSubview(refreshControl) // not required when using UITableViewController
//        refreshPosts()
    }
    
    func setupTableView(){
        exploreTableView.dataSource = self
        exploreTableView.delegate = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        exploreTableView.register(nib, forCellReuseIdentifier: "cell")
        exploreTableView.estimatedRowHeight = 85.0
        exploreTableView.rowHeight = UITableView.automaticDimension
//        exploreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }    
    
    @objc func refreshPosts(){
        DispatchQueue.global().async {
            do {
                self.posts = API.loadPosts()
            }
            DispatchQueue.main.async {
                self.exploreTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

}
