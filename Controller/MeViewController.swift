//
//  MeViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

class MeViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        logoutButton.layer.borderWidth = 1.5
        logoutButton.layer.cornerRadius = 10
    }
    
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Successfully signed out")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.show(LoginViewController, sender: self)
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Sign out failed with error \(error)")
                    self.alert(title: "Failed", message: "Sign out failed with error \(error)")
                })
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: Any) {
        signOutLocally()
    }

    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
