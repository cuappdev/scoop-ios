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
    
    private let cancelButton = UIButton()
    private let classTextField = LabeledTextField()
    private let classPicker = UIPickerView()
    private let deleteButton = UIButton()
    private let emailButton = UIButton()
    private let gradientLayer = CAGradientLayer()
    private let hometownTextField = LabeledTextField()
    private let imagePicker = UIImagePickerController()
    private let gradientView = UIView()
    private let imageView = UIView()
    private let musicSlider = UISlider()
    private let musicTicks = UIButton()
    private let musicView = UIView()
    private let nameTextField = LabeledTextField()
    private let phoneButton = UIButton()
    private let phoneNumTextField = LabeledTextField()
    private let profileImageView = UIImageView()
    private let pronounsPicker = UIPickerView()
    private let pronounsTextField = LabeledTextField()
    private let saveButton = UIButton()
    private let snackTextField = LabeledTextField()
    private let songTextField = LabeledTextField()
    private let stopTextField = LabeledTextField()
    private let talkativeSlider = UISlider()
    private let talkativeView = UIView()
    private let talkativeTicks = UIButton()
    private let uploadPhotoButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let aboutYouStackView = UIStackView()
    private let preferredContactStackView = UIStackView()
    private let preferencesStackView = UIStackView()
    private let favoritesStackView = UIStackView()
    
    weak var delegate: ProfileViewDelegate?
    
    // MARK: - User Data
    
    private var user: BaseUser?
    
    private var hometown: String?
    private var music: Float?
    private var snack: String?
    private var song: String?
    private var stop: String?
    private var talkative: Float?
    
    // MARK: - Constants

    private struct Constants {
        static let bottomInset = 36
        static let buttonCornerRadius = CGFloat(25)
        static let buttonHeight = 50
        static let buttonLeadingTrailingInset = 24
        static let buttonWidth = 104
        static let leadingTrailingInset = 32
        static let textFieldHeight = 56
    }
    
    private let pronouns = PickerOptions.scooped.pronouns
    private let years = PickerOptions.scooped.years
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        dismissKeyboardFromPan()

        setupHeader()
        setupScrollView()
        setupMainStackView()
        setupImagePicker()
        setupImageView()
        setupAboutYouStackView()
        setupPreferredContactStackView()
        setupPreferencesStackView()
        setupFavoritesStackView()
        setupDeleteButton()
        setupGradientView()
        setupCancelButton()
        setupSaveButton()
        setupTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let hoverViewTransparentOffset = CGFloat(30)

        scrollView.contentSize = CGSizeMake(mainStackView.frame.width, mainStackView.frame.height + gradientView.bounds.height - hoverViewTransparentOffset)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        uploadPhotoButton.layer.cornerRadius = uploadPhotoButton.frame.size.width / 2
        gradientLayer.frame = gradientView.bounds
    }
    
    // MARK: - Initializers
    
    init(user: BaseUser, hometown: String, talkative: Float, music: Float, snack: String, song: String, stop: String) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        
        if let profilePicUrl = user.profilePicUrl {
            profileImageView.sd_setImage(with: URL(string: profilePicUrl))
        } else {
            profileImageView.image = UIImage.scooped.emptyImage
        }
        
        nameTextField.setText(str: "\(user.firstName) \(user.lastName)")
        pronounsTextField.setText(str: user.pronouns)
        hometownTextField.setText(str: hometown)
        classTextField.setText(str: user.grade)
        phoneNumTextField.setText(str: user.phoneNumber)
        talkativeSlider.setValue(talkative, animated: false)
        musicSlider.setValue(music, animated: false)
        snackTextField.setText(str: snack)
        songTextField.setText(str: song)
        stopTextField.setText(str: stop)
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
        let dottedline = UIImageView(image: UIImage.scooped.dottedLine)
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
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.scooped.flowHeader]
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
        }
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 50
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        scrollView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func setupImageView() {
        mainStackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.scooped.scoopGreen.cgColor
        profileImageView.layer.borderWidth = 3
        imageView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        uploadPhotoButton.setImage(UIImage.scooped.profileButton, for: .normal)
        uploadPhotoButton.backgroundColor = UIColor.gray
        uploadPhotoButton.contentMode = .scaleAspectFill
        uploadPhotoButton.clipsToBounds = true
        uploadPhotoButton.addTarget(self, action: #selector(updateProfileImage), for: .touchUpInside)
        imageView.addSubview(uploadPhotoButton)
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(96)
            make.size.equalTo(26)
            make.leading.equalTo(profileImageView).offset(84)
            make.trailing.equalTo(profileImageView).offset(-8)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateProfileImage))
        imageView.addGestureRecognizer(tapGesture)
    }

    private func setupAboutYouStackView() {
        aboutYouStackView.axis = .vertical
        aboutYouStackView.distribution = .fill
        aboutYouStackView.alignment = .leading
        aboutYouStackView.spacing = 24
        mainStackView.addArrangedSubview(aboutYouStackView)
        
        aboutYouStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
            make.top.equalTo(imageView.snp.bottom).offset(24)
        }
        
        nameTextField.setup(title: "Name")
        aboutYouStackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.setup(title: "Pronouns")
        pronounsTextField.textField.inputView = pronounsPicker
        aboutYouStackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        hometownTextField.setup(title: "Hometown")
        aboutYouStackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        classPicker.delegate = self
        classPicker.dataSource = self
        
        classTextField.setup(title: "Class")
        classTextField.textField.inputView = classPicker
        aboutYouStackView.addArrangedSubview(classTextField)
        
        classTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
    }
    
    private func setupPreferredContactStackView() {
        preferredContactStackView.axis = .vertical
        preferredContactStackView.distribution = .fill
        preferredContactStackView.alignment = .leading
        preferredContactStackView.spacing = 20
        mainStackView.addArrangedSubview(preferredContactStackView)
        
        preferredContactStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
        }

        let titleLabel = UILabel()
        titleLabel.font = UIFont.scooped.subheader
        titleLabel.text = "PREFERRED CONTACT METHOD"
        titleLabel.accessibilityLabel = "preferred contact method"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.black
        preferredContactStackView.addArrangedSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        emailButton.isSelected = true
        emailButton.setTitle("Cornell email", for: .normal)
        emailButton.setTitleColor(UIColor.black, for: .normal)
        emailButton.titleLabel?.font = UIFont.scooped.bodyNormal
        emailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        emailButton.setImage(UIImage(systemName: "circle"), for: .normal)
        emailButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        emailButton.tintColor = UIColor.black
        emailButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        preferredContactStackView.addArrangedSubview(emailButton)

        emailButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
        }
        
        phoneButton.setTitle("Phone number", for: .normal)
        phoneButton.setTitleColor(UIColor.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont.scooped.bodyNormal
        phoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        phoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
        phoneButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        phoneButton.tintColor = UIColor.black
        phoneButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        phoneButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        preferredContactStackView.addArrangedSubview(phoneButton)

        phoneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
        }
        
        let selectContactAction = UIAction { [self] action in
            if let button = action.sender as? UIButton {
                if button.isSelected { return }
            }
            
            emailButton.isSelected.toggle()
            phoneButton.isSelected.toggle()

            phoneNumTextField.isHidden = emailButton.isSelected
            view.layoutIfNeeded()
        }

        emailButton.addAction(selectContactAction, for: .touchUpInside)
        phoneButton.addAction(selectContactAction, for: .touchUpInside)
        
        phoneNumTextField.setup(title: "Phone", placeholder: "000-000-0000")
        phoneNumTextField.isHidden = true
        phoneNumTextField.textField.keyboardType = .phonePad
        preferredContactStackView.addArrangedSubview(phoneNumTextField)

        phoneNumTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
    }
    
    private func setupPreferencesStackView() {
        preferencesStackView.axis = .vertical
        preferencesStackView.distribution = .fill
        preferencesStackView.alignment = .leading
        preferencesStackView.spacing = 12
        mainStackView.addArrangedSubview(preferencesStackView)
        
        preferencesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
        }
        
        let talkativeTitleLabel = UILabel()
        talkativeTitleLabel.font = UIFont.scooped.subheader
        talkativeTitleLabel.text = "HOW TALKATIVE ARE YOU?"
        talkativeTitleLabel.accessibilityLabel = "how talkative are you?"
        talkativeTitleLabel.numberOfLines = 2
        talkativeTitleLabel.textColor = UIColor.black
        preferencesStackView.addArrangedSubview(talkativeTitleLabel)
        
        talkativeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        setupTalkativeSliderView()
        
        preferencesStackView.setCustomSpacing(50, after: talkativeSlider)
        
        let musicTitleLabel = UILabel()
        musicTitleLabel.font = UIFont.scooped.subheader
        musicTitleLabel.text = "DO YOU LIKE LISTENING TO MUSIC?"
        musicTitleLabel.accessibilityLabel = "do you like listening to music"
        musicTitleLabel.numberOfLines = 2
        musicTitleLabel.textColor = UIColor.black
        preferencesStackView.addArrangedSubview(musicTitleLabel)
        
        musicTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        setupMusicSliderView()
    }
    
    private func setupTalkativeSliderView() {
        let leadingInset = 28

        preferencesStackView.addArrangedSubview(talkativeView)
        
        talkativeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview()
        }
        
        let quietLabel = UILabel()
        quietLabel.text = "Quiet"
        quietLabel.textColor = UIColor.black
        quietLabel.font = UIFont.scooped.bodyNormal
        quietLabel.textAlignment = .left
        quietLabel.adjustsFontSizeToFitWidth = true
        talkativeView.addSubview(quietLabel)
        
        quietLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        let talkativeLabel = UILabel()
        talkativeLabel.text = "Talkative"
        talkativeLabel.textColor = UIColor.black
        talkativeLabel.font = UIFont.scooped.bodyNormal
        talkativeLabel.textAlignment = .right
        talkativeLabel.adjustsFontSizeToFitWidth = true
        talkativeView.addSubview(talkativeLabel)
        
        talkativeLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        talkativeSlider.minimumTrackTintColor = UIColor.black
        talkativeSlider.maximumTrackTintColor = UIColor.black
        talkativeSlider.setThumbImage(UIImage.scooped.sliderThumb, for: .normal)
        preferencesStackView.addArrangedSubview(talkativeSlider)

        talkativeSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
        }
        
        talkativeTicks.setImage(UIImage.scooped.sliderTicks, for: .normal)
        talkativeSlider.addSubview(talkativeTicks)
        talkativeSlider.sendSubviewToBack(talkativeTicks)
        
        talkativeTicks.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupMusicSliderView() {
        let leadingInset = 28

        preferencesStackView.addArrangedSubview(musicView)
        
        musicView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview()
        }
        
        let noMusicLabel = UILabel()
        noMusicLabel.text = "No music"
        noMusicLabel.textColor = UIColor.black
        noMusicLabel.font = UIFont.scooped.bodyNormal
        noMusicLabel.textAlignment = .left
        noMusicLabel.adjustsFontSizeToFitWidth = true
        musicView.addSubview(noMusicLabel)
        
        noMusicLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        let musicLabel = UILabel()
        musicLabel.text = "Music"
        musicLabel.textColor = UIColor.black
        musicLabel.font = UIFont.scooped.bodyNormal
        musicLabel.textAlignment = .right
        musicLabel.adjustsFontSizeToFitWidth = true
        musicView.addSubview(musicLabel)
        
        musicLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        musicSlider.minimumTrackTintColor = UIColor.black
        musicSlider.maximumTrackTintColor = UIColor.black
        musicSlider.setThumbImage(UIImage.scooped.sliderThumb, for: .normal)
        preferencesStackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
        }
        
        musicTicks.setImage(UIImage.scooped.sliderTicks, for: .normal)
        musicSlider.addSubview(musicTicks)
        musicSlider.sendSubviewToBack(musicTicks)
        
        musicTicks.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupFavoritesStackView() {
        favoritesStackView.axis = .vertical
        favoritesStackView.distribution = .fill
        favoritesStackView.alignment = .leading
        favoritesStackView.spacing = 24
        mainStackView.addArrangedSubview(favoritesStackView)
        
        favoritesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
        }
        
        snackTextField.setup(title: "Roadtrip snack")
        favoritesStackView.addArrangedSubview(snackTextField)
        
        snackTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        songTextField.setup(title: "Roadtrip song")
        favoritesStackView.addArrangedSubview(songTextField)
        
        songTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        stopTextField.setup(title: "Roadtrip stop")
        favoritesStackView.addArrangedSubview(stopTextField)
        
        stopTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
    }

    func setupDeleteButton() {
        deleteButton.setTitle("Delete account", for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.titleLabel?.font = UIFont.scooped.bodyBold
        deleteButton.backgroundColor = UIColor.scooped.notification
        deleteButton.layer.cornerRadius = Constants.buttonCornerRadius
        mainStackView.addArrangedSubview(deleteButton)

        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)

        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    private func setupGradientView() {
        gradientLayer.colors = UIColor.scooped.whiteGradientColors
        gradientView.isUserInteractionEnabled = false
        gradientView.layer.insertSublayer(gradientLayer, at: 1)
        view.addSubview(gradientView)
        
        gradientView.snp.makeConstraints { make in
            make.bottom.width.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.scooped.darkerGreen, for: .normal)
        cancelButton.titleLabel?.font = UIFont.scooped.bodySemibold
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.borderColor = UIColor.systemGray2.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = Constants.buttonCornerRadius
        view.addSubview(cancelButton)

        cancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.buttonLeadingTrailingInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.bottomInset)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.scooped.offBlack, for: .normal)
        saveButton.titleLabel?.font = UIFont.scooped.bodyBold
        saveButton.backgroundColor = UIColor.scooped.secondaryGreen
        saveButton.layer.cornerRadius = Constants.buttonCornerRadius
        view.addSubview(saveButton)

        saveButton.addTarget(self, action: #selector(saveEdit), for: .touchUpInside)
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.buttonLeadingTrailingInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.bottomInset)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func setupTextFields() {
        [nameTextField, pronounsTextField, hometownTextField, classTextField, phoneNumTextField, snackTextField, songTextField, stopTextField].forEach { textField in
            textField.textField.delegate = self
            textField.hidesLabel(isHidden: false)
        }
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
    }
    
    // MARK: - Helper Functions

    @objc private func deleteAccount() {
        deleteUserRequest(
            firstName: user?.firstName ?? "",
            lastName: user?.lastName ?? "",
            grade: user?.grade,
            phoneNumber: user?.phoneNumber,
            pronouns: user?.pronouns,
            prompts: getUserAnswers()
        )

        let loginVC = LoginViewController()
        loginVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(loginVC, animated: false)
    }

    @objc private func cancelEdit() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func saveEdit() {
        let name = nameTextField.getText()?.split(separator: " ")
        let firstName = String(name?[0] ?? "")
        let lastName = String(name?[1...].joined(separator: " ") ?? "")
        let grade = classTextField.getText()
        let pronouns = pronounsTextField.getText()
        let phoneNumber = phoneNumTextField.getText()

        hometown = hometownTextField.getText()
        talkative = talkativeSlider.value
        music = musicSlider.value
        snack = snackTextField.getText()
        song = songTextField.getText()
        stop = stopTextField.getText()

        updateAuthenticatedUserRequest(firstName: firstName, lastName: lastName, grade: grade, phoneNumber: phoneNumber, pronouns: pronouns, prompts: getUserAnswers())

        self.navigationController?.popViewController(animated: true)
    }

    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }

    private func dismissKeyboardFromPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
    }

    @objc private func updateProfileImage(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true)
    }

    private func getUserAnswers() -> [UserAnswer] {
        var userAnswers: [UserAnswer] = []

        user?.prompts.forEach { prompt in
            switch prompt.questionName {
            case .hometown:
                userAnswers.append(UserAnswer(id: prompt.id, answer: hometown ?? ""))
            case .music:
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(music ?? 0.5)))
            case .song:
                userAnswers.append(UserAnswer(id: prompt.id, answer: song ?? ""))
            case .snack:
                userAnswers.append(UserAnswer(id: prompt.id, answer: snack ?? ""))
            case .stop:
                userAnswers.append(UserAnswer(id: prompt.id, answer: stop ?? ""))
            case .talkative:
                userAnswers.append(UserAnswer(id: prompt.id, answer: String(talkative ?? 0.5)))
            }
        }

        return userAnswers
    }

    // MARK: - Requests

    private func updateAuthenticatedUserRequest(
        firstName: String,
        lastName: String,
        grade: String?,
        phoneNumber: String?,
        pronouns: String?,
        prompts: [UserAnswer]
    ) {
        NetworkManager.shared.updateAuthenticatedUser(
            netid: user?.netid ?? "",
            first_name: firstName,
            last_name: lastName,
            grade: grade ?? "",
            phone_number: phoneNumber ?? "",
            pronouns: pronouns ?? "",
            prof_pic: user?.profilePicUrl ?? "",
            prompts: prompts
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

    private func deleteUserRequest(
        firstName: String,
        lastName: String,
        grade: String?,
        phoneNumber: String?,
        pronouns: String?,
        prompts: [UserAnswer]
    ) {
        NetworkManager.shared.deleteUser(
            netid: user?.netid ?? "",
            first_name: firstName,
            last_name: lastName,
            grade: grade ?? "",
            phone_number: phoneNumber ?? "",
            pronouns: pronouns ?? "",
            prof_pic: user?.profilePicUrl ?? "",
            prompts: prompts
        ) { result in
            switch result {
            case .success(let user):
                print("Deleted user \(user.firstName) \(user.lastName)")
            case .failure(let error):
                print("Error in EditProfileViewController: \(error.localizedDescription)")
            }
        }
    }

}


// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(textField == classTextField || textField == pronounsTextField)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
            associatedView.hidesLabel(isHidden: false)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: false)
            if textField.text?.isEmpty ?? true {
                associatedView.hidesLabel(isHidden: true)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

}

// MARK: - UIPickerViewDelegate

extension EditProfileViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pronounsPicker {
            return pronouns[row]
        } else if pickerView == classPicker {
            return years[row]
        }

        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pronounsPicker {
            pronounsTextField.textField.text = pronouns[row]
        } else if pickerView == classPicker {
            classTextField.textField.text = years[row]
        }
    }

}

// MARK: - UIPickerViewDataSource

extension EditProfileViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pronounsPicker {
            return pronouns.count
        } else if pickerView == classPicker {
            return years.count
        }

        return 0
    }

}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        profileImageView.image = image

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

