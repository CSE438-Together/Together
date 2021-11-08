//
//  DetailedViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailedView()
        // Do any additional setup after loading the view.
    }
    func setupDetailedView(){
        addButton.layer.borderColor = UIColor.systemBlue.cgColor
        addButton.layer.borderWidth = 1.5
    }
}
