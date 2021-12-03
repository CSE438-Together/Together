//
//  PostDetailViewController.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import Amplify
import AWSPluginsCore
import SQLite

class PostDetailViewController: UIViewController {
    
    var post : Post!
    var isCreator : Bool!
    var isMember : Bool!
    var isApplicants : Bool!
    var ceatorAvatar : UIImage!
    var memberAvatarsChache = [String : UIImage?]()
    
    @IBOutlet var tableView : UITableView!
    
    private var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height + 10)
        //self.tableView.style. = .grouped
        self.tableView.separatorStyle = .none
        self.tableView.layer.cornerRadius = 10
        self.tableView.clipsToBounds = true
        
        self.tableView.register(PostDetailTableViewCreatorCell.nib(), forCellReuseIdentifier: PostDetailTableViewCreatorCell.identifier)
        self.tableView.register(PostDetailTableViewOverViewCell.nib(), forCellReuseIdentifier: PostDetailTableViewOverViewCell.identifier)
        self.tableView.register(PostDetailTableViewTimeCell.nib(), forCellReuseIdentifier: PostDetailTableViewTimeCell.identifier)
        self.tableView.register(PostDetailTableViewLocationCell.nib(), forCellReuseIdentifier: PostDetailTableViewLocationCell.identifier)
        self.tableView.register(PostDetailTableViewPeopleCell.nib(), forCellReuseIdentifier: PostDetailTableViewPeopleCell.identifier)
        self.tableView.register(PostDetailTableViewTransportationCell.nib(), forCellReuseIdentifier: PostDetailTableViewTransportationCell.identifier)
        self.tableView.register(PostDetailTableViewDeleteCell.nib(), forCellReuseIdentifier: PostDetailTableViewDeleteCell.identifier)
        
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
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
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
        
        // prepare memebers avatar
        guard let members = self.post.members else {
            print("Error: this post doesn't have any member")
            return
        }
        for member in members {
            if member == nil {continue}
            Amplify.Storage.downloadData(key: member!) {
                [self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        memberAvatarsChache[member!] = UIImage(data: data)
                    }
                case .failure(_):
                    memberAvatarsChache[member!] = nil
                }
            }
        }
        guard let applicants = self.post.applicants else {return}
        for applicant in applicants {
            if applicant == nil {continue}
            Amplify.Storage.downloadData(key: applicant!) {
                [self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        memberAvatarsChache[applicant!] = UIImage(data: data)
                    }
                case .failure(_):
                    memberAvatarsChache[applicant!] = nil
                }
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(emptyButton))
        
        Amplify.DataStore.save(self.post) { [self]
            result in
            switch(result) {
            case .success:
                print("update successfully")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(didTapJoinButton))
            case .failure:
                print("update failed")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(didTapLeaveButton))
            }
            print("add leave button")
        }
        
    }
    
    @objc func emptyButton() {}
    
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(emptyButton))
            
            post.applicants!.append(userId)
            print("add to applicants")
            Amplify.DataStore.save(self.post) { [self]
                result in
                switch(result) {
                case .success:
                    print("update successfully")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(didTapLeaveButton))
                    
                case .failure:
                    print("update failed")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(didTapJoinButton))
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
         1. creator ( Avator and name )
         2. OverView ( title and description )
         3. Time ( start and end )
         4. Location ( start and end )
         5. People ()
         5. delete if is creator
         
         so, 5 sections in total
         */
        if self.isOwner() { return 6}
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCreatorCell.identifier, for: indexPath) as! PostDetailTableViewCreatorCell
//            cell.configure(with: ceatorAvatar, with: post.owner ?? "")
//            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewOverViewCell.identifier, for: indexPath) as! PostDetailTableViewOverViewCell
            
            cell.configure(with: post.title ?? "", with: post.description ?? "")
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewTimeCell.identifier, for: indexPath) as! PostDetailTableViewTimeCell
            cell.configure(with: String(post.departureTime.toString()))
            return cell
        
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewTransportationCell.identifier, for: indexPath) as! PostDetailTableViewTransportationCell
            cell.configure(with: post.transportation!)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewLocationCell.identifier, for: indexPath) as! PostDetailTableViewLocationCell
            cell.configure(with: post.departurePlace ?? "", with: post.destination ?? "", with: post.transportation! )
            return cell
            
        case 4:
            guard let members = post.members else {
                print("Error: this post doesn't have members")
                let cell = UITableViewCell()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewPeopleCell.identifier, for: indexPath) as! PostDetailTableViewPeopleCell
            cell.configure(with: members.count, with: post.maxMembers ?? 1, with: ceatorAvatar, with: memberAvatarsChache, with: members, with: post.owner ?? "")
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewDeleteCell.identifier, for: indexPath) as! PostDetailTableViewDeleteCell
            cell.configure()
            return cell
        default:
            //TODO: check error
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 4:
            let membersViewController = MembersViewController()
            membersViewController.isOwner = self.isCreator
            membersViewController.post = self.post
            membersViewController.memberAvatarsCache = self.memberAvatarsChache
            membersViewController.creatorAvatar = self.ceatorAvatar
            navigationController?.pushViewController(membersViewController, animated: true)
        case 5:
            let alert = UIAlertController(title: "Delete?", message: "You will permanently delete this post.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(
                UIAlertAction(title: "Delete",
                              style: .destructive,
                              handler: {(_: UIAlertAction!) in
                                  Amplify.DataStore.delete(self.post) {
                                    switch $0 {
                                    case .success:
                                        print("Post deleted!")
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Delete Done!", message: "", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                                self.navigationController?.popToRootViewController(animated: true)
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        
                                    case .failure(let error):
                                        print("Error deleting post - \(error.localizedDescription)")
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Delete Failed!", message: "", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                       
                                    }}
                    }))
            self.present(alert, animated: true, completion: nil)
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
            return "Transportation"
        case 3:
            return "Location"
        case 4:
            return "People"
        default:
            print("Warnnning: has section 4")
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}


extension PostDetailViewController: NewPostViewDelegate {
    func handleSuccess() {}
    
    func handleFailure() {}
}
