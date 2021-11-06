//
//  PostViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var people: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var Description: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostView()
        // Do any additional setup after loading the view.
        print("123123")
    }
    
    func setupPostView(){
        postButton.layer.borderColor = UIColor.systemBlue.cgColor
        postButton.layer.borderWidth = 1.5
        
    }
    
    @IBAction func addPost(_ sender: Any) {
        APIFunction.createPost()
    }
}
