//
//  EditProfileViewController.swift
//  Scoop
//
//  Created by Caitlyn Jin on 9/27/23.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Views
    
    private let profileImageView = UIImageView()
    private let uploadPhotoButton = UIButton()
    
    private let stackView = UIStackView()
    private let nameTextField = UITextField()
    private let pronounsTextField = UITextField()
    private let hometownTextField = UITextField()
    private let classTextField = UITextField()
    
    private var user: BaseUser?
    private var hometown: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupHeader()
        setupProfileImageView()
        setupUploadPhotoButton()
        setupStackView()
    }
    
    init(user: BaseUser, hometown: String) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        if let profilePicUrl = user.profilePicUrl {
            profileImageView.sd_setImage(with: URL(string: profilePicUrl))
        } else {
            profileImageView.image = UIImage(named: "emptyimage")
        }
        nameTextField.text = "\(user.firstName) \(user.lastName)"
        pronounsTextField.text = user.pronouns
        hometownTextField.text = hometown
        classTextField.text = user.grade
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View Functions
    
    private func setupHeader() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage(named: "dottedline"))
        let solidline = UIView()
        
        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)
        
        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        solidline.backgroundColor = .black
        view.addSubview(solidline)
        
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)]
    }
    
    private func setupProfileImageView() {
//        profileImageView.image = UIImage(named: "emptyimage")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.borderColor = UIColor.scoopGreen.cgColor
        profileImageView.layer.borderWidth = 3
        view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupUploadPhotoButton() {
        uploadPhotoButton.setImage(UIImage(named: "profilebutton"), for: .normal)
        uploadPhotoButton.backgroundColor = .red
        uploadPhotoButton.contentMode = .scaleAspectFill
        uploadPhotoButton.clipsToBounds = true
        uploadPhotoButton.layer.cornerRadius = 13
        view.addSubview(uploadPhotoButton)
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(96)
            make.size.equalTo(26)
            make.leading.equalTo(profileImageView).offset(85)
            make.trailing.equalTo(profileImageView).offset(-9)
        }
    }

    private func setupStackView() {
        let leadingTrailingInset = 32
        let textFieldHeight = 56
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
//        nameTextField.text = "Name"
        nameTextField.textColor = UIColor.black
        nameTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
//        pronounsTextField.text = "Pronouns"
        pronounsTextField.textColor = UIColor.black
        pronounsTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
//        hometownTextField.text = "Hometown"
        hometownTextField.textColor = UIColor.black
        hometownTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
//        classTextField.text = "Class"
        classTextField.textColor = UIColor.black
        classTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(classTextField)
        
        classTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
}
