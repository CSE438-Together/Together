//
//  CodeConfirmViewController.swift
//  Together
//
//  Created by HuiyiTang on 11/7/21.
//

import UIKit
import Amplify

class CodeConfirmViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var confirmEmail: String = ""
    var password: String = ""
    var flagCode: Bool = false
    
    @IBAction func codeConfirmed(_ sender: Any) {
        self.spinner.startAnimating()
        self.setBlurEffect()
        confirmSignUp(for: confirmEmail, with: code.text!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        confirmButton.layer.borderColor = UIColor.systemBlue.cgColor
        confirmButton.layer.borderWidth = 1.5
        confirmButton.layer.cornerRadius = 10
        
        self.spinner.hidesWhenStopped = true
        self.spinner.layer.zPosition = 200
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
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Confirm signUp succeeded")
                    self.alertJump()
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    Alert.showWarning(self, "Failed", "An error occurred while confirming sign up \(error)")
                    self.spinner.stopAnimating()
                    self.removeBlurEffect()
                })
            }
        }
    }
    
//    func alert(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
    
    func alertJump(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.flagCode = true
        LoginViewController.flagLogin = self.flagCode
        self.confirmEmail = self.confirmEmail.replacingOccurrences(of: "@wustl.edu", with: "")
        LoginViewController.email = self.confirmEmail
        LoginViewController.password = self.password
        let alertController = UIAlertController(title: "SignUp Comfirmed", message: "SignUp confirmed! Now you can login.", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.show(LoginViewController, sender: self)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
