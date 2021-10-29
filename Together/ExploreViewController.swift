//
//  ExploreViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var exploreTableView: UITableView!
    
    let itemString = ["Let's go ikea!                09/25/2021",
                      "Let's go to the zoo!          10/21/2021",
                      "Let's go to the AMC7.         11/21/2021",
                      "Let's go hiking!              09/25/2021",
                      "Road Trip to LA!              10/25/2021",
                      "Rower.                        11/1/2021",
                      "Thanksgiving Party.           11/06/2021",
                      "Wustl Special Event!          11/12/2021",
                      "Fall Breaking Hiking          11/15/2021"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exploreTableView.dataSource = self
        exploreTableView.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel?.text = itemString[indexPath.row]
        
        return myCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
