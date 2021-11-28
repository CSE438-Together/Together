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
    private let searchController = UISearchController()
    private var eventManager: PostManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        setupTableView()
        guard let user = Amplify.Auth.getCurrentUser() else { return }
        eventManager = PostManager(
            table: myEventTableView,
            predicate: Post.keys.owner == user.username,
            sort: .descending(Post.keys.departureTime)
        )
    }
    
    func setupTableView(){
        myEventTableView.dataSource = self
        myEventTableView.delegate = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        myEventTableView.register(nib, forCellReuseIdentifier: "cell")
        myEventTableView.estimatedRowHeight = 85.0
        myEventTableView.rowHeight = UITableView.automaticDimension
        myEventTableView.separatorColor = UIColor.clear
        
//        let gradientlayer = CAGradientLayer()
//        gradientlayer.frame = myEventTableView.bounds
//        gradientlayer.colors = [UIColor(named: "bgLightPurple")!.cgColor, UIColor.white.cgColor]
//        gradientlayer.locations = [0, 1]
//        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientlayer.endPoint = CGPoint(x: 1.0, y: 0.0)
//        myEventTableView.backgroundView = UIImageView(image: UIImage(named: "loginLogo"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eventManager.getCell(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventManager.showPostDetailViewController(controller: self, indexPath: indexPath)
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: MyEventViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }
}

extension MyEventViewController: NewPostViewDelegate {
    func handleSuccess() {
        eventManager.reloadPosts()
        message.showSuccessMessage("Post Sent")
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to send Post")
    }
}
