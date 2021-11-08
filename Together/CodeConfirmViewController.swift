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
    
    @IBAction func codeConfirmed(_ sender: Any) {
        self.spinner.startAnimating()
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
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Confirm signUp succeeded")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.show(LoginViewController, sender: self)
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("An error occurred while confirming sign up \(error)")
                    self.alert(title: "Failed", message: "An error occurred while confirming sign up \(error)")
                    self.spinner.stopAnimating()
                })
            }
        }
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
