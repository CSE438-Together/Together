//
//  MyEventViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class MyEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myEventTableView: UITableView!
    
    let myItemString = ["Let's go ikea!                09/25/2021",
                      "Let's go to the zoo!          10/21/2021",
                      "Let's go to the AMC7.         11/21/2021",
                      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myEventTableView.dataSource = self
        myEventTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItemString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel?.text = myItemString[indexPath.row]
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewControllerOfmyPost") as? MyPostDetailedViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func addPostPress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
