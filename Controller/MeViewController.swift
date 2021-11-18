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
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logoutButton.layer.borderWidth = 1.5
        logoutButton.layer.cornerRadius = 10
        takePicButton.layer.borderWidth = 1.5
        takePicButton.layer.cornerRadius = 10
        
        userImage.layer.cornerRadius = userImage.frame.width/2
        userImage.layer.masksToBounds = true

        DispatchQueue.global().async { [self] in
            getUserProfileImageKey() {
                imageKey in
                downloadUserProfileImage(imageKey)
            }
        }
    }
    
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SignUpView())
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.showWarning(self, "Failed", "Sign out failed with error \(error)")
                }
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
                    Alert.showWarning(self, "Failed", "Fail to download profile image")
                }
            }
        }
    }
    
    @IBAction func editUserImage(_ sender: Any) {
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
    
    @IBAction func LogOutPressed(_ sender: Any) {
        signOutLocally()
    }
    
}
