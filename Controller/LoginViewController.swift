//
//  LoginViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify
import AVFoundation

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.hidesWhenStopped = true
        self.spinner.color = UIColor.black
        self.spinner.layer.zPosition = 200

        setUpMELoginView()
    }
    
    func setUpMELoginView(){
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.cornerRadius = 10
    }
    
    func signIn(email: String, password: String) {
        Amplify.Auth.signIn(username: email, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Sign in succeeded")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Sign in failed \(error)")
                    self.alert(title: "Sign in Failed", message: "\(error)")
                    self.spinner.stopAnimating()
                })
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if userNameText.hasText != true {
            self.alert(title: "Value Required", message: "Email value is required!")
        }
        if passWordText.hasText != true {
            self.alert(title: "Value Required", message: "Password value is required!")
        }
        
        let email = userNameText.text! + "@wustl.edu"
        self.spinner.startAnimating()
        signIn(email: email, password: passWordText.text!)
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let RegisterViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController")
        self.show(RegisterViewController, sender: self)
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
