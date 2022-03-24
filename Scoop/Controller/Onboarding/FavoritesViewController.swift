//
//  FavoritesViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class FavoritesViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let snackTextField = UITextField()
    private let songTextField = UITextField()
    private let stopTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
        
        nextAction = UIAction { _ in
            guard let snack = self.snackTextField.text, !snack.isEmpty,
                  let song = self.songTextField.text, !song.isEmpty,
                  let stop = self.stopTextField.text, !stop.isEmpty else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      
                      return
                  }
            
            Networking.shared.currentUser.favoriteSnack = snack
            Networking.shared.currentUser.favoriteSong = song
            Networking.shared.currentUser.favoriteStop = stop
            
            self.dismiss(animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", image: nil, primaryAction: nextAction, menu: nil)
        
        setupStackView()
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
        
        let songLabel = UILabel()
        songLabel.font = .systemFont(ofSize: 22)
        songLabel.text = "Roadtrip Song"
        songLabel.textColor = .black
        stackView.addArrangedSubview(songLabel)
        
        songTextField.font = .systemFont(ofSize: 22)
        songTextField.textColor = .darkGray
        songTextField.placeholder = "enter song..."
        stackView.addArrangedSubview(songTextField)
        
        let snackLabel = UILabel()
        snackLabel.font = .systemFont(ofSize: 22)
        snackLabel.text = "Roadtrip Snack"
        snackLabel.textColor = .black
        stackView.addArrangedSubview(snackLabel)
        
        snackTextField.font = .systemFont(ofSize: 22)
        snackTextField.textColor = .darkGray
        snackTextField.placeholder = "enter snack..."
        stackView.addArrangedSubview(snackTextField)
        
        let stopLabel = UILabel()
        stopLabel.font = .systemFont(ofSize: 22)
        stopLabel.text = "Roadtrip Stop"
        stopLabel.textColor = .black
        stackView.addArrangedSubview(stopLabel)
        
        stopTextField.font = .systemFont(ofSize: 22)
        stopTextField.textColor = .darkGray
        stopTextField.placeholder = "enter stop..."
        stackView.addArrangedSubview(stopTextField)
    }
}
