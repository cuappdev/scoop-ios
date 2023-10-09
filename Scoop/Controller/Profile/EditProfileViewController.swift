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
    private let classPickerView = UIPickerView()
    private let emailButton = UIButton()
    private let hometownTextField = UITextField()
    private let musicSlider = UISlider()
    private let musicTicks = UIButton()
    private let musicView = UIView()
    private let nameTextField = UITextField()
    private let phoneButton = UIButton()
    private let phoneNumTextField = UITextField()
    private let profileImageView = UIImageView()
    private let pronounsTextField = UITextField()
    private let snackTextField = UITextField()
    private let songTextField = UITextField()
    private let stopTextField = UITextField()
    private let talkativeSlider = UISlider()
    private let talkativeView = UIView()
    private let talkativeTicks = UIButton()
    private let uploadPhotoButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
    
    private let leadingTrailingInset = 32
    private let textFieldHeight = 56
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupHeader()
        setupScrollView()
        setupContentView()
        setupProfileImageView()
        setupUploadPhotoButton()
        setupAboutYouStackView()
        setupPreferredContactStackView()
        setupPreferencesStackView()
        setupFavoritesStackView()
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
    
    init(user: BaseUser, hometown: String, talkative: Float, music: Float, snack: String, song: String, stop: String) {
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
        phoneNumTextField.text = user.phoneNumber
        talkativeSlider.setValue(talkative, animated: false)
        musicSlider.setValue(music, animated: false)
        snackTextField.text = snack
        songTextField.text = song
        stopTextField.text = stop
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
    
    private func setupScrollView() {
        scrollView.contentSize = CGSizeMake(contentView.frame.width, contentView.frame.height * 2)
        scrollView.isScrollEnabled = true
        print("\(contentView.bounds.height) and \(contentView.bounds.width)")
        print("\(scrollView.bounds.height) and \(scrollView.bounds.width)")
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        let contentViewHeight = 1500   // TODO: What should this be?
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(contentViewHeight)
        }
    }
    
    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.scoopGreen.cgColor
        profileImageView.layer.borderWidth = 3
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupUploadPhotoButton() {
        uploadPhotoButton.setImage(UIImage.profileButton, for: .normal)
        uploadPhotoButton.backgroundColor = UIColor.gray
        uploadPhotoButton.contentMode = .scaleAspectFill
        uploadPhotoButton.clipsToBounds = true
        contentView.addSubview(uploadPhotoButton)
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(96)
            make.size.equalTo(26)
            make.leading.equalTo(profileImageView).offset(85)
            make.trailing.equalTo(profileImageView).offset(-9)
        }
    }

    private func setupAboutYouStackView() {
        aboutYouStackView.axis = .vertical
        aboutYouStackView.distribution = .fill
        aboutYouStackView.alignment = .leading
        aboutYouStackView.spacing = 24
        contentView.addSubview(aboutYouStackView)
        
        aboutYouStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        nameTextField.font = UIFont.bodyNormal
        nameTextField.textColor = UIColor.black
        nameTextField.borderStyle = .roundedRect
        aboutYouStackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        pronounsTextField.attributedPlaceholder = NSAttributedString(
            string: "Pronouns",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        pronounsTextField.font = UIFont.bodyNormal
        pronounsTextField.textColor = UIColor.black
        pronounsTextField.borderStyle = .roundedRect
        aboutYouStackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        hometownTextField.attributedPlaceholder = NSAttributedString(
            string: "Hometown",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        hometownTextField.font = UIFont.bodyNormal
        hometownTextField.textColor = UIColor.black
        hometownTextField.borderStyle = .roundedRect
        aboutYouStackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        classTextField.attributedPlaceholder = NSAttributedString(
            string: "Class Year",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        classTextField.font = UIFont.bodyNormal
        classTextField.textColor = UIColor.black
        classTextField.borderStyle = .roundedRect
        aboutYouStackView.addArrangedSubview(classTextField)
        
        classTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
    private func setupPreferredContactStackView() {
        preferredContactStackView.axis = .vertical
        preferredContactStackView.distribution = .fill
        preferredContactStackView.alignment = .leading
        preferredContactStackView.spacing = 20

        contentView.addSubview(preferredContactStackView)
        
        preferredContactStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(aboutYouStackView.snp.bottom).offset(50)
        }

        let titleLabel = UILabel()
        titleLabel.font = UIFont.subheader
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
        emailButton.titleLabel?.font = UIFont.bodyNormal
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
        
        phoneButton.setTitle("Phone", for: .normal)
        phoneButton.setTitleColor(UIColor.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont.bodyNormal
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

            if emailButton.isSelected {
                phoneNumTextField.isHidden = true
            } else {
                phoneNumTextField.isHidden = false
            }
        }

        emailButton.addAction(selectContactAction, for: .touchUpInside)
        phoneButton.addAction(selectContactAction, for: .touchUpInside)
        
        phoneNumTextField.isHidden = true
        phoneNumTextField.font = UIFont.bodyNormal
        phoneNumTextField.textColor = UIColor.offBlack
        phoneNumTextField.placeholder = "000-000-0000"
        phoneNumTextField.borderStyle = .roundedRect
        phoneNumTextField.font = UIFont.bodyNormal
        phoneNumTextField.keyboardType = .phonePad
        contentView.addSubview(phoneNumTextField)

        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneButton.snp.bottom).inset(-18)
            make.trailing.equalToSuperview().inset(36)
            make.leading.equalTo(phoneButton).inset(34)
            make.height.equalTo(textFieldHeight)
        }
    }
    
    private func setupPreferencesStackView() {
        preferencesStackView.axis = .vertical
        preferencesStackView.distribution = .fill
        preferencesStackView.alignment = .leading
        preferencesStackView.spacing = 12
        contentView.addSubview(preferencesStackView)
        
        preferencesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(preferredContactStackView.snp.bottom).offset(50)
        }
        
        let talkativeTitleLabel = UILabel()
        talkativeTitleLabel.font = UIFont.subheader
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
        musicTitleLabel.font = UIFont.subheader
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
        preferencesStackView.addArrangedSubview(talkativeView)
        
        talkativeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(27)
            make.trailing.equalToSuperview()
        }
        
        let quietLabel = UILabel()
        quietLabel.text = "Quiet"
        quietLabel.textColor = UIColor.black
        quietLabel.font = UIFont.bodyNormal
        quietLabel.textAlignment = .left
        quietLabel.adjustsFontSizeToFitWidth = true
        talkativeView.addSubview(quietLabel)
        
        quietLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        let talkativeLabel = UILabel()
        talkativeLabel.text = "Talkative"
        talkativeLabel.textColor = UIColor.black
        talkativeLabel.font = UIFont.bodyNormal
        talkativeLabel.textAlignment = .right
        talkativeLabel.adjustsFontSizeToFitWidth = true
        talkativeView.addSubview(talkativeLabel)
        
        talkativeLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        talkativeSlider.minimumTrackTintColor = UIColor.black
        talkativeSlider.maximumTrackTintColor = UIColor.black
        talkativeSlider.setThumbImage(UIImage.sliderThumb, for: .normal)
        preferencesStackView.addArrangedSubview(talkativeSlider)
        
        talkativeSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(27)
        }
        
        talkativeTicks.setImage(UIImage.sliderTicks, for: .normal)
        talkativeSlider.addSubview(talkativeTicks)
        talkativeSlider.sendSubviewToBack(talkativeTicks)
        
        talkativeTicks.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupMusicSliderView() {
        preferencesStackView.addArrangedSubview(musicView)
        
        musicView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(27)
            make.trailing.equalToSuperview()
        }
        
        let noMusicLabel = UILabel()
        noMusicLabel.text = "No music"
        noMusicLabel.textColor = UIColor.black
        noMusicLabel.font = UIFont.bodyNormal
        noMusicLabel.textAlignment = .left
        noMusicLabel.adjustsFontSizeToFitWidth = true
        musicView.addSubview(noMusicLabel)
        
        noMusicLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        let musicLabel = UILabel()
        musicLabel.text = "Music"
        musicLabel.textColor = UIColor.black
        musicLabel.font = UIFont.bodyNormal
        musicLabel.textAlignment = .right
        musicLabel.adjustsFontSizeToFitWidth = true
        musicView.addSubview(musicLabel)
        
        musicLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        musicSlider.minimumTrackTintColor = UIColor.black
        musicSlider.maximumTrackTintColor = UIColor.black
        musicSlider.setThumbImage(UIImage.sliderThumb, for: .normal)
        preferencesStackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(27)
        }
        
        musicTicks.setImage(UIImage.sliderTicks, for: .normal)
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
        contentView.addSubview(favoritesStackView)
        
        favoritesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(preferencesStackView.snp.bottom).offset(50)
        }
        
        snackTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip snack",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        snackTextField.font = UIFont.bodyNormal
        snackTextField.textColor = UIColor.black
        snackTextField.borderStyle = .roundedRect
        favoritesStackView.addArrangedSubview(snackTextField)
        
        snackTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        songTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip song",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        songTextField.font = UIFont.bodyNormal
        songTextField.textColor = UIColor.black
        songTextField.borderStyle = .roundedRect
        favoritesStackView.addArrangedSubview(songTextField)
        
        songTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        stopTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip stop",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.mutedGrey])
        stopTextField.font = UIFont.bodyNormal
        stopTextField.textColor = UIColor.black
        stopTextField.borderStyle = .roundedRect
        favoritesStackView.addArrangedSubview(stopTextField)
        
        stopTextField.snp.makeConstraints { make in
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
        let phoneNumber = phoneNumTextField.text
        
        hometown = hometownTextField.text
        talkative = talkativeSlider.value
        music = musicSlider.value
        snack = snackTextField.text
        song = songTextField.text
        stop = stopTextField.text
        
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
        
        // MARK: - Requests
        
        NetworkManager.shared.updateAuthenticatedUser(
            netid: user?.netid ?? "",
            first_name: firstName,
            last_name: lastName,
            grade: grade ?? "",
            phone_number: phoneNumber ?? "",
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
                guard let musicFloat = Float(prompt.answer ?? "0.5") else { return }
                music = musicFloat
            case .song:
                song = prompt.answer
            case .snack:
                snack = prompt.answer
            case .stop:
                stop = prompt.answer
            case .talkative:
                guard let talkativeFloat = Float(prompt.answer ?? "0.5") else { return }
                talkative = talkativeFloat
            }
        }
    }
    
}