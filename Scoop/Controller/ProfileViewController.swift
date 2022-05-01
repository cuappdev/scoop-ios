//
//  ProfileViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let containerView = UIView()
    private let headerImageView = UIImageView()
    private let profileImageView = UIImageView()
    private let profileStackView = UIStackView()
    private let detailsStackView = UIStackView()
    private let travelingStackView = UIStackView()
    private let favoritesStackView = UIStackView()
    
    private let user = Networking.shared.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        setupHeaderImage()
        setupContainerView()
        setupEditButton()
        setupProfileImageView()
        setupProfileStackView()
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
        }
    }
    
    private func setupEditButton() {
        let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)), for: .normal)
        editButton.tintColor = .scoopGreen
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
        profileImageView.image = user.image
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
        profileStackView.spacing = 20
        profileStackView.alignment = .center
        view.addSubview(profileStackView)
        
        profileStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = user.name
        profileStackView.addArrangedSubview(nameLabel)
        profileStackView.setCustomSpacing(10, after: nameLabel)
        
        let subLabel = UILabel()
        subLabel.font = .systemFont(ofSize: 14)
        subLabel.textAlignment = .center
        subLabel.adjustsFontSizeToFitWidth = true
        subLabel.text = "(\(user.pronouns)) | \(user.year)"
        profileStackView.addArrangedSubview(subLabel)
        
        let hometownSection = ImageLabelView()
        hometownSection.label.font = .systemFont(ofSize: 14)
        hometownSection.label.text = "Hometown: \(user.hometown)"
        hometownSection.imageView.image = UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        profileStackView.addArrangedSubview(hometownSection)
        
        setupDetailsStackView()
    }
    
    private func setupDetailsStackView() {
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .fill
        detailsStackView.spacing = 20
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
        travelingLabel.font = .systemFont(ofSize: 18)
        travelingLabel.text = "Traveling Preferences"
        detailsStackView.addArrangedSubview(travelingLabel)
        
        let travelingContainerView = UIView()
        travelingContainerView.backgroundColor = .systemGray5
        travelingContainerView.layer.cornerRadius = 16
        detailsStackView.addArrangedSubview(travelingContainerView)
        
        travelingContainerView.snp.makeConstraints { make in
            make.width.equalTo(detailsStackView)
        }
        
        travelingStackView.axis = .vertical
        travelingStackView.distribution = .fill
        travelingStackView.spacing = 10
        travelingStackView.alignment = .leading
        travelingContainerView.addSubview(travelingStackView)
        
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
        quietLabel.font = .systemFont(ofSize: 12)
        quietLabel.text = "Quiet"
        quietLabel.textAlignment = .left
        talkingView.addSubview(quietLabel)
        
        quietLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let talkativeLabel = UILabel()
        talkativeLabel.font = .systemFont(ofSize: 12)
        talkativeLabel.text = "Talkative"
        talkativeLabel.textAlignment = .right
        talkingView.addSubview(talkativeLabel)
        
        talkativeLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        let talkativeSlider = UISlider()
        talkativeSlider.isUserInteractionEnabled = false
        talkativeSlider.value = user.talkingPref
        talkativeSlider.minimumTrackTintColor = .black
        talkativeSlider.maximumTrackTintColor = .systemGray3
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
        noMusicLabel.font = .systemFont(ofSize: 12)
        noMusicLabel.text = "No Music"
        noMusicLabel.textAlignment = .left
        musicView.addSubview(noMusicLabel)
        
        noMusicLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let musicLabel = UILabel()
        musicLabel.font = .systemFont(ofSize: 12)
        musicLabel.text = "Music"
        musicLabel.textAlignment = .right
        musicView.addSubview(musicLabel)
        
        musicLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        let musicSlider = UISlider()
        musicSlider.value = user.musicPref
        musicSlider.minimumTrackTintColor = .black
        musicSlider.maximumTrackTintColor = .systemGray3
        travelingStackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func setupFavoritesView() {
        let favoritesLabel = UILabel()
        favoritesLabel.font = .systemFont(ofSize: 18)
        favoritesLabel.text = "Roadtrip Favorites"
        detailsStackView.addArrangedSubview(favoritesLabel)
        
        let favoritesContainerView = UIView()
        favoritesContainerView.backgroundColor = .systemGray5
        favoritesContainerView.layer.cornerRadius = 16
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
        
        let songSection = ImageLabelView()
        songSection.label.font = .systemFont(ofSize: 14)
        songSection.label.text = "Song: \(user.favoriteSong)"
        songSection.label.adjustsFontSizeToFitWidth = true
        songSection.imageView.image = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(songSection)
        
        let snackSection = ImageLabelView()
        snackSection.label.font = .systemFont(ofSize: 14)
        snackSection.label.text = "Snack: \(user.favoriteSnack)"
        snackSection.label.adjustsFontSizeToFitWidth = true
        snackSection.imageView.image = UIImage(systemName: "bag", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(snackSection)
        
        let stopSection = ImageLabelView()
        stopSection.label.font = .systemFont(ofSize: 14)
        stopSection.label.text = "Stop: \(user.favoriteStop)"
        stopSection.label.adjustsFontSizeToFitWidth = true
        stopSection.imageView.image = UIImage(systemName: "xmark.octagon", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        favoritesStackView.addArrangedSubview(stopSection)
    }

}
