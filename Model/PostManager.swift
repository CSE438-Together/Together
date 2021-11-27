//
//  PostManager.swift
//  Together
//
//  Created by lcx on 2021/11/25.
//

import UIKit
import Amplify

class PostManager {
    var posts = [Post]()
    private var imageCache = [String:UIImage]()
    private let sort: QuerySortInput?
    private let predicate: QueryPredicate?
    private var table: UITableView
    private let defaultImage = UIImage(systemName: "person")
    private var reloadCompletion: (() -> Void)?

    var postCount: Int {
        get {
            return posts.count
        }
    }
    
    init(table: UITableView, predicate: QueryPredicate? = nil, sort: QuerySortInput? = nil, reloadCompletion: (() -> Void)? = nil) {
        self.reloadCompletion = reloadCompletion
        self.predicate = predicate
        self.sort = sort
        self.table = table
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
        self.table.refreshControl?.attributedTitle = NSAttributedString(string: "loading...")
        reloadPosts()
    }
    
    @objc func reloadPosts() {
        DispatchQueue.main.async { [self] in
            table.refreshControl?.beginRefreshing()
        }
        DispatchQueue.global().async { [self] in
            posts = API.getAll(where: predicate, sort: sort)
            DispatchQueue.main.async {
                table.refreshControl?.endRefreshing()
                table.reloadData()
                if let completion = reloadCompletion {
                    completion()
                }
            }
        }
    }
    
    func getCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
        guard let owner = posts[indexPath.row].owner else { return postCell }
        if imageCache[owner] == nil {
            Amplify.Storage.downloadData(key: owner) { [self]
                result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    imageCache[owner] = image
                    DispatchQueue.main.async {
                        postCell.userAvatar.image = imageCache[owner]
                    }
                case .failure(_):
                    imageCache[owner] = defaultImage
                }
            }
        } else {
            postCell.userAvatar.image = imageCache[owner]
        }
        return postCell
    }
    
    func showPostDetailViewController(controller: UIViewController, indexPath: IndexPath) {
        guard let viewController = controller.storyboard?.instantiateViewController(identifier: "PostDetailViewController"),
              let postDetailViewController = viewController as? PostDetailViewController
        else {
            return
        }
        postDetailViewController.post = posts[indexPath.row]
        controller.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}
