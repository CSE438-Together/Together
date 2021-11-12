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
        postCell.numOfMembers.text = "\(myEvents[indexPath.row].maxMembers ?? 2)"
        postCell.when.text = myEvents[indexPath.row].departureTime.toString()
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController
        self.navigationController?.pushViewController(vc!, animated: true)
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
