//
//  PostDetailViewController.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import Amplify
import AWSPluginsCore

class PostDetailViewController: UIViewController {
    
    var post : Post!
    var isCreator : Bool!
    var isMember : Bool!
    var isApplicants : Bool!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostDetailTableViewOverViewCell.nib(), forCellReuseIdentifier: PostDetailTableViewOverViewCell.identifier)
        table.register(PostDetailTableViewTimeCell.nib(), forCellReuseIdentifier: PostDetailTableViewTimeCell.identifier)
        table.register(PostDetailTableViewLocationCell.nib(), forCellReuseIdentifier: PostDetailTableViewLocationCell.identifier)
        table.register(PostDetailTableViewPeopleCell.nib(), forCellReuseIdentifier: PostDetailTableViewPeopleCell.identifier)
            return table
        }()
    
    private var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Event Details"
        
        // TODO: this should not exist
        // remove in future
        Amplify.DataStore.query(Post.self, byId: self.post.id) {
            switch $0 {
                case .success(let result):
                    // result will be a single object of type Post?
                    print("Posts: \(result)")
                    self.post = result
                case .failure(let error):
                    print("Error on query() for type Post - \(error.localizedDescription)")
                }
        }
        
        self.tableView.reloadData()

        
        
        guard let id = Amplify.Auth.getCurrentUser()?.userId else {
            print("Error: UserId is not existed")
            return
        }
        
        userId = id
        
        isCreator = isOwner()
        
        if isCreator {
            print("add Edit button")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
        } else {
            // check if has applied an applicants or joined
            guard let members = self.post.members else {
                print("Error: doesn't have members")
                return
            }
            self.isMember = members.contains(userId!)
            if self.post.applicants == nil {
                self.isApplicants = false
            } else if ( self.post.applicants!.contains(userId!) ) {
                self.isApplicants = true
            } else {
                self.isApplicants = false
            }
            
            if (self.isMember && self.isApplicants) {
                print("Warning: is memeber and also is applicant")
                return
            } else if ( self.isMember || self.isApplicants) {
                print("add leave button")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(didTapLeaveButton))
            } else {
                print("add join button")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(didTapJoinButton))
            }
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func isOwner() -> Bool {
        // TODO: check
        // for test just return true or false
        guard let user = Amplify.Auth.getCurrentUser() else { return false}
        guard let owner = post.owner else { return false}
        if user.userId == owner { return true }
        return false
    }
    
    @objc func didTapEditButton() {
//        // edit post
    }
    
    @objc func didTapLeaveButton() {
        if self.isMember {
            if self.isCreator {return}
            if self.post.members == nil {return}
            if let index = self.post.members!.firstIndex(of: userId!) {
                self.post.members!.remove(at: index)
            }
            
        } else if self.isApplicants {
            if self.post.applicants == nil {return}
            if let index = self.post.applicants!.firstIndex(of: userId!) {
                self.post.applicants!.remove(at: index)
            }
        } else {
            print("Error: neither a member nor a applicants")
        }
        
        
        Amplify.DataStore.save(self.post) { [self]
            result in
            switch(result) {
            case .success:
                print("update successfully")
            case .failure:
                print("update failed")
            }
        }
        
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: PostDetailViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self, post: post)
    }
    
    @objc func didTapJoinButton() {
        // add self to waitlist
        // check if already is a member
        print("Tapped Join")
        guard let members = post.members else {
            print("No members")
            return }
        guard let userId = userId else {
            print("No userId")
            return }
        
        if post.applicants == nil {
            print("handle nil")
            post.applicants = [String]()
        } else {
            print("handle not nil")
            for m in post.applicants! {
                print(m)
            }
        }
        
        if ( members.contains(userId) || post.applicants!.contains(userId) ) {
            print("A member try to join again")
        } else {
            post.applicants!.append(userId)
            print("add to applicants")
            Amplify.DataStore.save(self.post) { [self]
                result in
                switch(result) {
                case .success:
                    print("update successfully")
                case .failure:
                    print("update failed")
                }
            }
            
        }
        
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
            guard let members = post.members else {
                print("Error: this post doesn't have members")
                let cell = UITableViewCell()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewPeopleCell.identifier, for: indexPath) as! PostDetailTableViewPeopleCell
            cell.configure(with: members.count, with: post.maxMembers ?? 1)
            return cell
        default:
            //TODO: check error
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            let membersViewController = MembersViewController()
            membersViewController.isOwner = self.isCreator
            membersViewController.post = self.post
            navigationController?.pushViewController(membersViewController, animated: true)
        default:
            return
        }
    }

    // keep the code but deprecate this function, using tableView.rowHeight = UITableView.automaticDimension instead
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        switch indexPath.section {
////        case 0:
////            
////        case 1:
////            return 30
////        case 2:
////            return 220
////        case 3:
////            return 40
////        default:
////            return 0
////        }
//    
//    }
    
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
