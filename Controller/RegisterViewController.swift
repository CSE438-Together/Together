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
    @IBOutlet weak var scroller: UIScrollView!
    
    
    let capitalLetterRegEx  = ".*[A-Z]+.*"
    let lowerLetterRegEx  = ".*[a-z]+.*"
    let numberRegEx = ".*[0-9]+.*"
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    var flagRegister: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderColor = UIColor.systemBlue.cgColor
        registerButton.layer.borderWidth = 1.5
        registerButton.layer.cornerRadius = 10
        
        self.spinner.hidesWhenStopped = true
        self.spinner.layer.zPosition = 200
    }
    
    override func viewDidLayoutSubviews() {
        scroller.isScrollEnabled = true
        scroller.frame = CGRect(x: 0, y: 0, width: 390, height: 810)
        scroller.contentSize = CGSize(width: 390, height: 850)
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
    
    func signUp(email: String, password: String, passwordRepeat:String, givenName:String, familyName: String, phoneNum: String, gender: String, nickName: String) {
        let userAttributes = [AuthUserAttribute(.givenName, value: givenName), AuthUserAttribute(.familyName, value: familyName), AuthUserAttribute(.phoneNumber, value: phoneNum), AuthUserAttribute(.gender, value: gender), AuthUserAttribute(.nickname, value: nickName)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        if password.count < 8 {
            Alert.showWarning(self, "Invalid Password", "Password number must be at least 8!")
        }
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        if texttest.evaluate(with: password) == false {
            Alert.showWarning(self, "Invalid Password", "Password must contain at least 1 uppercase character!")
        }
        if texttest1.evaluate(with: password) == false {
            Alert.showWarning(self, "Invalid Password", "Password must contain at least 1 numeral!")
        }
        if texttest2.evaluate(with: password) == false {
            Alert.showWarning(self, "Invalid Password", "Password must contain at least 1 special character!")
        }
        if texttest3.evaluate(with: password) == false {
            Alert.showWarning(self, "Invalid Password", "Password must contain at least 1 lowercase character!")
        }
        
        Amplify.Auth.signUp(username: email, password: password, options: options) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("SignUp Complete")
                    self.alertJump()
                    self.spinner.stopAnimating()
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    Alert.showWarning(self, "Failed", "An error occurred while registering a user \(error)")
                    self.spinner.stopAnimating()
                    self.removeBlurEffect()
                })
            }
        }
    }
    
    private func checkInput(_ textField: UITextField, _ message: String) {
        if !textField.hasText {
            Alert.showWarning(self, "Value Required", message)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register button pressed")
        
        checkInput(emailText, "Email value is required!")
        checkInput(passwordText, "Password value is required!")
        checkInput(passwordRepeatText, "Password Repeated value is required!")
        checkInput(givenName, "Givenname value is required!")
        checkInput(familyName, "Familyname value is required!")
        checkInput(phoneNum, "Phone Number value is required!")
        checkInput(nickName, "Nickname value is required!")
        
        if phoneNum.text!.range(of:"+1") == nil {
            Alert.showWarning(self, "Invalid Phone Number", "Phone Number must contain +1!")
        }
        if phoneNum.text!.count != 12 {
            Alert.showWarning(self, "Invalid Phone Number", "Phone number is invalid!")
        }
        if passwordText.text! != passwordRepeatText.text! {
            Alert.showWarning(self, "Password Fail", "Password Repeated doesn't match Password!")
        }
        else {
            let gender = genderSelection.titleForSegment(at: genderSelection.selectedSegmentIndex)
            let email = emailText.text! + "@wustl.edu"
            self.spinner.startAnimating()
            self.setBlurEffect()
            signUp(email: email, password: passwordText.text!, passwordRepeat: passwordRepeatText.text!, givenName: givenName.text!, familyName: familyName.text!, phoneNum: phoneNum.text!, gender: gender!, nickName: nickName.text!)
        }
    }
    
    func alertJump(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CodeConfirmViewController = storyboard.instantiateViewController(withIdentifier: "CodeConfirmViewController") as! CodeConfirmViewController
        let email = emailText.text! + "@wustl.edu"
        let password = passwordText.text!
        CodeConfirmViewController.confirmEmail = email
        CodeConfirmViewController.password = password
        CodeConfirmViewController.flagCode = self.flagRegister
        let alertController = UIAlertController(title: "SignUp Completed", message: "SignUp completed! The confirmation code will send to your email.", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.show(CodeConfirmViewController, sender: self)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
