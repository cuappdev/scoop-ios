//
//  ProfileViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import SDWebImage
import UIKit

protocol ProfileViewDelegate: AnyObject {
    func updateUserProfile()
    func updateDriverProfile()
    func updateProfileText(user: BaseUser)
}

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    // MARK: - Views
    
    private let actionsButton = UIButton()
    private let containerView = UIView()
    private let headerImageView = UIImageView()
    private let profileImageView = UIImageView()
    private let profileStackView = UIStackView()
    private let detailsStackView = UIStackView()
    private let travelingStackView = UIStackView()
    private let favoritesStackView = UIStackView()
    
    private let musicSlider = UISlider()
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let snackSection = ImageLabelView()
    private let songSection = ImageLabelView()
    private let stopSection = ImageLabelView()
    private let subLabel = UILabel()
    private let talkativeSlider = UISlider()
    
    // MARK: - User Data
    
    private var user: BaseUser
    
    private var hometown: String?
    private var talkative: Float?
    private var music: Float?
    private var snack: String?
    private var song: String?
    private var stop: String?
    
    // MARK: - Initializers
    
    init(user: BaseUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        getUserPreferences()
        setupHeaderImage()
        setupContainerView()
        setupProfileImageView()
        setupProfileStackView()
        isBeingPresented ? updateDriverProfile() : updateUserProfile()
        isBeingPresented ? setupActionsButton() : setupEditButton()
    }
    
    // MARK: - Setup View Functions
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 24
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(125)
        }
    }
    
    private func setupHeaderImage() {
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.image = UIImage(named: "ProfileHeader")
        view.addSubview(headerImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    private func setupActionsButton() {
        actionsButton.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)), for: .normal)
        actionsButton.tintColor = .black
        actionsButton.addTarget(self, action: #selector(presentActionOptions), for: .touchUpInside)
        containerView.addSubview(actionsButton)
        
        actionsButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupEditButton() {
        let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)), for: .normal)
        editButton.tintColor = UIColor.black
        editButton.imageView?.contentMode = .scaleAspectFit
        containerView.addSubview(editButton)
        
        editButton.addTarget(self, action: #selector(pushEditProfileVC), for: .touchUpInside)
        
        editButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupProfileImageView() {
        profileImageView.backgroundColor = .systemGray3
        profileImageView.layer.cornerRadius = 60
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.scooped.scoopGreen.cgColor
        profileImageView.layer.borderWidth = 3
        view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(containerView.snp.top)
        }
    }
    
    private func setupProfileStackView() {
        profileStackView.axis = .vertical
        profileStackView.distribution = .fill
        profileStackView.spacing = 8
        profileStackView.alignment = .center
        view.addSubview(profileStackView)
        
        profileStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        profileStackView.addArrangedSubview(nameLabel)
        profileStackView.setCustomSpacing(10, after: nameLabel)
        
        subLabel.font = .systemFont(ofSize: 14)
        subLabel.textColor = UIColor.scooped.primaryGrey
        subLabel.textAlignment = .center
        subLabel.adjustsFontSizeToFitWidth = true
        profileStackView.addArrangedSubview(subLabel)
        
        phoneLabel.font = .systemFont(ofSize: 14)
        profileStackView.addArrangedSubview(phoneLabel)
        
        setupDetailsStackView()
    }
    
    private func setupDetailsStackView() {
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .fill
        detailsStackView.spacing = 8
        detailsStackView.alignment = .leading
        view.addSubview(detailsStackView)
        
        detailsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(40)
        }
        
        setupTravelingView()
        setupFavoritesView()
    }
    
    private func setupTravelingView() {
        let travelingLabel = UILabel()
        travelingLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        travelingLabel.text = "TRAVELING PREFERENCES"
        detailsStackView.addArrangedSubview(travelingLabel)
        
        let travelingContainerView = UIView()
        travelingContainerView.backgroundColor = UIColor.white
        travelingContainerView.addDropShadow()
        travelingContainerView.layer.cornerRadius = 10
        detailsStackView.addArrangedSubview(travelingContainerView)
        
        travelingContainerView.snp.makeConstraints { make in
            make.width.equalTo(detailsStackView)
        }
        
        travelingStackView.axis = .vertical
        travelingStackView.distribution = .fill
        travelingStackView.spacing = 10
        travelingStackView.alignment = .leading
        travelingContainerView.addSubview(travelingStackView)
        
        detailsStackView.setCustomSpacing(32, after: travelingContainerView)
        
        travelingStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        createTalkingSlider()
        createMusicSlider()
    }
    
    private func createTalkingSlider() {
        let talkingView = UIView()
        travelingStackView.addArrangedSubview(talkingView)
        travelingStackView.setCustomSpacing(5, after: talkingView)
        
        talkingView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let quietLabel = UILabel()
        quietLabel.font = .systemFont(ofSize: 14)
        quietLabel.text = "Quiet"
        quietLabel.textAlignment = .left
        talkingView.addSubview(quietLabel)
        
        quietLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let talkativeLabel = UILabel()
        talkativeLabel.font = .systemFont(ofSize: 14)
        talkativeLabel.text = "Talkative"
        talkativeLabel.textAlignment = .right
        talkingView.addSubview(talkativeLabel)
        
        talkativeLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        talkativeSlider.isUserInteractionEnabled = false
        talkativeSlider.minimumTrackTintColor = UIColor.black
        talkativeSlider.maximumTrackTintColor = UIColor.black
        talkativeSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        talkativeSlider.setMaximumTrackImage(UIImage(named: "track"), for: .normal)
        talkativeSlider.setMinimumTrackImage(UIImage(named: "track"), for: .normal)
        travelingStackView.addArrangedSubview(talkativeSlider)
        
        talkativeSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func createMusicSlider() {
        let musicView = UIView()
        travelingStackView.addArrangedSubview(musicView)
        travelingStackView.setCustomSpacing(5, after: musicView)
        
        musicView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let noMusicLabel = UILabel()
        noMusicLabel.font = .systemFont(ofSize: 14)
        noMusicLabel.text = "No music"
        noMusicLabel.textAlignment = .left
        musicView.addSubview(noMusicLabel)
        
        noMusicLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let musicLabel = UILabel()
        musicLabel.font = .systemFont(ofSize: 14)
        musicLabel.text = "Music"
        musicLabel.textAlignment = .right
        musicView.addSubview(musicLabel)
        
        musicLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        musicSlider.isUserInteractionEnabled = false
        musicSlider.minimumTrackTintColor = UIColor.black
        musicSlider.maximumTrackTintColor = UIColor.black
        musicSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        musicSlider.setMaximumTrackImage(UIImage(named: "track"), for: .normal)
        musicSlider.setMinimumTrackImage(UIImage(named: "track"), for: .normal)
        travelingStackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func setupFavoritesView() {
        let favoritesLabel = UILabel()
        favoritesLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        favoritesLabel.text = "ROADTRIP FAVORITES"
        detailsStackView.addArrangedSubview(favoritesLabel)
        
        let favoritesContainerView = UIView()
        favoritesContainerView.backgroundColor = UIColor.white
        favoritesContainerView.addDropShadow()
        favoritesContainerView.layer.cornerRadius = 10
        detailsStackView.addArrangedSubview(favoritesContainerView)
        
        favoritesContainerView.snp.makeConstraints { make in
            make.width.equalTo(detailsStackView)
        }
        
        favoritesStackView.axis = .vertical
        favoritesStackView.distribution = .fill
        favoritesStackView.spacing = 10
        favoritesStackView.alignment = .leading
        favoritesContainerView.addSubview(favoritesStackView)
        
        favoritesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        songSection.label.font = .systemFont(ofSize: 14)
        songSection.label.adjustsFontSizeToFitWidth = true
        songSection.imageView.image = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(songSection)
        
        snackSection.label.font = .systemFont(ofSize: 14)
        snackSection.label.adjustsFontSizeToFitWidth = true
        snackSection.imageView.image = UIImage(systemName: "fork.knife", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(snackSection)
        
        stopSection.label.font = .systemFont(ofSize: 14)
        stopSection.label.adjustsFontSizeToFitWidth = true
        stopSection.imageView.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(stopSection)
    }
    
    // MARK: - Helper Functions
    
    @objc private func presentActionOptions() {
        let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.scooped.scoopDarkGreen

        alert.addAction(UIAlertAction(title: "Report user", style: .default, handler: { [self] _ in
            let reportVC = ReportUserViewController(user: user, height: view.frame.height * 7 / 8)
            present(reportVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Block user", style: .default, handler: { [self] _ in
            let blockVC = BlockUserViewController(user: user, height: view.frame.height / 2)
            present(blockVC, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func pushEditProfileVC() {
        let editProfileVC = EditProfileViewController(user: user, hometown: hometown ?? "", talkative: talkative ?? 0.5, music: music ?? 0.5, snack: snack ?? "", song: song ?? "", stop: stop ?? "")
        editProfileVC.delegate = self
        editProfileVC.hidesBottomBarWhenPushed = true
        editProfileVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func getUserPreferences() {
        user.prompts.forEach { prompt in
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
    
    func updateProfileText(user: BaseUser) {
        self.user = user
        getUserPreferences()
        
        guard let imageURL = user.profilePicUrl,
              let pronouns = user.pronouns,
              let grade = user.grade,
              let hometown = self.hometown else { return }
        
        profileImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage.scooped.emptyImage)
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        subLabel.text = "\(pronouns) • \(grade) • \(hometown)"
        phoneLabel.text = user.phoneNumber
        talkativeSlider.value = talkative ?? 0
        musicSlider.value = music ?? 0
        songSection.label.attributedText = makeBoldNormalText(bold: "Song / ", normal: song ?? "")
        snackSection.label.attributedText = makeBoldNormalText(bold: "Snack / ", normal: snack ?? "")
        stopSection.label.attributedText = makeBoldNormalText(bold: "Stop / ", normal: stop ?? "")
    }
    
    func updateUserProfile() {
        NetworkManager.shared.getUser { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let user):
                NetworkManager.shared.currentUser = user
                strongSelf.user = user
                strongSelf.getUserPreferences()
                guard let imageURL = user.profilePicUrl,
                      let pronouns = user.pronouns,
                      let grade = user.grade,
                      let hometown = strongSelf.hometown else { return }
                
                strongSelf.profileImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage.scooped.emptyImage)
                strongSelf.nameLabel.text = "\(user.firstName) \(user.lastName)"
                strongSelf.subLabel.text = "\(pronouns) • \(grade) • \(hometown)"
                strongSelf.phoneLabel.text = user.phoneNumber
                strongSelf.talkativeSlider.value = strongSelf.talkative ?? 0
                strongSelf.musicSlider.value = strongSelf.music ?? 0
                strongSelf.songSection.label.attributedText = strongSelf.makeBoldNormalText(bold: "Song / ", normal: strongSelf.song ?? "")
                strongSelf.snackSection.label.attributedText = strongSelf.makeBoldNormalText(bold: "Snack / ", normal: strongSelf.snack ?? "")
                strongSelf.stopSection.label.attributedText = strongSelf.makeBoldNormalText(bold: "Stop / ", normal: strongSelf.stop ?? "")
            case .failure(let error):
                print("Error in ProfileViewController: \(error.localizedDescription)")
            }
        }
    }
    
    func updateDriverProfile() {
        getUserPreferences()
        guard let imageURL = user.profilePicUrl,
              let pronouns = user.pronouns,
              let grade = user.grade,
              let hometown = self.hometown else { return }
    
        profileImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage.scooped.emptyImage)
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        subLabel.text = "\(pronouns) • \(grade) • \(hometown)"
        phoneLabel.text = user.phoneNumber
        talkativeSlider.value = self.talkative ?? 0.5
        musicSlider.value = self.music ?? 0.5
        songSection.label.attributedText = self.makeBoldNormalText(bold: "Song / ", normal: self.song ?? "")
        snackSection.label.attributedText = self.makeBoldNormalText(bold: "Snack / ", normal: self.snack ?? "")
        stopSection.label.attributedText = self.makeBoldNormalText(bold: "Stop / ", normal: self.stop ?? "")
    }
    
    func makeBoldNormalText(bold: String, normal: String) -> NSAttributedString {
        let normalString = NSMutableAttributedString(string: normal)
        let boldString = NSMutableAttributedString(string: bold, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        boldString.append(normalString)
        return boldString
    }

}
