//
//  RegisterViewController.swift
//  Together
//
//  Created by HuiyiTang on 2021/11/7.
//

import UIKit
import Amplify

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    @IBOutlet weak var givenName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    let capitalLetterRegEx  = ".*[A-Z]+.*"
    let lowerLetterRegEx  = ".*[a-z]+.*"
    let numberRegEx = ".*[0-9]+.*"
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerButton.layer.borderColor = UIColor.systemBlue.cgColor
        registerButton.layer.borderWidth = 1.5
        registerButton.layer.cornerRadius = 10
        
        self.spinner.hidesWhenStopped = true
        self.spinner.layer.zPosition = 200
    }
    
    func signUp(email: String, password: String, passwordRepeat:String, givenName:String, familyName: String, phoneNum: String, gender: String, nickName: String) {
        let userAttributes = [AuthUserAttribute(.givenName, value: givenName), AuthUserAttribute(.familyName, value: familyName), AuthUserAttribute(.phoneNumber, value: phoneNum), AuthUserAttribute(.gender, value: gender), AuthUserAttribute(.nickname, value: nickName)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        if password.count < 8 {
            self.alert(title: "Password Fail", message: "Password number must be at least 8!")
        }
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        if texttest.evaluate(with: password) == false {
            self.alert(title: "Password Fail", message: "Password must contain at least 1 uppercase character!")
        }
        if texttest1.evaluate(with: password) == false {
            self.alert(title: "Password Fail", message: "Password must contain at least 1 numeral!")
        }
        if texttest2.evaluate(with: password) == false {
            self.alert(title: "Password Fail", message: "Password must contain at least 1 special character!")
        }
        if texttest3.evaluate(with: password) == false {
            self.alert(title: "Password Fail", message: "Password must contain at least 1 lowercase character!")
        }
        
        Amplify.Auth.signUp(username: email, password: password, options: options) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("SignUp Complete")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let CodeConfirmViewController = storyBoard.instantiateViewController(withIdentifier: "CodeConfirmViewController") as! CodeConfirmViewController
                    CodeConfirmViewController.confirmEmail = email
                    self.show(CodeConfirmViewController, sender: self)
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("An error occurred while registering a user \(error)")
                    self.alert(title: "Failed", message: "An error occurred while registering a user \(error)")
                    self.spinner.stopAnimating()
                })
            }
        }
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        if emailText.hasText != true {
            self.alert(title: "Value Required", message: "Email value is required!")
        }
        if passwordText.hasText != true {
            self.alert(title: "Value Required", message: "Password value is required!")
        }
        if passwordRepeatText.hasText != true {
            self.alert(title: "Value Required", message: "Password Repeated value is required!")
        }
        if givenName.hasText != true {
            self.alert(title: "Value Required", message: "Givenname value is required!")
        }
        if familyName.hasText != true {
            self.alert(title: "Value Required", message: "Familyname value is required!")
        }
        if phoneNum.hasText != true {
            self.alert(title: "Value Required", message: "Phone Number value is required!")
        }
        if nickName.hasText != true {
            self.alert(title: "Value Required", message: "Nickname value is required!")
        }
        if (phoneNum.text!.range(of:"+1") == nil || phoneNum.text!.count != 12) {
            self.alert(title: "Invalid Phone Number", message: "Phone Number is invalid!")
        }
        if passwordText.text! != passwordRepeatText.text! {
            self.alert(title: "Password Fail", message: "Password Repeated doesn't match Password!")
        }
        else {
            let gender = genderSelection.titleForSegment(at: genderSelection.selectedSegmentIndex)
            let email = emailText.text! + "@wustl.edu"
            self.spinner.startAnimating()
            signUp(email: email, password: passwordText.text!, passwordRepeat: passwordRepeatText.text!, givenName: givenName.text!, familyName: familyName.text!, phoneNum: phoneNum.text!, gender: gender!, nickName: nickName.text!)
        }
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
