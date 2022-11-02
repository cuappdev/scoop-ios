//
//  ProfilePictureViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit

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
            
            Networking.shared.currentUser.image = image
            self.dismiss(animated: true)
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
        pictureImageView.layer.borderColor = UIColor(red: 0.376, green: 0.749, blue: 0.627, alpha: 1).cgColor
        pictureImageView.layer.borderWidth = 3
        view.addSubview(pictureImageView)
        
        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadProfilePicture))
        pictureImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupButtons() {
        let buttonMultiplier = 0.09
        let screenSize = UIScreen.main.bounds
        let skipAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        skipButton.setTitle("  Add photo later  ", for: .normal)
        skipButton.backgroundColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1)
        skipButton.layer.cornerRadius = 10
        skipButton.addAction(skipAction, for: .touchUpInside)
        view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(49)
            make.width.equalTo(193)
            make.top.equalTo(pictureImageView.snp.bottom).inset(-screenSize.height * buttonMultiplier)
            make.centerX.equalToSuperview()
        }
        
        uploadButton.setTitle("  Upload  ", for: .normal)
        uploadButton.backgroundColor = UIColor(red: 0.227, green: 0.573, blue: 0.459, alpha: 1)
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
