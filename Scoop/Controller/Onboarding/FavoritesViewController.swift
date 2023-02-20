//
//  FavoritesViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class FavoritesViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let snackTextField = OnboardingTextField()
    private let songTextField = OnboardingTextField()
    private let stopTextField = OnboardingTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "Favorites")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else { return }
    
            guard let snack = self.snackTextField.text, !snack.isEmpty,
                  let song = self.songTextField.text, !song.isEmpty,
                  let stop = self.stopTextField.text, !stop.isEmpty else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      
                      return
                  }
            
            NetworkManager.shared.currentUser.favoriteSnack = snack
            NetworkManager.shared.currentUser.favoriteSong = song
            NetworkManager.shared.currentUser.favoriteStop = stop
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    private func setupStackView() {
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        let leadingTrailingInset = 25
        let spacing = 12.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        let songLabel = UILabel()
        songLabel.text = "ROADTRIP SONG"
        songLabel.accessibilityLabel = "roadtrip song"
        songLabel.textColor = .black
        stackView.addArrangedSubview(songLabel)
        stackView.setCustomSpacing(spacing, after: songLabel)
        
        songTextField.textColor = .darkGray
        songTextField.placeholder = "Enter song..."
        stackView.addArrangedSubview(songTextField)
        songTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let snackLabel = UILabel()
        snackLabel.text = "ROADTRIP SNACK"
        snackLabel.accessibilityLabel = "roadtrip snack"
        snackLabel.textColor = .black
        stackView.addArrangedSubview(snackLabel)
        stackView.setCustomSpacing(spacing, after: snackLabel)
        
        snackTextField.textColor = .darkGray
        snackTextField.placeholder = "Enter snack..."
        stackView.addArrangedSubview(snackTextField)
        snackTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let stopLabel = UILabel()
        stopLabel.text = "ROADTRIP STOP"
        stopLabel.accessibilityLabel = "roadtrip stop"
        stopLabel.textColor = .black
        stackView.addArrangedSubview(stopLabel)
        stackView.setCustomSpacing(spacing, after: stopLabel)
        
        stopTextField.textColor = .darkGray
        stopTextField.placeholder = "Enter stop..."
        stackView.addArrangedSubview(stopTextField)
        stopTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        [songLabel, snackLabel, stopLabel].forEach { label in
            label.font = UIFont(name: "Rambla-Regular", size: 16)
        }
        
        [songTextField, snackTextField, stopTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.textFieldBorderColor
            text.layer.cornerRadius = textFieldCornerRadius
            text.font = textFieldFont
        }
    }
}
