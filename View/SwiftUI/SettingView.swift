//
//  SettingView.swift
//  Together
//
//  Created by lcx on 2021/11/28.
//

import SwiftUI
import Amplify

struct SettingView: View {
    @StateObject private var user = UserViewModel()
    @State private var isShowingPhotoPicker = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        if let image = user.profilePhoto {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75, alignment: .center)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isShowingPhotoPicker = true
                                }
                                .sheet(isPresented: $isShowingPhotoPicker, content: {
                                    PhotoPicker(image: $user.profilePhoto)
                                })
                        }
                        VStack(alignment: .leading) {
                            Text(user.nickname)
                                .foregroundColor(.primary)
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section(header: HStack {
                    Text("Profile")
                    Spacer()
                    if isEditing {
                        Button("Done") {
                            UIApplication.shared.endEditing()
                            isEditing.toggle()
                        }
                        .textCase(.none)
                    } else {
                        Button("Edit") {
                            isEditing.toggle()
                        }
                        .textCase(.none)
                    }
                    
                }) {
                    HStack {
                        Text("First Name")
                        TextField("", text: $user.firstName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .disabled(!isEditing)
                    }
                    HStack {
                        Text("Last Name")
                        TextField("", text: $user.lastName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Gender")
                        TextField("", text: $user.gender)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Phone Number")
                        TextField("", text: $user.phone)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Reset Password") {
                            
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button("Log Out") {
                            signOut()
                        }
                        .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
    
    private func signOut() {
        Amplify.Auth.signOut() {
            switch $0 {
            case .success:
                DispatchQueue.global().async {
                    Amplify.DataStore.stop { _ in
                        DispatchQueue.main.async {
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SignUpView())
                        }
                    }
                }
            case .failure(_):
//                DispatchQueue.main.async {
//                    Alert.showWarning(self, "Failed", "Sign out failed with error \(error)")
//                }
                break
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                guard let imageData = image.jpegData(compressionQuality: 0.1),
                      let compressedImage = UIImage(data: imageData),
                      let imageKey = Amplify.Auth.getCurrentUser()?.username
                else {
                    return
                }
                Amplify.Storage.uploadData(key: imageKey, data: imageData) {
                    result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.photoPicker.image = compressedImage
                        }
                    case .failure(_):
                        break
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
