//
//  PreferencesViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PreferencesViewController: OnboardingViewController {
    
    // MARK: - Views
    private let stackView = UIStackView()
    private let talkativeSlider = UISlider()
    private let musicSlider = UISlider()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "During roadtrips...")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            self.addPrompt(name: "Talkative", placeholder: "0", answer: String(self.talkativeSlider.value))
            self.addPrompt(name: "Music", placeholder: "0", answer: String(self.musicSlider.value))
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        backButton.isHidden = false
        setupStackView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
        setNextButtonColor(disabled: false)
    }
    
    // MARK: - Setup View Functions
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(47)
            make.center.equalToSuperview()
        }
        
        let talkingLabelIndent = UILabel()
        stackView.addArrangedSubview(talkingLabelIndent)
        talkingLabelIndent.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let talkingLabel = UILabel()
        talkingLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        talkingLabel.text = "HOW TALKATIVE ARE YOU?"
        talkingLabel.accessibilityLabel = "how talkative are you?"
        talkingLabel.numberOfLines = 2
        talkingLabel.textColor = .black
        view.addSubview(talkingLabel)
        talkingLabel.snp.makeConstraints { make in
            make.top.equalTo(talkingLabelIndent.snp.top)
            make.leading.equalTo(view.snp.leading).inset(20)
        }
        
        createTalkingSlider()
        
        let musicLabelIndent = UILabel()
        stackView.addArrangedSubview(musicLabelIndent)
        musicLabelIndent.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let musicLabel = UILabel()
        musicLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        musicLabel.text = "DO YOU LIKE LISTENING TO MUSIC?"
        musicLabel.accessibilityLabel = "do you like listening to music?"
        musicLabel.numberOfLines = 2
        musicLabel.textColor = .black
        view.addSubview(musicLabel)
        musicLabel.snp.makeConstraints { make in
            make.top.equalTo(musicLabelIndent.snp.top)
            make.leading.equalTo(view.snp.leading).inset(20)
        }
        
        createMusicSlider()
    }
    
    private func createTalkingSlider() {
        let talkingView = UIView()
        stackView.addArrangedSubview(talkingView)
        
        talkingView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let quietLabel = UILabel()
        quietLabel.font = UIFont(name: "SFPro", size: 16)
        quietLabel.text = "Quiet"
        quietLabel.textAlignment = .left
        talkingView.addSubview(quietLabel)
        
        quietLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let talkativeLabel = UILabel()
        talkativeLabel.font = UIFont(name: "SFPro", size: 16)
        talkativeLabel.text = "Talkative"
        talkativeLabel.textAlignment = .right
        talkingView.addSubview(talkativeLabel)
        
        talkativeLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
    
        talkativeSlider.minimumTrackTintColor = .black
        talkativeSlider.maximumTrackTintColor = .black
        talkativeSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        talkativeSlider.value = talkativeSlider.maximumValue / 2
        stackView.addArrangedSubview(talkativeSlider)
        stackView.setCustomSpacing(60, after: talkativeSlider)
        
        talkativeSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let talkativeTicks = UIButton()
        talkativeTicks.setImage(UIImage(named: "SliderTicks"), for: .normal)
        talkativeSlider.addSubview(talkativeTicks)
        talkativeSlider.sendSubviewToBack(talkativeTicks)
        talkativeTicks.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    private func createMusicSlider() {
        let musicView = UIView()
        stackView.addArrangedSubview(musicView)
        
        musicView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let noMusicLabel = UILabel()
        noMusicLabel.font = UIFont(name: "SFPro", size: 16)
        noMusicLabel.text = "No Music"
        noMusicLabel.textAlignment = .left
        musicView.addSubview(noMusicLabel)
        
        noMusicLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        let musicLabel = UILabel()
        musicLabel.font = UIFont(name: "SFPro", size: 16)
        musicLabel.text = "Music"
        musicLabel.textAlignment = .right
        musicView.addSubview(musicLabel)
        
        musicLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        musicSlider.minimumTrackTintColor = .black
        musicSlider.maximumTrackTintColor = .black
        musicSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        musicSlider.value = musicSlider.maximumValue/2
        stackView.addArrangedSubview(musicSlider)
        
        musicSlider.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let musicTicks = UIButton()
        musicTicks.setImage(UIImage(named: "SliderTicks"), for: .normal)
        musicSlider.addSubview(musicTicks)
        musicSlider.sendSubviewToBack(musicTicks)
        musicTicks.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
}
