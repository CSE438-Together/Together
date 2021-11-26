//
//  ExploreViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify
import Combine

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var message: MessageLabel!
    private let searchController = UISearchController()
    private lazy var postManager: PostManager = {
        return PostManager(table: exploreTableView, sort: .descending(Post.keys.departureTime))
    } ()
    var postsSubscription: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        setupTableView()
        postsSubscription = Amplify.DataStore.publisher(for: Post.self)
            .sink {
                if case let .failure(error) = $0 {
                    print("Subscription received error - \(error.localizedDescription)")
                }
            }
            receiveValue: {
                changes in
                DispatchQueue.main.async {
                    Alert.showWarning(self, "new message")
                }
                
            }
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
        return postManager.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return postManager.getCell(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postManager.showPostDetailViewController(controller: self, indexPath: indexPath)
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: ExploreViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }    
}

extension ExploreViewController: NewPostViewDelegate {
    func handleSuccess() {
        postManager.reloadPosts()
        message.showSuccessMessage("Post Sent")
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to Send Post")
    }
}
