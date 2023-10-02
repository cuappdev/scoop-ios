//
//  EditProfileViewController.swift
//  Scoop
//
//  Created by Caitlyn Jin on 9/27/23.
//

import SDWebImage
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
    
    weak var delegate: ProfileViewDelegate?
    
    // MARK: - User Data
    
    private var user: BaseUser?
    
    private var hometown: String?
    private var talkative: Float?
    private var music: Float?
    private var snack: String?
    private var song: String?
    private var stop: String?
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupHeader()
        setupProfileImageView()
        setupUploadPhotoButton()
        setupStackView()
    }
    
    /// Temporary while save button is not implemented
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        getUserPreferences()
        updateUser()
    }
    
    // MARK: - Initializers
    
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
        
        nameTextField.textColor = UIColor.black
        nameTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        pronounsTextField.textColor = UIColor.black
        pronounsTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        hometownTextField.textColor = UIColor.black
        hometownTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        classTextField.textColor = UIColor.black
        classTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(classTextField)
        
        classTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
    // MARK: - Helper Functions
    
    private func updateUser() {
        let name = nameTextField.text?.split(separator: " ")
        let firstName = String(name?[0] ?? "")
        let lastName = String(name?[1...].joined(separator: " ") ?? "")
        let grade = classTextField.text
        let pronouns = pronounsTextField.text
        
        hometown = hometownTextField.text
        
        var userAnswers: [UserAnswer] = []
                
        user?.prompts.forEach { prompt in
            if prompt.questionName == "Hometown" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: hometown ?? ""))
            } else if prompt.questionName == "Talkative" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(talkative ?? 0)))
            } else if prompt.questionName == "Music" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(music ?? 0)))
            } else if prompt.questionName == "Snack" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: snack ?? ""))
            } else if prompt.questionName == "Song" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: song ?? ""))
            } else if prompt.questionName == "Stop" {
                userAnswers.append(UserAnswer(id: prompt.id, answer: stop ?? ""))
            }
        }
        
        NetworkManager.shared.updateAuthenticatedUser(netid: user?.netid ?? "", first_name: firstName, last_name: lastName, grade: grade ?? "", phone_number: user?.phoneNumber ?? "", pronouns: pronouns ?? "", prof_pic: user?.profilePicUrl ?? "", prompts: userAnswers) { result in
            switch result {
            case .success(let user):
                NetworkManager.shared.currentUser = user
                self.delegate?.updateUserProfile()
            case .failure(let error):
                print("Error in EditProfileViewController: \(error.localizedDescription)")
            }
        }
    }
    
    /// Temporary while not all input fields are implemented
    private func getUserPreferences() {
        user?.prompts.forEach { prompt in
            if prompt.questionName == "Hometown" {
                hometown = prompt.answer
            } else if prompt.questionName == "Talkative" {
                guard let talkativeFloat = Float(prompt.answer ?? "0") else { return }
                talkative = talkativeFloat
            } else if prompt.questionName == "Music" {
                guard let musicFloat = Float(prompt.answer ?? "0") else { return }
                music = musicFloat
            } else if prompt.questionName == "Snack" {
                snack = prompt.answer
            } else if prompt.questionName == "Song" {
                song = prompt.answer
            } else if prompt.questionName == "Stop" {
                stop = prompt.answer
            }
        }
    }
    
}
