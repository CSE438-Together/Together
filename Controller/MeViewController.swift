//
//  MeViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

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
                    print("Sign out failed with error \(error)")
                    self.alert(title: "Failed", message: "Sign out failed with error \(error)")
                })
            }
        }
    }

    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       guard let selectedImage = info[.originalImage] as? UIImage else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        userImage.image = selectedImage
        
        dismiss(animated:true, completion: nil)

            
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
