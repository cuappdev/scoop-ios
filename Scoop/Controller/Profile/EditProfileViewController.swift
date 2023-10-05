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
    
    private let classTextField = UITextField()
    private let hometownTextField = UITextField()
    private let nameTextField = UITextField()
    private let profileImageView = UIImageView()
    private let pronounsTextField = UITextField()
    private let stackView = UIStackView()
    private let uploadPhotoButton = UIButton()
    
    weak var delegate: ProfileViewDelegate?
    
    // MARK: - User Data
    
    private var user: BaseUser?
    
    private var hometown: String?
    private var music: Float?
    private var snack: String?
    private var song: String?
    private var stop: String?
    private var talkative: Float?
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupHeader()
        setupProfileImageView()
        setupUploadPhotoButton()
        setupStackView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        uploadPhotoButton.layer.cornerRadius = uploadPhotoButton.frame.size.width / 2
    }
    
    // TODO: Temporary while save button is not implemented
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
            profileImageView.image = UIImage.emptyImage
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
        let dottedline = UIImageView(image: UIImage.dottedLine)
        let solidline = UIView()
        
        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)
        
        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        solidline.backgroundColor = UIColor.black
        view.addSubview(solidline)
        
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.flowHeader]
    }
    
    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
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
        uploadPhotoButton.setImage(UIImage.profileButton, for: .normal)
        uploadPhotoButton.backgroundColor = UIColor.gray
        uploadPhotoButton.contentMode = .scaleAspectFill
        uploadPhotoButton.clipsToBounds = true
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
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        nameTextField.font = UIFont.textField
        nameTextField.textColor = UIColor.black
        nameTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        pronounsTextField.attributedPlaceholder = NSAttributedString(
            string: "Pronouns",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        pronounsTextField.font = UIFont.textField
        pronounsTextField.textColor = UIColor.black
        pronounsTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        hometownTextField.attributedPlaceholder = NSAttributedString(
            string: "Hometown",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        hometownTextField.font = UIFont.textField
        hometownTextField.textColor = UIColor.black
        hometownTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        classTextField.attributedPlaceholder = NSAttributedString(
            string: "Class Year",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        classTextField.font = UIFont.textField
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
            switch prompt.questionName {
            case .hometown:
                userAnswers.append(UserAnswer(id: prompt.id, answer: hometown ?? ""))
            case .music:
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(music ?? 0)))
            case .song:
                userAnswers.append(UserAnswer(id: prompt.id, answer: song ?? ""))
            case .snack:
                userAnswers.append(UserAnswer(id: prompt.id, answer: snack ?? ""))
            case .stop:
                userAnswers.append(UserAnswer(id: prompt.id, answer: stop ?? ""))
            case .talkative:
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(talkative ?? 0)))
            }
        }
        
        // MARK: - Requests
        
        NetworkManager.shared.updateAuthenticatedUser(
            netid: user?.netid ?? "",
            first_name: firstName,
            last_name: lastName,
            grade: grade ?? "",
            phone_number: user?.phoneNumber ?? "",
            pronouns: pronouns ?? "",
            prof_pic: user?.profilePicUrl ?? "",
            prompts: userAnswers
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                NetworkManager.shared.currentUser = user
                self.delegate?.updateProfileText(user: user)
            case .failure(let error):
                print("Error in EditProfileViewController: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: Temporary while not all input fields are implemented
    private func getUserPreferences() {
        user?.prompts.forEach { prompt in
            switch prompt.questionName {
            case .hometown:
                hometown = prompt.answer
            case .music:
                guard let musicFloat = Float(prompt.answer ?? "0") else { return }
                music = musicFloat
            case .song:
                song = prompt.answer
            case .snack:
                snack = prompt.answer
            case .stop:
                stop = prompt.answer
            case .talkative:
                guard let talkativeFloat = Float(prompt.answer ?? "0") else { return }
                talkative = talkativeFloat
            }
        }
    }
    
}
