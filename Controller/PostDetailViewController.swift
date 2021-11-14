//
//  PostDetailViewController.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import Amplify

class PostDetailViewController: UIViewController {
    
    var post : Post!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostDetailTableViewOverViewCell.nib(), forCellReuseIdentifier: PostDetailTableViewOverViewCell.identifier)
        table.register(PostDetailTableViewTimeCell.nib(), forCellReuseIdentifier: PostDetailTableViewTimeCell.identifier)
        table.register(PostDetailTableViewLocationCell.nib(), forCellReuseIdentifier: PostDetailTableViewLocationCell.identifier)
        table.register(PostDetailTableViewPeopleCell.nib(), forCellReuseIdentifier: PostDetailTableViewPeopleCell.identifier)
            return table
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.title = "Event Details"
        
        if isOwner() {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(didTapJoinButton))
        }
        
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func isOwner() -> Bool {
        // TODO: check
        // for test just return true or false
        return true
        
        // logic:
//        guard let currentUser = Amplify.Auth.getCurrentUser() else {
//            print("Error: should not have a user hasn't signed in.")
//            return false
//        }
//        guard let owner = post.owner else {
//            print("Error: a post should have a owner")
//            return false
//        }
//        if currentUser.userId == owner {
//            return true
//        }
//        return false
        
    }
    
    @objc func didTapEditButton() {
//        // edit post
    }
    
    @objc func didTapJoinButton() {
        // add self to waitlist
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /* lbx:
         we have :
         1. OverView ( title and description )
         2. Time ( start and end )
         3. Location ( start and end )
         4. People ()
         
         so, 4 sections in total
         */
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewOverViewCell.identifier, for: indexPath) as! PostDetailTableViewOverViewCell
            
            cell.configure(with: post.title ?? "", with: post.description ?? "")
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewTimeCell.identifier, for: indexPath) as! PostDetailTableViewTimeCell
            cell.configure(with: String(post.departureTime.toString()))
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewLocationCell.identifier, for: indexPath) as! PostDetailTableViewLocationCell
            cell.configure(with: post.departurePlace ?? "", with: post.destination ?? "" )
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewPeopleCell.identifier, for: indexPath) as! PostDetailTableViewPeopleCell
            cell.configure(with: 0, with: post.maxMembers ?? 1)
            return cell
        default:
            //TODO: check error
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 30
        case 2:
            return 220
        case 3:
            return 40
        default:
            return 0
        }
    }
    
}


extension PostDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "OverView"
        case 1:
            return "Time"
        case 2:
            return "Location"
        case 3:
            return "People"
        default:
            print("Warnnning: has section 4")
            return ""
        }
        
    }
}


extension PostDetailViewController: NewPostViewDelegate {
    func handleSuccess() {}
    
    func handleFailure() {}
}
