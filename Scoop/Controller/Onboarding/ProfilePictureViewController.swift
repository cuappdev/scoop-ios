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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Profile Picture"
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else { return }
            
            guard let image = self.pictureImageView.image else {
                self.presentErrorAlert(title: "Error", message: "Please select an image.")
                return
            }
            
            Networking.shared.currentUser.image = image
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", image: nil, primaryAction: nextAction, menu: nil)
        
        setupImagePicker()
        setupPictureImageView()
        setupTitleLabel()
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
        view.addSubview(pictureImageView)
        
        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadProfilePicture))
        pictureImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.text = "Hi Reade! Let's begin by adding a profile picture."
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.bottom.equalTo(pictureImageView.snp.top).offset(-40)
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
