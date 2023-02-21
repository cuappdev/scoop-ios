//
//  ProfilePictureViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit
import SDWebImage

class ProfilePictureViewController: OnboardingViewController {
    
    private let imagePicker = UIImagePickerController()
    private let titleLabel = UILabel()
    private let pictureImageView = UIImageView()
    private let profileButton = UIButton()
    private let skipButton = UIButton()
    private let uploadButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "Profile")
        
        nextAction = UIAction { _ in
            guard let image = self.pictureImageView.image else {
                self.presentErrorAlert(title: "Error", message: "Please select an image.")
                return
            }
            
            self.updateAuthenticatedUser(image: image)
            
        }
        
        setupTitleLines()
        setupImagePicker()
        setupPictureImageView()
        setupProfileButton()
        setupButtons()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.backgroundColor = .systemGray5
        pictureImageView.isUserInteractionEnabled = true
        pictureImageView.clipsToBounds = true
        pictureImageView.layer.cornerRadius = 100
        pictureImageView.layer.borderColor = UIColor.scoopGreen.cgColor
        pictureImageView.layer.borderWidth = 3
        view.addSubview(pictureImageView)
        
        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadProfilePicture))
        pictureImageView.addGestureRecognizer(tapGesture)
    }
    
    private func updateAuthenticatedUser(image: UIImage) {
        let imageBase64 = convertImage(image: image)
        
        NetworkManager.shared.currentUser.profilePicUrl = imageBase64
        let user = NetworkManager.shared.currentUser
        //MARK: Request works, but deocding error with image, since backend debugging still in progress
        NetworkManager.shared.updateAuthenticatedUser(netid: user.netid, first_name: user.firstName, last_name: user.lastName, grade: user.grade, phone_number: user.phoneNumber, pronouns: user.pronouns, prof_pic: imageBase64) { result in
            switch result {
            case .success(let user):
                print("\(user.firstName) has been updated")
                self.dismiss(animated: true)
            case .failure:
                return
            }
        }
    }
    
    private func convertImage (image: UIImage) -> String {
        let base64 = image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        return "data:image/png;base64," + base64
    }
    
    private func setupButtons() {
        let buttonMultiplier = 0.09
        let screenSize = UIScreen.main.bounds
        let skipAction = UIAction { _ in
            if let placeholder = UIImage(named: "emptyimage"){
                self.updateAuthenticatedUser(image: placeholder)
            }
            self.dismiss(animated: true)
        }
        
        skipButton.setTitle("Add photo later", for: .normal)
        if #available(iOS 15.0, *) {
            skipButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19)
        } else {
            skipButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
        }
        skipButton.backgroundColor = UIColor.skipButtonColor
        skipButton.layer.cornerRadius = 10
        skipButton.addAction(skipAction, for: .touchUpInside)
        view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(49)
            make.width.equalTo(193)
            make.top.equalTo(pictureImageView.snp.bottom).inset(-screenSize.height * buttonMultiplier)
            make.centerX.equalToSuperview()
        }
        
        uploadButton.setTitle("Upload", for: .normal)
        if #available(iOS 15.0, *) {
            uploadButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 64)
        } else {
            uploadButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 64)
        }
        uploadButton.backgroundColor = UIColor.scoopGreen
        uploadButton.layer.cornerRadius = 10
        uploadButton.addAction(nextAction ?? UIAction(handler: { _ in
            return
        }), for: .touchUpInside)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { make in
            make.height.equalTo(49)
            make.width.equalTo(193)
            make.top.equalTo(skipButton.snp.bottom).inset(-27)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupProfileButton() {
        profileButton.setImage(UIImage(named: "profilebutton"), for: .normal)
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(uploadProfilePicture), for: .touchUpInside)
        view.addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.height.equalTo(43)
            make.width.equalTo(43)
            make.bottom.equalTo(pictureImageView.snp.bottom)
            make.trailing.equalTo(pictureImageView.snp.trailing)
        }
    }
    
    @objc
    private func uploadProfilePicture(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true)
    }
}

// MARK: UIImagePickerControllerDelegate
extension ProfilePictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        pictureImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
