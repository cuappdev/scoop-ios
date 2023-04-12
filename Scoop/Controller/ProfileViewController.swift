//
//  ProfileViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import SDWebImage
import UIKit

protocol ProfileViewDelegate: AnyObject {
    func updateProfile()
}

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
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
    
    private var user = NetworkManager.shared.currentUser
    
    private var hometown: String?
    private var talkative: Float?
    private var music: Float?
    private var snack: String?
    private var song: String?
    private var stop: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        getUserPreferences()
        setupHeaderImage()
        setupContainerView()
        setupEditButton()
        setupProfileImageView()
        setupProfileStackView()
        updateProfile()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .white
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
    
    private func setupEditButton() {
        let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)), for: .normal)
        editButton.tintColor = .black
        editButton.imageView?.contentMode = .scaleAspectFit
        containerView.addSubview(editButton)
        
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
        profileImageView.layer.borderColor = UIColor.scoopGreen.cgColor
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
        subLabel.textColor = .primaryGrey
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
        travelingContainerView.backgroundColor = .white
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
        talkativeSlider.minimumTrackTintColor = .black
        talkativeSlider.maximumTrackTintColor = .black
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
        musicSlider.minimumTrackTintColor = .black
        musicSlider.maximumTrackTintColor = .black
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
        favoritesContainerView.backgroundColor = .white
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
    
    private func getUserPreferences() {
        NetworkManager.shared.currentUser.prompts.forEach({ prompt in
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
        })
    }
    
    func updateProfile() {
        NetworkManager.shared.getUser { result in
            switch result {
            case .success(let user):
                self.user = user
                self.getUserPreferences()
                guard let imageURL = user.profilePicUrl,
                      let pronouns = user.pronouns,
                      let grade = user.grade,
                      let hometown = self.hometown else { return }
                
                self.profileImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "emptyimage"))
                self.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self.subLabel.text = "\(pronouns) • \(grade) • \(hometown)"
                self.phoneLabel.text = user.phoneNumber
                self.talkativeSlider.value = self.talkative ?? 0
                self.musicSlider.value = self.music ?? 0
                self.songSection.label.attributedText = self.makeBoldNormalText(bold: "Song / ", normal: self.song ?? "")
                self.snackSection.label.attributedText = self.makeBoldNormalText(bold: "Snack / ", normal: self.snack ?? "")
                self.stopSection.label.attributedText = self.makeBoldNormalText(bold: "Stop / ", normal: self.stop ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func makeBoldNormalText(bold: String, normal: String) -> NSAttributedString {
        let normalString = NSMutableAttributedString(string: normal)
        let boldString = NSMutableAttributedString(string: bold, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        boldString.append(normalString)
        return boldString
    }

}
