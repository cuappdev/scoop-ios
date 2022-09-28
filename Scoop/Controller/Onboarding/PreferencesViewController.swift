//
//  PreferencesViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PreferencesViewController: OnboardingViewController {

    private let stackView = UIStackView()
    private let talkativeSlider = UISlider()
    private let musicSlider = UISlider()
    private let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "During Roadtrips"
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            Networking.shared.currentUser.talkingPref = self.talkativeSlider.value
            Networking.shared.currentUser.musicPref = self.musicSlider.value
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupStackView()
        setupNextButton(view: self.view, action: nextAction ?? UIAction(handler: { _ in
            return
        }), button: nextButton)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.center.equalToSuperview()
        }
        
        let talkingLabel = UILabel()
        talkingLabel.font = .systemFont(ofSize: 22)
        talkingLabel.text = "How talkative are you?"
        talkingLabel.numberOfLines = 2
        talkingLabel.textColor = .black
        stackView.addArrangedSubview(talkingLabel)
        
        createTalkingSlider()
        
        let musicLabel = UILabel()
        musicLabel.font = .systemFont(ofSize: 22)
        musicLabel.text = "Do you like listening to music?"
        musicLabel.numberOfLines = 2
        musicLabel.textColor = .black
        stackView.addArrangedSubview(musicLabel)
        
        createMusicSlider()
    }
    
    private func createTalkingSlider() {
        let talkingView = UIView()
        stackView.addArrangedSubview(talkingView)
        
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
        
        talkativeSlider.minimumTrackTintColor = .black
        talkativeSlider.maximumTrackTintColor = .systemGray5
        stackView.addArrangedSubview(talkativeSlider)
        
        talkativeSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func createMusicSlider() {
        let musicView = UIView()
        stackView.addArrangedSubview(musicView)
        
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
        
        musicSlider.minimumTrackTintColor = .black
        musicSlider.maximumTrackTintColor = .systemGray5
        stackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
