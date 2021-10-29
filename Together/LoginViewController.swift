//
//  LoginViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var userNameAlert: UILabel!
    @IBOutlet weak var passWordAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMELoginView()
    }
    
    func setUpMELoginView(){
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.borderWidth = 1.5
        
        signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
        signUpButton.layer.borderWidth = 1.5
        
        userNameAlert.textColor = UIColor.red
        passWordAlert.textColor = UIColor.red
    }
    
    
    @IBAction func passWordChanged(_ sender: Any) {
        if passWordText.hasText == true{
            passWordAlert.text = ""
        }
    }
    
    @IBAction func userNameChanged(_ sender: Any) {
        if userNameText.hasText == true{
            userNameAlert.text = ""
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UserInfoView") as? MeViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
