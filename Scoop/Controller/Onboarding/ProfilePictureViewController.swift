//
//  ProfilePictureViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit

class ProfilePictureViewController: OnboardingViewController {
    
    weak var containerDelegate: AnimationDelegate?
    
    // MARK: - Views
    
    private let imagePicker = UIImagePickerController()
    private let titleLabel = UILabel()
    private let pictureImageView = UIImageView()
    private let profileButton = UIButton()
    private let skipButton = UIButton()
    private let uploadButton = UIButton()
    private let loadingSpinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializers
    
    init(containerDelegate: AnimationDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.containerDelegate = containerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "Profile")
        
        nextAction = UIAction { _ in
            self.loadingSpinner.startAnimating()
            guard let image = self.pictureImageView.image else {
                self.presentErrorAlert(title: "Error", message: "Please select an image.")
                self.loadingSpinner.stopAnimating()
                return
            }
            
            self.updateAuthenticatedUser(image: image)
            
        }
        
        updateBackButton()
        setupTitleLines()
        setupImagePicker()
        setupPictureImageView()
        setupProfileButton()
        setupButtons()
    }
    
    // MARK: - Setup View Functions
    
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
        pictureImageView.layer.borderColor = UIColor.scooped.scoopGreen.cgColor
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
            if let placeholder = UIImage(named: "emptyimage"){
                self.updateAuthenticatedUser(image: placeholder)
            }
            self.dismiss(animated: true)
        }
        
        uploadButton.setTitle("Upload photo", for: .normal)
        if #available(iOS 15.0, *) {
            uploadButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 64)
        } else {
            uploadButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 64)
        }
        uploadButton.backgroundColor = UIColor.scooped.disabledGreen
        uploadButton.layer.cornerRadius = 25
        uploadButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        uploadButton.addAction(nextAction ?? UIAction(handler: { _ in
            return
        }), for: .touchUpInside)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.width.equalTo(296)
            make.top.equalTo(pictureImageView.snp.bottom).inset(-screenSize.height * buttonMultiplier)
            make.centerX.equalToSuperview()
        }
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAddLaterString = NSAttributedString(string: "Add later", attributes: underlineAttribute)
        skipButton.setAttributedTitle(underlineAddLaterString, for: .normal)
        skipButton.setTitleColor(UIColor.scooped.scoopDarkGreen, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        skipButton.addAction(skipAction, for: .touchUpInside)
        view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(49)
            make.width.equalTo(193)
            make.top.equalTo(uploadButton.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
        }
        
        loadingSpinner.backgroundColor = .black
        loadingSpinner.layer.opacity = 0.5
        loadingSpinner.layer.cornerRadius = 10
        loadingSpinner.color = .white
        view.addSubview(loadingSpinner)
        
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
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
    
    // MARK: - Helper Functions
    
    private func updateAuthenticatedUser(image: UIImage) {
        let imageBase64 = convertImage(image: image)
        uploadButton.backgroundColor = UIColor.scooped.disabledGreen
        
        NetworkManager.shared.currentUser.profilePicUrl = imageBase64
        let user = NetworkManager.shared.currentUser
        let answers = NetworkManager.shared.userPromptAnswers
        guard let grade = user.grade,
              let phoneNumber = user.phoneNumber,
              let pronouns = user.pronouns else { return }

        NetworkManager.shared.updateAuthenticatedUser(netid: user.netid, first_name: user.firstName, last_name: user.lastName, grade: grade, phone_number: phoneNumber, pronouns: pronouns, prof_pic: imageBase64, prompts: answers) { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let user):
                print("\(user.firstName) has been updated")
                strongSelf.dismiss(animated: true)
                strongSelf.containerDelegate?.dismiss(animated: true)
                NetworkManager.shared.profileDelegate?.updateUserProfile()
                strongSelf.uploadButton.backgroundColor = UIColor.scooped.scoopDarkGreen
                strongSelf.loadingSpinner.stopAnimating()
                if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    scene.didCompleteLogin()
                }
            case .failure(let error):
                print("Auth Error in ProfilePictureViewController: \(error.localizedDescription)")
                strongSelf.loadingSpinner.stopAnimating()
                strongSelf.displayUserError()
                return
            }
        }
        
        DispatchQueue.main.async {
            NetworkManager.shared.profileDelegate?.updateUserProfile()
        }
    }
    
    private func convertImage (image: UIImage) -> String {
        let base64 = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        return "data:image/png;base64," + base64
    }
    
    private func displayUserError() {
        presentErrorAlert(title: "Unable to Create Account", message: "There was an error while creating your account. Please try again at another time.")
    }
    
    @objc private func uploadProfilePicture(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfilePictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        pictureImageView.image = image
        uploadButton.backgroundColor = UIColor.scooped.scoopDarkGreen
        uploadButton.setTitleColor(.white, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
