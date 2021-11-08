//
//  MyPostDetailedViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class MyPostDetailedViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMyPostDetailedView()
        // Do any additional setup after loading the view.
    }
    
    func setUpMyPostDetailedView(){
        cancelButton.layer.borderColor = UIColor.systemBlue.cgColor
        cancelButton.layer.borderWidth = 1.5
    }

}
