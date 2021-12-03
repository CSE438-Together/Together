//
//  ExploreViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var message: MessageLabel!
    @IBOutlet weak var newPostsReminder: UIButton!
    private let searchController = UISearchController()
    private var postManager: PostManager!
    private lazy var label: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.text = "Post Sent"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.frame = CGRect(x: 15, y: 47,
                             width: view.frame.width - 30,
                             height: label.intrinsicContentSize.height + 30
        )
        label.center = CGPoint(x: view.center.x, y: -label.frame.height)
        return label
    } ()
    private let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let username = Amplify.Auth.getCurrentUser()?.username else { return }
//        Amplify.Storage.downloadData(key: username) {
//            result in
//            switch result {
//            case .success(let imageData):
//                DispatchQueue.main.async {
//                    if let image = UIImage(data: imageData) {
//                        print(image)
//                    }
//                }
//            case .failure(_):
//                break
//            }
//        }
//        let queryParameters = ["username" : username]
//        let request = RESTRequest(path: "/getUserAttributes", queryParameters: queryParameters)
//        Amplify.API.get(request: request) { result in
//            switch result {
//            case .success(let data):
//                if let item = try? JSONDecoder().decode(Attributes.self, from: data) {
//                    print(item.firstName ?? "")
//                    print(item.lastName ?? "")
//                    print(item.gender ?? "")
//                    print(item.nickName ?? "")
//                } else {
//                    // handle error
//                }
//            case .failure(let error):
//                // handle error
//                print(error.errorDescription)
//                break
//            }
//        }
        
        
        
        
        
        
        navigationController?.view.addSubview(label)
        exploreTableView.scrollsToTop = false
        newPostsReminder.layer.cornerRadius = 15
        
        let purpleToPink = CAGradientLayer()
        purpleToPink.frame = tabBarController!.tabBar.bounds
        purpleToPink.colors = [UIColor(named: "bgLightPurple")!.cgColor, UIColor(named: "bgLightPink")!.cgColor]
        purpleToPink.locations = [0, 1]
        purpleToPink.startPoint = CGPoint(x: 0.0, y: 0.0)
        purpleToPink.endPoint = CGPoint(x: 1.0, y: 0.0)
        tabBarController!.tabBar.layer.insertSublayer(purpleToPink, at: 0)
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "bgYellow")
        
        navigationItem.searchController = searchController
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search titles, places and descriptions"
        
        setupTableView()
        postManager = PostManager(
            table: exploreTableView,
            sort: .descending(Post.keys.departureTime),
            reloadCompletion: { self.newPostsReminder.isHidden = true }
        )

        _ = Amplify.Hub.listen(to: .dataStore) {
            if $0.eventName == HubPayload.EventName.DataStore.syncReceived {
                guard let mutationEvent = $0.data as? MutationEvent,
                      mutationEvent.mutationType == GraphQLMutationType.create.rawValue,
                      let item = try? mutationEvent.decodeModel(as: Post.self)
                else {
                    return
                }
                self.postManager.posts.insert(item, at: 0)
                DispatchQueue.main.async { [self] in
                    self.newPostsReminder.isHidden = false
                }
            }
        }
    }
    
    func setupTableView(){
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        exploreTableView.register(nib, forCellReuseIdentifier: "cell")
        exploreTableView.estimatedRowHeight = 85.0
        exploreTableView.rowHeight = UITableView.automaticDimension
        exploreTableView.separatorColor = UIColor.clear
        
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
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        newPostsReminder.isHidden = true
        exploreTableView.scrollsToTop = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchController.searchBar.text else {
            return
        }
        let p = Post.keys
        postManager = PostManager(
            table: exploreTableView,
            predicate: (p.departurePlace.contains(keyword)
                        || p.destination.contains(keyword)
                        || p.title.contains(keyword)
                        || p.description.contains(keyword)
            ),
            sort: .descending(Post.keys.departureTime),
            reloadCompletion: { self.newPostsReminder.isHidden = true }
        )
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        postManager = PostManager(
            table: exploreTableView,
            sort: .descending(Post.keys.departureTime),
            reloadCompletion: { self.newPostsReminder.isHidden = true }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if postManager != nil {
            postManager.reloadPosts()
        }
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: ExploreViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }
    
    @IBAction func newPostsButtonPressed(_ sender: UIButton) {
        sender.isHidden = true
        exploreTableView.reloadData()
        exploreTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        exploreTableView.scrollsToTop = true
    }
    
    
}

extension ExploreViewController: NewPostViewDelegate {
    func handleSuccess() {
        DispatchQueue.main.async { [self] in
            UIView.animate(withDuration: 0.6) {
                label.center = CGPoint(x: view.center.x, y: (topPadding ?? 50) + label.frame.height / 2)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.6) {
                    label.center = CGPoint(x: view.center.x, y: -label.frame.height)
                }
            }
        }
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to Send Post")
    }
}
