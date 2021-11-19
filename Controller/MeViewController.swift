//
//  MeViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify
import SwiftUI

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.borderColor = UIColor.systemGray4.cgColor
        resetButton.layer.borderWidth = 1.5
        resetButton.layer.cornerRadius = 10
        
        fetchAttributes()

        self.title = "Me"
        
        userImage.layer.cornerRadius = userImage.frame.width/2
        userImage.layer.masksToBounds = true

        DispatchQueue.global().async { [self] in
            getUserProfileImageKey() {
                imageKey in
                downloadUserProfileImage(imageKey)
            }
        }
        
        let nicknameTap = UITapGestureRecognizer(target: self, action: #selector(MeViewController.nicknameTapFunction))
        nickname.isUserInteractionEnabled = true
        nickname.addGestureRecognizer(nicknameTap)
        
        let givenNameTap = UITapGestureRecognizer(target: self, action: #selector(MeViewController.givenNameTapFunction))
        givenName.isUserInteractionEnabled = true
        givenName.addGestureRecognizer(givenNameTap)
        
        let familyNameTap = UITapGestureRecognizer(target: self, action: #selector(MeViewController.familyNameTapFunction))
        familyName.isUserInteractionEnabled = true
        familyName.addGestureRecognizer(familyNameTap)
        
        let phoneNumTap = UITapGestureRecognizer(target: self, action: #selector(MeViewController.phoneNumTapFunction))
        phoneNum.isUserInteractionEnabled = true
        phoneNum.addGestureRecognizer(phoneNumTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(MeViewController.genderTapFunction))
        gender.isUserInteractionEnabled = true
        gender.addGestureRecognizer(genderTap)
    }
    
    @objc
    func nicknameTapFunction(sender:UITapGestureRecognizer) {
        nicknameChange()
    }
    
    @objc
    func givenNameTapFunction(sender:UITapGestureRecognizer) {
        givenNameChange()
    }
    
    @objc
    func familyNameTapFunction(sender:UITapGestureRecognizer) {
        familyNameChange()
    }
    
    @objc
    func phoneNumTapFunction(sender:UITapGestureRecognizer) {
        phoneNumChange()
    }
    
    @objc
    func genderTapFunction(sender:UITapGestureRecognizer) {
        genderChange()
    }
    
    func updateNicknameAttribute(info: String) {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.nickname, value: info)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Update completed")
                        self.fetchAttributes()
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Update attribute failed with error \(error)")
                    Alert.showWarning(self, "Error", "Update attribute failed with error \(error)")
                })
            }
        }
    }
    
    func nicknameChange(){
        let alertController = UIAlertController(title: "User Info Update", message: "Please enter updated Nickname.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Updated Nickname"
        }
        let action = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let info = alertController.textFields![0] as UITextField
            self.updateNicknameAttribute(info: info.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateGivenNameAttribute(info: String) {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.givenName, value: info)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Update completed")
                        self.fetchAttributes()
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Update attribute failed with error \(error)")
                    Alert.showWarning(self, "Error", "Update attribute failed with error \(error)")
                })
            }
        }
    }
    
    func givenNameChange(){
        let alertController = UIAlertController(title: "User Info Update", message: "Please enter updated Given Name.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Updated Given Name"
        }
        let action = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let info = alertController.textFields![0] as UITextField
            self.updateGivenNameAttribute(info: info.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateFamilyNameAttribute(info: String) {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.familyName, value: info)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Update completed")
                        self.fetchAttributes()
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Update attribute failed with error \(error)")
                    Alert.showWarning(self, "Error", "Update attribute failed with error \(error)")
                })
            }
        }
    }
    
    func familyNameChange(){
        let alertController = UIAlertController(title: "User Info Update", message: "Please enter updated Family Name.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Updated Family Name"
        }
        let action = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let info = alertController.textFields![0] as UITextField
            self.updateFamilyNameAttribute(info: info.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updatePhoneNumAttribute(info: String) {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.phoneNumber, value: info)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Update completed")
                        self.fetchAttributes()
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Update attribute failed with error \(error)")
                    Alert.showWarning(self, "Error", "Update attribute failed with error \(error)")
                })
            }
        }
    }
    
    func phoneNumChange(){
        let alertController = UIAlertController(title: "User Info Update", message: "Please enter updated Phone Number.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Updated Phone Number"
        }
        let action = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let info = alertController.textFields![0] as UITextField
            self.updatePhoneNumAttribute(info: info.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateGenderAttribute(info: String) {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.gender, value: info)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async(execute: {
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                    })
                case .done:
                    DispatchQueue.main.async(execute: {
                        print("Update completed")
                        self.fetchAttributes()
                    })
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    print("Update attribute failed with error \(error)")
                    Alert.showWarning(self, "Error", "Update attribute failed with error \(error)")
                })
            }
        }
    }
    
    func genderChange(){
        let alertController = UIAlertController(title: "User Info Update", message: "Please enter updated Gender.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Updated Gender"
        }
        let action = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let info = alertController.textFields![0] as UITextField
            self.updateGenderAttribute(info: info.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                DispatchQueue.main.async(execute: {
                    print(type(of: attributes))
                    for attribute in attributes {
                        if attribute.key == AuthUserAttributeKey.nickname {
                            self.nickname.text = "Hi, " + attribute.value
                        }
                        if attribute.key == AuthUserAttributeKey.email {
                            self.email.text = attribute.value
                        }
                        if attribute.key == AuthUserAttributeKey.givenName {
                            self.givenName.text = attribute.value
                        }
                        if attribute.key == AuthUserAttributeKey.familyName {
                            self.familyName.text = attribute.value
                        }
                        if attribute.key == AuthUserAttributeKey.phoneNumber {
                            self.phoneNum.text = attribute.value
                        }
                        if attribute.key == AuthUserAttributeKey.gender {
                            self.gender.text = attribute.value
                        }
                    }
                    print("User attributes - \(attributes)")
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Fetching user attributes failed with error \(error)")
                    Alert.showWarning(self, "Error", "Fetching user attributes failed with error \(error)")
                })
            }
        }
    }
    
    @IBAction func passwordReset(_ sender: Any) {
        self.passwordReset()
    }
    
    func changePassword(oldPassword: String, newPassword: String) {
        Amplify.Auth.update(oldPassword: oldPassword, to: newPassword) { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Change password succeeded")
                    Alert.showWarning(self, "Finished", "Change password succeeded")
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    print("Change password failed with error \(error)")
                    Alert.showWarning(self, "Error", "Change password failed with error \(error)")
                })
            }
        }
    }
    
    func passwordReset(){
        let alertController = UIAlertController(title: "Password Reset", message: "Please enter your old and new password to update!", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Old Password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }
        let action = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let oldPassword = alertController.textFields![0] as UITextField
            let newPassword = alertController.textFields![1] as UITextField
            self.changePassword(oldPassword: oldPassword.text!, newPassword: newPassword.text!)
        })
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                DispatchQueue.main.async(execute: {
                    print("Successfully signed out")
            
                    let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.show(LoginViewController, sender: self)
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    Alert.showWarning(self, "Failed", "Sign out failed with error \(error)")
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.global().async {
                guard let selectedImage = info[.originalImage] as? UIImage,
                      let imageData = selectedImage.jpegData(compressionQuality: 0.5)
                else {
                    Alert.showWarning(self, "Failed", "Fail to pick image")
                    return
                }
                let imageKey = UUID().uuidString + ".jpg"
                Amplify.Storage.uploadData(key: imageKey, data: imageData) { [self]
                    result in
                    switch result {
                    case .success:
                        saveImageToUserProfile(imageKey, selectedImage)
                    case .failure(_):
                        Alert.showWarning(self, "Failed", "Fail to upload image")
                    }
                }
            }
        }
    }
    
    private func saveImageToUserProfile(_ imageKey: String, _ selectedImage: UIImage) {
        DispatchQueue.global().async { [self] in
            getUserProfileImageKey() {
                imageKey in
                Amplify.Storage.remove(key: imageKey) {
                    result in
                    switch result {
                    case .success:
                        break
                    case .failure(_):
                        break
                    }
                }
            }
            let imageAttribute = AuthUserAttribute(.picture, value: imageKey)
            Amplify.Auth.update(userAttribute: imageAttribute) { [self]
                result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        userImage.image = selectedImage
                    }
                case .failure(_):
                    Alert.showWarning(self, "Failed", "Fail to upload profile image")
                }
            }
        }
    }
    
    private func getUserProfileImageKey(_ successHandler: @escaping (String) -> Void) {
        Amplify.Auth.fetchUserAttributes() {
            result in
            switch result {
            case .success(let attributes):
                for attribute in attributes {
                    if attribute.key == .picture {
                        successHandler(attribute.value)
                        break
                    }
                }
            case .failure(_):
                Alert.showWarning(self, "Failed", "Fail to download profile image")
            }
        }
    }
    
    private func downloadUserProfileImage(_ imageKey: String) {
        DispatchQueue.global().async {
            Amplify.Storage.downloadData(key: imageKey) { [self]
                result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        userImage.image = UIImage(data: imageData)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        Alert.showWarning(self, "Failed", "Fail to download profile image")
                    }
                }
            }
        }
    }
    
    
    @IBAction func editUserPic(_ sender: Any) {
        let editImageAlert = UIAlertController(title: "Please choose action", message: "", preferredStyle: UIAlertController.Style.actionSheet)
           
        let chooseFromPhotoLibrary = UIAlertAction(title: "Choose From Photo Library", style: UIAlertAction.Style.default, handler: ChooseFromPhotoLibrary)
        editImageAlert.addAction(chooseFromPhotoLibrary)
           
        let chooseFromTheCamera = UIAlertAction(title: "Choose From Camera", style: UIAlertAction.Style.default,handler:ChooseFromCamera)
        editImageAlert.addAction(chooseFromTheCamera)
        
        let saveCurrentImage = UIAlertAction(title: "save Current Image", style: UIAlertAction.Style.default,handler:SaveCurrentImage)
        editImageAlert.addAction(saveCurrentImage)
        
        let canelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,handler: nil)
        editImageAlert.addAction(canelAction)
           
        self.present(editImageAlert, animated: true, completion: nil)
    }
    
    
    func ChooseFromPhotoLibrary(avc:UIAlertAction)-> Void{
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func ChooseFromCamera(avc:UIAlertAction) -> Void{
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func SaveCurrentImage(avc:UIAlertAction)-> Void{
        UIImageWriteToSavedPhotosAlbum(userImage.image!,self,#selector(MeViewController.image(image:didFinishSavingWithError:contextInfo:)),nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
    
        if error == nil {
           let ac = UIAlertController(title: "Saved!", message: "image has been saved to your photos." , preferredStyle: .alert)
           ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
           present(ac, animated:true, completion:nil)
        } else{
           let ac = UIAlertController(title:"Save error", message: error?.localizedDescription,preferredStyle: .alert)
           ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
           present(ac, animated:true, completion:nil)
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        signOutLocally()
    }
    
    @IBAction func userProfileEdit(_ sender: Any) {
        
    }
}

