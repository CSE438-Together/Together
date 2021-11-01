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
    var i: Int = 0
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        posts = APIFunction.loadPosts()

    }
    
    func setupTableView(){
        exploreTableView.dataSource = self
        exploreTableView.delegate = self
        
        var nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        exploreTableView.register(nib, forCellReuseIdentifier: "cell")
        exploreTableView.estimatedRowHeight = 85.0
        exploreTableView.rowHeight = UITableView.automaticDimension
//        exploreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = exploreTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        myCell.from.text = posts[indexPath.row].source
        myCell.to.text = posts[indexPath.row].destination
        myCell.when.text = posts[indexPath.row].departureTime
        myCell.numOfMembers.text = "1 / \(String(describing: posts[indexPath.row].maxMembers!))"
        
        return myCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
