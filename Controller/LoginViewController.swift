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
    
    var email: String = ""
    var password: String = ""
    var flagLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.spinner.hidesWhenStopped = true
        self.spinner.color = UIColor.black
        self.spinner.layer.zPosition = 200
        
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.cornerRadius = 10
        
        if flagLogin == true {
            userNameText.text = email
            passWordText.text = password
        }
        
        checkUserSignedIn()
    }
    
    func checkUserSignedIn() {
        self.spinner.startAnimating()
        self.setBlurEffect()
        Amplify.Auth.fetchAuthSession { (result) in
            do {
                let session = try result.get()
                if session.isSignedIn == true {
                    DispatchQueue.main.async(execute: {
                        let mainTabBarController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        self.spinner.stopAnimating()
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        self.removeBlurEffect()
                        self.spinner.stopAnimating()
                    })
                }
            } catch {
                print("Fetch auth session failed with error - \(error)")
            }
        }
    }
    
    func setBlurEffect() {
        let blureffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blureffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    func removeBlurEffect() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Amplify.Auth.signIn(username: email, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Sign in succeeded")
                
                    let mainTabBarController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Sign in failed \(error)")
                    self.alert(title: "Sign in Failed", message: "\(error)")
                    self.spinner.stopAnimating()
                    self.removeBlurEffect()
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
        self.setBlurEffect()
        signIn(email: email, password: passWordText.text!)
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let RegisterViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        RegisterViewController.flagRegister = flagLogin
        self.show(RegisterViewController, sender: self)
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
