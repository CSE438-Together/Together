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
    
    @IBAction func passwordForget(_ sender: Any) {
        let username = userNameText.text! + "@wustl.edu"
        self.resetPassword(username: username)
    }
    
    func resetPassword(username: String) {
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                        self.confirm()
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Reset completed")
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Reset password failed with error \(error)")
                    Alert.showWarning(self, "Error", "Reset password failed with error \(error)")
                })
            }
        }
    }
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Password reset confirmed")
                    self.passWordText.text = newPassword
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Reset password failed with error \(error)")
                    Alert.showWarning(self, "Error", "Reset password failed with error \(error)")
                })
            }
        }
    }
    
    func confirm(){
        let alertController = UIAlertController(title: "Forget Password", message: "Please enter your new password and confirmation code!", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Confirm code"
        }
        let action = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let newPassword = alertController.textFields![0] as UITextField
            let code = alertController.textFields![1] as UITextField
            let username = self.userNameText.text! + "@wustl.edu"
            self.confirmResetPassword(username: username, newPassword: newPassword.text!, confirmationCode: code.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
                    Alert.showWarning(self, "Sign in Failed", "\(error)")
                    self.spinner.stopAnimating()
                    self.removeBlurEffect()
                })
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if userNameText.hasText != true {
            Alert.showWarning(self, "Value Required", "Email value is required!")
        }
        if passWordText.hasText != true {
            Alert.showWarning(self, "Value Required", "Password value is required!")
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
}
